class LotteryResult {
  const LotteryResult({
    required this.drawDate,
    required this.firstPrize,
    required this.frontThree,
    required this.backThree,
    required this.lastTwo,
  });

  final String drawDate;
  final String firstPrize;
  final List<String> frontThree;
  final List<String> backThree;
  final String lastTwo;

  LotteryCheckResult check(String number) {
    final normalized = number.trim();
    final hits = <LotteryPrizeHit>[];

    if (normalized.length != 6) {
      return LotteryCheckResult(number: normalized, hits: const []);
    }

    if (normalized == firstPrize) {
      hits.add(const LotteryPrizeHit(label: 'รางวัลที่ 1'));
    }
    if (frontThree.contains(normalized.substring(0, 3))) {
      hits.add(const LotteryPrizeHit(label: 'เลขหน้า 3 ตัว'));
    }
    if (backThree.contains(normalized.substring(3))) {
      hits.add(const LotteryPrizeHit(label: 'เลขท้าย 3 ตัว'));
    }
    if (normalized.substring(4) == lastTwo) {
      hits.add(const LotteryPrizeHit(label: 'เลขท้าย 2 ตัว'));
    }

    return LotteryCheckResult(number: normalized, hits: hits);
  }
}

class LotteryPrizeHit {
  const LotteryPrizeHit({required this.label});

  final String label;
}

class LotteryCheckResult {
  const LotteryCheckResult({required this.number, required this.hits});

  final String number;
  final List<LotteryPrizeHit> hits;

  bool get isWinner => hits.isNotEmpty;

  String get message {
    if (!isWinner) {
      return 'ไม่พบรางวัลในงวดนี้';
    }

    return 'ถูกรางวัล: ${hits.map((hit) => hit.label).join(', ')}';
  }
}
