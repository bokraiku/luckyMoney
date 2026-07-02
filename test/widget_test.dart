import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucky_money/app/lucky_money_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows the main Lucky Money dashboard', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: LuckyMoneyApp()));
    await tester.pumpAndSettle();

    expect(find.text('Lucky Money'), findsOneWidget);
    expect(find.text('ราคาทองวันนี้'), findsOneWidget);
    expect(find.text('ข่าวเด่นวันนี้'), findsOneWidget);
  });

  testWidgets('checks and saves a winning lottery number', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: LuckyMoneyApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('ตรวจหวย'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('lottery-input')), '123456');
    await tester.tap(find.text('ตรวจรางวัล').last);
    await tester.pump();

    expect(find.textContaining('ถูกรางวัล'), findsOneWidget);

    await tester.tap(find.byTooltip('บันทึกเลข'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('เลขของฉัน'));
    await tester.pumpAndSettle();

    expect(find.text('123456'), findsWidgets);
  });

  testWidgets('toggles between light and dark mode', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: LuckyMoneyApp()));
    await tester.pumpAndSettle();

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );

    await tester.tap(find.byTooltip('เปลี่ยนเป็นโหมดมืด'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
  });
}
