import 'dart:convert';

import 'lottery_result.dart';

enum SavedNumberStatus { waiting, winner, notWinner }

class SavedLotteryNumber {
  const SavedLotteryNumber({
    required this.id,
    required this.number,
    required this.drawDate,
    required this.note,
    required this.createdAt,
  });

  final String id;
  final String number;
  final String drawDate;
  final String note;
  final DateTime createdAt;

  SavedNumberStatus statusFor(LotteryResult latestResult) {
    if (drawDate != latestResult.drawDate) {
      return SavedNumberStatus.waiting;
    }

    return latestResult.check(number).isWinner
        ? SavedNumberStatus.winner
        : SavedNumberStatus.notWinner;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'drawDate': drawDate,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String toJson() => jsonEncode(toMap());

  factory SavedLotteryNumber.fromMap(Map<String, dynamic> map) {
    return SavedLotteryNumber(
      id: map['id'] as String,
      number: map['number'] as String,
      drawDate: map['drawDate'] as String,
      note: map['note'] as String? ?? '',
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  factory SavedLotteryNumber.fromJson(String source) {
    return SavedLotteryNumber.fromMap(
      jsonDecode(source) as Map<String, dynamic>,
    );
  }
}

extension SavedNumberStatusText on SavedNumberStatus {
  String get label {
    return switch (this) {
      SavedNumberStatus.waiting => 'รอผล',
      SavedNumberStatus.winner => 'ถูกรางวัล',
      SavedNumberStatus.notWinner => 'ไม่ถูก',
    };
  }
}
