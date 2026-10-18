import 'package:finance_core/finance_core.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {ThemeData? theme}) => MaterialApp(
  theme: theme ?? FinanceTheme.light(),
  home: Scaffold(body: Center(child: child)),
);

void main() {
  dashboardTests();

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

  testWidgets('SpendCurve compares with last month in words', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const SizedBox(
          width: 300,
          child: SpendCurve(
            current: [Paise(10000), Paise(30000), Paise(30000)],
            previous: [Paise(5000), Paise(50000), Paise(60000), Paise(90000)],
          ),
        ),
        theme: FinanceTheme.dark(),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.bySemanticsLabel(
        'Spending so far ₹300, last month by this day ₹600',
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('DonutLegend rows can be tapped', (tester) async {
    int? tapped;
    await tester.pumpWidget(
      _wrap(
        DonutLegend(
          slices: const [
            DonutSlice(label: 'Food', amount: Paise(100), color: Colors.red),
            DonutSlice(label: 'Fuel', amount: Paise(300), color: Colors.blue),
          ],
          onTap: (i) => tapped = i,
        ),
      ),
    );
    await tester.tap(find.text('Fuel'));
    expect(tapped, 1);
  });
}

void dashboardTests() {
  testWidgets('BreakdownRow shows the amount and share', (tester) async {
    await tester.pumpWidget(
      _wrap(
        BreakdownRow(
          leading: const Icon(Icons.shopping_bag),
          label: 'Shopping',
          amount: Paise.rupees(1200),
          share: 0.25,
          color: Colors.teal,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Shopping, ₹1,200, 25%'), findsOneWidget);
  });

  testWidgets('DayGrid lays the month out from Monday', (tester) async {
    LocalDate? tapped;
    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: 360,
          child: DayGrid(
            // 1 Oct 2026 is a Thursday.
            month: LocalDate(2026, 10, 1),
            values: [
              for (var i = 0; i < 31; i++)
                i == 4 ? Paise.rupees(1500) : Paise.zero,
            ],
            color: Colors.teal,
            onTap: (d) => tapped = d,
          ),
        ),
      ),
    );
    expect(find.text('₹1.5K'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('5: ₹1,500'));
    expect(tapped, LocalDate(2026, 10, 5));
  });

  testWidgets('TrendChart labels its highest and average', (tester) async {
    await tester.pumpWidget(
      _wrap(
        TrendChart(
          values: [Paise.rupees(100), Paise.rupees(300), Paise.rupees(200)],
          labels: const ['Mon', 'Sun'],
          color: Colors.teal,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Highest ₹300, average ₹200'), findsOneWidget);
  });

  test('applyKey builds a sum one key at a time', () {
    var s = '';
    for (final k in ['0', '5', '.', '5', '5', '5', '+', '+', '−', '2']) {
      s = applyKey(s, k);
    }
    expect(s, '5.55−2');
    expect(applyKey('', '+'), '');
    expect(applyKey('', '.'), '0.');
    expect(applyKey('12', '⌫'), '1');
    expect(evaluateAmount(s), Paise(355));
  });

  testWidgets('CalcKeypad sends keys', (tester) async {
    final keys = <String>[];
    await tester.pumpWidget(_wrap(CalcKeypad(onKey: keys.add)));
    await tester.tap(find.text('7'));
    await tester.tap(find.text('×'));
    await tester.tap(find.bySemanticsLabel('Delete'));
    expect(keys, ['7', '×', '⌫']);
  });
}
