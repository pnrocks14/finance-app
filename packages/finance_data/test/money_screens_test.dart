import 'package:drift/drift.dart' hide isNull;
import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:flutter_test/flutter_test.dart';

// A made-up statement in HDFC's layout.
const statement = '''
Date,Narration,Chq./Ref.No.,Value Dt,Withdrawal Amt.,Deposit Amt.,Closing Balance
01/10/26,UPI-SWIGGY-swiggy@ybl-YESB0000001-412233445566-Payment,0000412233445566,01/10/26,450.00,,"24,550.00"
02/10/26,NEFT CR-ICIC0000104-ACME TECHNOLOGIES PVT LTD-SALARY OCT-ICICN52026100212345,ICICN52026100212345,02/10/26,,"85,000.00","1,09,550.00"
''';

void main() {
  late FinanceDatabase db;
  late AccountsRepository accounts;
  late ManualEntries entries;
  DateTime clock() => DateTime.utc(2026, 10, 18, 6);

  setUp(() {
    db = openInMemoryFinanceDatabase();
    accounts = AccountsRepository(db, clock: clock);
    entries = ManualEntries(db, clock: clock);
  });
  tearDown(() => db.close());

  Future<List<Transaction>> live() =>
      (db.select(db.transactions)
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  test('balances add money in and take money out', () async {
    final bank = await accounts.create(
      kind: AccountKind.bankAccount,
      institution: 'HDFC Bank',
      displayName: 'HDFC Savings',
      openingBalance: Paise.rupees(25000),
    );
    final cash = await accounts.create(
      kind: AccountKind.cash,
      institution: 'Cash',
      displayName: 'Wallet cash',
    );
    await StatementImporter(db)
        .import(accountId: bank.id, result: parseStatement(statement));
    await entries.add(
      kind: EntryKind.transfer,
      amount: Paise.rupees(2000),
      accountId: bank.id,
      toAccountId: cash.id,
      date: LocalDate(2026, 10, 3),
    );
    final balances = await accounts.watchBalances().first;
    expect(balances[bank.id], Paise.rupees(25000 - 450 + 85000 - 2000));
    expect(balances[cash.id], Paise.rupees(2000));
  });

  test('a manual expense keeps its category and can be removed', () async {
    final cash = await accounts.create(
      kind: AccountKind.cash,
      institution: 'Cash',
      displayName: 'Cash',
    );
    final id = await entries.add(
      kind: EntryKind.expense,
      amount: Paise(12050),
      accountId: cash.id,
      categoryId: Cat.groceries,
      date: LocalDate(2026, 10, 17),
      time: const Duration(hours: 19, minutes: 30),
    );
    var t = (await live()).single;
    expect(t.id, id);
    expect(t.flow, TransactionFlow.spend);
    expect(t.direction, Direction.debit);
    expect(t.counterpartyName, 'Groceries');
    expect(t.categorizedBy, CategorizationMethod.manual);
    // 19:30 IST is 14:00 UTC.
    expect(t.occurredAt, DateTime.utc(2026, 10, 17, 14));

    // Recategorising never touches it.
    await CategoryService(db).recategorize();
    t = (await live()).single;
    expect(t.categoryId, Cat.groceries);

    expect(await entries.isManual(id), isTrue);
    await entries.delete(id);
    expect(await live(), isEmpty);
  });

  test('a transfer is two linked rows that are not spending', () async {
    final a = await accounts.create(
      kind: AccountKind.bankAccount,
      institution: 'HDFC Bank',
      displayName: 'HDFC',
    );
    final b = await accounts.create(
      kind: AccountKind.wallet,
      institution: 'Paytm',
      displayName: 'Paytm wallet',
    );
    final id = await entries.add(
      kind: EntryKind.transfer,
      amount: Paise.rupees(500),
      accountId: a.id,
      toAccountId: b.id,
      date: LocalDate(2026, 10, 10),
      note: 'Top up',
    );
    final rows = await live();
    expect(rows.map((t) => t.flow), everyElement(TransactionFlow.transfer));
    expect(rows.map((t) => t.direction), [Direction.debit, Direction.credit]);
    expect(rows.first.transferPairId, rows.last.id);
    expect(rows.first.notes, 'Top up');
    await entries.delete(id);
    expect(await live(), isEmpty);
  });

  test('imported transactions cannot be removed as manual ones', () async {
    final bank = await accounts.create(
      kind: AccountKind.bankAccount,
      institution: 'HDFC Bank',
      displayName: 'HDFC',
    );
    await StatementImporter(db)
        .import(accountId: bank.id, result: parseStatement(statement));
    final t = (await live()).first;
    expect(await entries.isManual(t.id), isFalse);
    expect(() => entries.delete(t.id), throwsStateError);
  });

  test('accounts can be renamed, rebalanced and archived', () async {
    final a = await accounts.create(
      kind: AccountKind.bankAccount,
      institution: 'HDFC Bank',
      displayName: 'HDFC',
    );
    await accounts.update(
      a.id,
      displayName: 'Salary account',
      openingBalance: Paise.rupees(100),
    );
    expect(
      (await accounts.watchActive().first).single.displayName,
      'Salary account',
    );
    expect((await accounts.watchBalances().first)[a.id], Paise.rupees(100));
    await accounts.archive(a.id);
    expect(await accounts.watchActive().first, isEmpty);
  });

  group('categories', () {
    late CategoriesRepository repo;
    setUp(() => repo = CategoriesRepository(db, clock: clock));

    test('you can add, edit and remove your own', () async {
      final pets = await repo.create(
        name: ' Pets ',
        spendClass: SpendClass.flexible,
        icon: 'pets',
        colorToken: 'chart3',
      );
      expect(pets.name, 'Pets');
      expect(pets.isSystem, isFalse);
      final all = await repo.watchAll().first;
      expect(all.last.id, pets.id);

      await repo.update(pets.id, name: 'Pet care', colorToken: 'chart5');
      final edited = (await repo.watchAll().first).last;
      expect(edited.name, 'Pet care');
      expect(edited.colorToken, 'chart5');

      final cash = await accounts.create(
        kind: AccountKind.cash,
        institution: 'Cash',
        displayName: 'Cash',
      );
      await entries.add(
        kind: EntryKind.expense,
        amount: Paise.rupees(300),
        accountId: cash.id,
        categoryId: pets.id,
        date: LocalDate(2026, 10, 1),
      );
      await BudgetsRepository(db).setLimit(pets.id, Paise.rupees(1000));

      await repo.delete(pets.id);
      expect(
        (await repo.watchAll().first).map((c) => c.id),
        isNot(contains(pets.id)),
      );
      expect((await live()).single.categoryId, isNull);
      expect(await BudgetsRepository(db).watchLimits().first, isEmpty);
    });

    test('built-in ones can be renamed but not removed', () async {
      await repo.update(Cat.groceries, name: 'Kirana');
      final g = (await repo.watchAll().first).firstWhere(
        (c) => c.id == Cat.groceries,
      );
      expect(g.name, 'Kirana');
      expect(() => repo.delete(Cat.groceries), throwsStateError);
    });
  });

  test('a budget limit can be set, changed and removed', () async {
    final budgets = BudgetsRepository(db, clock: clock);
    await budgets.setLimit(Cat.groceries, Paise.rupees(5000));
    await budgets.setLimit(Cat.groceries, Paise.rupees(6000));
    await budgets.setLimit(Cat.eatingOut, Paise.rupees(2000));
    expect(await budgets.watchLimits().first, {
      Cat.groceries: Paise.rupees(6000),
      Cat.eatingOut: Paise.rupees(2000),
    });
    await budgets.remove(Cat.eatingOut);
    expect((await budgets.watchLimits().first).keys, [Cat.groceries]);
    expect(() => budgets.setLimit(Cat.rent, Paise.zero), throwsArgumentError);
  });

  test('the list can be narrowed to a date range', () async {
    final cash = await accounts.create(
      kind: AccountKind.cash,
      institution: 'Cash',
      displayName: 'Cash',
    );
    for (final day in [4, 5, 11, 12]) {
      await entries.add(
        kind: EntryKind.expense,
        amount: Paise.rupees(day),
        accountId: cash.id,
        date: LocalDate(2026, 10, day),
      );
    }
    final week = await TransactionsRepository(db)
        .watchFiltered(
          TransactionFilter(
            from: LocalDate(2026, 10, 5),
            to: LocalDate(2026, 10, 11),
          ),
        )
        .first;
    expect(week.map((t) => t.localDate.day), [11, 5]);
  });
}
