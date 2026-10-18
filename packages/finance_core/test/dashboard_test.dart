import 'package:finance_core/finance_core.dart';
import 'package:test/test.dart';

MoneyMove move(LocalDate d, int rupees, TransactionFlow flow, [String? cat]) =>
    MoneyMove(
      date: d,
      amount: Paise(rupees * 100),
      flow: flow,
      categoryId: cat,
    );

void main() {
  group('Period', () {
    test('a week runs Monday to Sunday', () {
      // 18 Oct 2026 is a Sunday.
      final w = Period.of(PeriodKind.week, LocalDate(2026, 10, 18));
      expect(w.start, LocalDate(2026, 10, 12));
      expect(w.end, LocalDate(2026, 10, 18));
      expect(w.next.start, LocalDate(2026, 10, 19));
      expect(w.previous.start, LocalDate(2026, 10, 5));
      expect(w.bucketCount, 7);
      expect(w.bucketOf(LocalDate(2026, 10, 14)), 2);
    });

    test('months and years step across year ends', () {
      final m = Period.of(PeriodKind.month, LocalDate(2026, 12, 9));
      expect(m.start, LocalDate(2026, 12, 1));
      expect(m.end, LocalDate(2026, 12, 31));
      expect(m.next.start, LocalDate(2027, 1, 1));
      final y = Period.of(PeriodKind.year, LocalDate(2026, 5, 2));
      expect(y.end, LocalDate(2026, 12, 31));
      expect(y.bucketCount, 12);
      expect(y.bucketOf(LocalDate(2026, 5, 31)), 4);
      expect(y.previous, Period.of(PeriodKind.year, LocalDate(2025, 1, 1)));
    });
  });

  test('a period summary splits spending and income by category and day', () {
    final week = Period.of(PeriodKind.week, LocalDate(2026, 10, 14));
    final s = summarizePeriod([
      move(LocalDate(2026, 10, 12), 450, TransactionFlow.spend, Cat.groceries),
      move(LocalDate(2026, 10, 13), 50, TransactionFlow.refund, Cat.groceries),
      move(LocalDate(2026, 10, 13), 900, TransactionFlow.spend, Cat.shopping),
      move(LocalDate(2026, 10, 15), 85000, TransactionFlow.income, Cat.salary),
      move(LocalDate(2026, 10, 16), 5000, TransactionFlow.transfer),
      move(LocalDate(2026, 10, 11), 999, TransactionFlow.spend, Cat.shopping),
    ], week);
    expect(s.spent, Paise.rupees(1300));
    expect(s.income, Paise.rupees(85000));
    expect(s.net, Paise.rupees(83700));
    expect(s.spendByCategory, [
      (Cat.shopping, Paise.rupees(900)),
      (Cat.groceries, Paise.rupees(400)),
    ]);
    expect(s.incomeByCategory, [(Cat.salary, Paise.rupees(85000))]);
    expect(s.spendBuckets.map((p) => p.wholeRupees), [450, 850, 0, 0, 0, 0, 0]);
    expect(s.cumulativeSpend.last, Paise.rupees(1300));
    expect(s.incomeBuckets[3], Paise.rupees(85000));
  });

  group('evaluateAmount', () {
    test('plain numbers and decimals', () {
      expect(evaluateAmount('450'), Paise.rupees(450));
      expect(evaluateAmount('12.5'), Paise(1250));
      expect(evaluateAmount('.75'), Paise(75));
      expect(evaluateAmount('1,200'), Paise.rupees(1200));
    });

    test('× and ÷ before + and −', () {
      expect(evaluateAmount('100+20×3'), Paise.rupees(160));
      expect(evaluateAmount('100−20÷4'), Paise.rupees(95));
      expect(evaluateAmount('10÷3'), Paise(333));
      expect(evaluateAmount('20÷3'), Paise(667));
    });

    test('a trailing operator is ignored', () {
      expect(evaluateAmount('120+'), Paise.rupees(120));
    });

    test('broken sums are null', () {
      expect(evaluateAmount(''), isNull);
      expect(evaluateAmount('+'), isNull);
      expect(evaluateAmount('5÷0'), isNull);
      expect(evaluateAmount('1.234'), isNull);
      expect(evaluateAmount('1..2'), isNull);
    });
  });

  test('budgets put limits against spending, the fullest first', () {
    final b = budgetMonth(
      {Cat.groceries: Paise.rupees(5000), Cat.eatingOut: Paise.rupees(2000)},
      [
        (Cat.eatingOut, Paise.rupees(2500)),
        (Cat.groceries, Paise.rupees(1000)),
        (Cat.shopping, Paise.rupees(700)),
        (null, Paise.rupees(100)),
      ],
    );
    expect(b.lines.first.categoryId, Cat.eatingOut);
    expect(b.lines.first.isOver, isTrue);
    expect(b.lines.first.left, -Paise.rupees(500));
    expect(b.lines.last.left, Paise.rupees(4000));
    expect(b.limit, Paise.rupees(7000));
    expect(b.spent, Paise.rupees(3500));
    expect(b.unbudgeted, [(Cat.shopping, Paise.rupees(700))]);
  });
}
