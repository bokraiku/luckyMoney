import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lucky_money/main.dart';

void main() {
  testWidgets('shows the main Lucky Money dashboard', (tester) async {
    await tester.pumpWidget(const LuckyMoneyApp());

    expect(find.text('Lucky Money'), findsOneWidget);
    expect(find.text('ราคาทองวันนี้'), findsOneWidget);
    expect(find.text('งวดถัดไป 1 ก.ค. 2569'), findsOneWidget);
    expect(find.text('ข่าวเด่นวันนี้'), findsOneWidget);
  });

  testWidgets('checks a winning lottery number', (tester) async {
    await tester.pumpWidget(const LuckyMoneyApp());

    await tester.tap(find.text('ตรวจหวย'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('lottery-input')), '123456');
    await tester.tap(find.text('ตรวจรางวัล'));
    await tester.pump();

    expect(find.textContaining('ถูกรางวัล'), findsOneWidget);
  });
}
