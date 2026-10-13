import 'package:finance_core/finance_core.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {ThemeData? theme}) => MaterialApp(
  theme: theme ?? FinanceTheme.light(),
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('MoneyText shows Indian grouping and a spoken label', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const MoneyText(Paise(12345650))));
    expect(find.text('₹1,23,456.50'), findsOneWidget);
    expect(find.bySemanticsLabel('123456 rupees 50 paise'), findsOneWidget);
  });

  testWidgets('BudgetTone picks good, caution and over', (tester) async {
    expect(
      BudgetTone.of(const Paise(1000), const Paise(10000)),
      BudgetTone.good,
    );
    expect(
      BudgetTone.of(const Paise(8000), const Paise(10000)),
      BudgetTone.caution,
    );
    expect(
      BudgetTone.of(const Paise(10001), const Paise(10000)),
      BudgetTone.over,
    );
  });

  testWidgets('BudgetBar says what is left or over in words', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const Column(
          children: [
            BudgetBar(
              label: 'Food',
              spent: Paise(690000),
              limit: Paise(1000000),
            ),
            BudgetBar(label: 'Fun', spent: Paise(345000), limit: Paise(300000)),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('₹3,100 left'), findsOneWidget);
    expect(find.text('₹450 over'), findsOneWidget);
  });

  testWidgets('CategoryDonut shows the total and renders in dark mode', (
    tester,
  ) async {
    const slices = [
      DonutSlice(label: 'Food', amount: Paise(620000), color: Colors.orange),
      DonutSlice(label: 'Rent', amount: Paise(1800000), color: Colors.brown),
    ];
    await tester.pumpWidget(
      _wrap(const CategoryDonut(slices: slices), theme: FinanceTheme.dark()),
    );
    await tester.pumpAndSettle();
    expect(find.text('₹24,200'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ProgressRing clamps above 100 percent', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const ProgressRing(
          progress: 1.4,
          color: Colors.green,
          child: Text('140%'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('140%'), findsOneWidget);
  });

  testWidgets('PinPad reports digits and backspace', (tester) async {
    final digits = <int>[];
    var backspaces = 0;
    await tester.pumpWidget(
      _wrap(PinPad(onDigit: digits.add, onBackspace: () => backspaces++)),
    );
    await tester.tap(find.text('7'));
    await tester.tap(find.text('0'));
    await tester.tap(find.bySemanticsLabel('Delete'));
    expect(digits, [7, 0]);
    expect(backspaces, 1);
  });

  testWidgets('EmptyState shows its action', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrap(
        EmptyState(
          title: 'Nothing here yet',
          message: 'Import a statement to begin.',
          actionLabel: 'Import',
          onAction: () => tapped = true,
        ),
      ),
    );
    await tester.tap(find.text('Import'));
    expect(tapped, isTrue);
  });
}
