import '../data/mock_data.dart';
import '../models/lottery_result.dart';

abstract class LotteryRepository {
  Future<List<LotteryResult>> getResults();

  Future<LotteryResult> getLatestResult();
}

class MockLotteryRepository implements LotteryRepository {
  @override
  Future<List<LotteryResult>> getResults() async {
    return mockLotteryResults;
  }

  @override
  Future<LotteryResult> getLatestResult() async {
    return mockLotteryResults.first;
  }
}
