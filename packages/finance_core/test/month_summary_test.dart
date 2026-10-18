import 'package:finance_core/finance_core.dart';
import 'package:test/test.dart';

MoneyMove move(int day, int rupees, TransactionFlow flow, [String? cat]) =>
    MoneyMove(
      date: LocalDate(2026, 10, day),
      amount: Paise(rupees * 100),
      flow: flow,
      categoryId: cat,
    );

void main() {
  test('spending less refunds, income, by category and day by day', () {
    final s = summarizeMonth([
      move(1, 450, TransactionFlow.spend, Cat.foodDelivery),
      move(2, 85000, TransactionFlow.income, Cat.salary),
      move(3, 10000, TransactionFlow.transfer, Cat.ownTransfers),
      move(4, 180, TransactionFlow.refund, Cat.foodDelivery),
      move(4, 2000, TransactionFlow.spend, Cat.groceries),
      move(10, 300, TransactionFlow.spend),
      // Another month: ignored.
      MoneyMove(
        date: LocalDate(2026, 9, 30),
        amount: Paise(99900),
        flow: TransactionFlow.spend,
      ),
    ], LocalDate(2026, 10, 18));
    expect(s.month, LocalDate(2026, 10, 1));
    expect(s.spent, Paise(257000));
    expect(s.income, Paise(8500000));
    expect(s.left, Paise(8500000 - 257000));
    expect(s.byCategory, [
      (Cat.groceries, Paise(200000)),
      (null, Paise(30000)),
      (Cat.foodDelivery, Paise(27000)),
    ]);
    expect(s.cumulative, hasLength(31));
    expect(s.cumulative[0], Paise(45000));
    expect(s.cumulative[3], Paise(45000 - 18000 + 200000));
    expect(s.cumulative.last, s.spent);
  });

  test('a refund bigger than the spend leaves the category out', () {
    final s = summarizeMonth([
      move(1, 100, TransactionFlow.spend, Cat.shopping),
      move(2, 150, TransactionFlow.refund, Cat.shopping),
    ], LocalDate(2026, 10, 1));
    expect(s.byCategory, isEmpty);
    expect(s.spent, Paise(-5000));
  });

  test('months step across years', () {
    expect(previousMonth(LocalDate(2026, 1, 1)), LocalDate(2025, 12, 1));
    expect(nextMonth(LocalDate(2026, 12, 1)), LocalDate(2027, 1, 1));
    expect(monthOf(LocalDate(2026, 2, 28)), LocalDate(2026, 2, 1));
  });
}
