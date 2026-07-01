import 'package:shared_preferences/shared_preferences.dart';

import '../data/mock_data.dart';
import '../models/saved_lottery_number.dart';

abstract class SavedNumbersRepository {
  Future<List<SavedLotteryNumber>> load();

  Future<void> save(List<SavedLotteryNumber> numbers);
}

class PrefsSavedNumbersRepository implements SavedNumbersRepository {
  static const _key = 'saved_lottery_numbers_v1';

  @override
  Future<List<SavedLotteryNumber>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key);

    if (jsonList == null) {
      final seeded = seedSavedNumbers();
      await save(seeded);
      return seeded;
    }

    return jsonList.map(SavedLotteryNumber.fromJson).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<void> save(List<SavedLotteryNumber> numbers) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      numbers.map((number) => number.toJson()).toList(),
    );
  }
}
