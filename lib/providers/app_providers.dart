import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/lottery_result.dart';
import '../models/saved_lottery_number.dart';
import '../repositories/lottery_repository.dart';
import '../repositories/saved_numbers_repository.dart';

final lotteryRepositoryProvider = Provider<LotteryRepository>((ref) {
  return MockLotteryRepository();
});

final lotteryResultsProvider = FutureProvider<List<LotteryResult>>((ref) {
  return ref.watch(lotteryRepositoryProvider).getResults();
});

final latestLotteryResultProvider = FutureProvider<LotteryResult>((ref) {
  return ref.watch(lotteryRepositoryProvider).getLatestResult();
});

final savedNumbersRepositoryProvider = Provider<SavedNumbersRepository>((ref) {
  return PrefsSavedNumbersRepository();
});

final savedNumbersControllerProvider =
    AsyncNotifierProvider<SavedNumbersController, List<SavedLotteryNumber>>(
      SavedNumbersController.new,
    );

class SavedNumbersController extends AsyncNotifier<List<SavedLotteryNumber>> {
  final Uuid _uuid = const Uuid();

  SavedNumbersRepository get _repository {
    return ref.read(savedNumbersRepositoryProvider);
  }

  @override
  Future<List<SavedLotteryNumber>> build() async {
    return _repository.load();
  }

  Future<void> addNumber({
    required String number,
    required String drawDate,
    String note = '',
  }) async {
    final current = state.asData?.value ?? await _repository.load();
    final next = <SavedLotteryNumber>[
      SavedLotteryNumber(
        id: _uuid.v4(),
        number: number,
        drawDate: drawDate,
        note: note.trim().isEmpty ? 'บันทึกจากแอป' : note.trim(),
        createdAt: DateTime.now(),
      ),
      ...current,
    ];

    state = AsyncValue.data(next);
    await _repository.save(next);
  }

  Future<void> deleteNumber(String id) async {
    final current = state.asData?.value ?? await _repository.load();
    final next = current.where((number) => number.id != id).toList();

    state = AsyncValue.data(next);
    await _repository.save(next);
  }
}
