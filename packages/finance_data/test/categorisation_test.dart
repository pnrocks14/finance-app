import 'package:drift/drift.dart' hide isNull;
import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:flutter_test/flutter_test.dart';

// A made-up statement in HDFC's layout.
const statement = '''
Date,Narration,Chq./Ref.No.,Value Dt,Withdrawal Amt.,Deposit Amt.,Closing Balance
01/10/26,UPI-SWIGGY-swiggy@ybl-YESB0000001-412233445566-Payment,0000412233445566,01/10/26,450.00,,"24,550.00"
02/10/26,NEFT CR-ICIC0000104-ACME TECHNOLOGIES PVT LTD-SALARY OCT-ICICN52026100212345,ICICN52026100212345,02/10/26,,"85,000.00","1,09,550.00"
03/10/26,UPI-SHARMA STORES-q12345678@ybl-YESB0000001-412233445577-Payment,0000412233445577,03/10/26,200.00,,"1,09,350.00"
05/10/26,UPI-SWIGGY-swiggy@ybl-YESB0000001-412233445588-Payment,0000412233445588,05/10/26,300.00,,"1,09,050.00"
06/10/26,UPI-SHARMA STORES-q12345678@ybl-YESB0000001-412233445599-Payment,0000412233445599,06/10/26,100.00,,"1,08,950.00"
''';

void main() {
  late FinanceDatabase db;
  late CategoryService service;

  setUp(() {
    db = openInMemoryFinanceDatabase();
    service = CategoryService(db, clock: () => DateTime.utc(2026, 10, 18));
  });
  tearDown(() => db.close());

  Future<List<Transaction>> all() => (db.select(
    db.transactions,
  )..orderBy([(t) => OrderingTerm.asc(t.localDate)])).get();

  Future<void> importStatement() async {
    final acc = await AccountsRepository(db).create(
      kind: AccountKind.bankAccount,
      institution: 'HDFC Bank',
      displayName: 'HDFC Savings',
    );
    final out = await StatementImporter(db)
        .import(accountId: acc.id, result: parseStatement(statement));
    expect(out.needsCategory, 0);
  }

  test('the built-in categories are there, once', () async {
    final cats = await db.select(db.categories).get();
    expect(cats, hasLength(seedCategories.length));
    await seedCategoryRows(db, DateTime.utc(2026));
    expect(await db.select(db.categories).get(), hasLength(cats.length));
  });

  test('import categorises with the dictionary and heuristics', () async {
    await importStatement();
    final txs = await all();
    expect(txs.map((t) => t.categoryId), [
      Cat.foodDelivery,
      Cat.salary,
      Cat.shopping, // "stores"
      Cat.foodDelivery,
      Cat.shopping,
    ]);
    expect(txs.first.categorizedBy, CategorizationMethod.pattern);
  });

  test('a correction makes a rule that fixes the payee everywhere', () async {
    await importStatement();
    final sharma = (await all())[2];
    final others = await service.setCategory(sharma.id, Cat.groceries);
    expect(others, 1);

    final txs = await all();
    expect(txs[2].categorizedBy, CategorizationMethod.manual);
    expect(txs[4].categoryId, Cat.groceries);
    expect(txs[4].categorizedBy, CategorizationMethod.rule);

    final rules = await db.select(db.categoryRules).get();
    expect(rules, hasLength(1));
    expect(rules.single.createdBy, Origin.user);
    expect(rules.single.match, {'key': 'sharma_stores', 'direction': 'debit'});
    expect(rules.single.hitCount, 1);

    final label = await db.select(db.trainingLabels).getSingle();
    expect(label.origin, LabelOrigin.correction);
    expect(label.previousCategoryId, Cat.shopping);
    // The label holds model features only, never names or amounts.
    expect(label.features.toString(), isNot(contains('SHARMA')));

    // Changing your mind updates the same rule.
    await service.setCategory(sharma.id, Cat.eatingOut);
    expect(await db.select(db.categoryRules).get(), hasLength(1));
    expect((await all())[4].categoryId, Cat.eatingOut);
  });

  test('a one-off change makes no rule and touches nothing else', () async {
    await importStatement();
    final swiggy = (await all()).first;
    expect(
      await service.setCategory(swiggy.id, Cat.eatingOut, always: false),
      0,
    );
    final txs = await all();
    expect(txs[0].categoryId, Cat.eatingOut);
    expect(txs[3].categoryId, Cat.foodDelivery);
    expect(await db.select(db.categoryRules).get(), isEmpty);
  });

  test('hand-set categories survive re-imports and re-runs', () async {
    await importStatement();
    final swiggy = (await all()).first;
    await service.setCategory(swiggy.id, Cat.eatingOut, always: false);
    await service.recategorize();
    expect((await all()).first.categoryId, Cat.eatingOut);
  });

  test('deleting a rule puts its transactions back', () async {
    await importStatement();
    final sharma = (await all())[2];
    await service.setCategory(sharma.id, Cat.groceries);
    final rule = await db.select(db.categoryRules).getSingle();
    expect(await service.deleteRule(rule.id), 1);
    final txs = await all();
    expect(txs[4].categoryId, Cat.shopping);
    expect(txs[2].categoryId, Cat.groceries); // set by hand, kept
  });

  test(
    'filters: month, category, needs a category, direction, search',
    () async {
      await importStatement();
      final repo = TransactionsRepository(db);
      Future<int> count(TransactionFilter f) async =>
          (await repo.watchFiltered(f).first).length;

      expect(await count(const TransactionFilter()), 5);
      expect(await count(TransactionFilter(month: LocalDate(2026, 10, 18))), 5);
      expect(await count(TransactionFilter(month: LocalDate(2026, 9, 1))), 0);
      expect(
        await count(const TransactionFilter(categoryId: Cat.foodDelivery)),
        2,
      );
      expect(
        await count(const TransactionFilter(direction: Direction.credit)),
        1,
      );
      expect(await count(const TransactionFilter(search: 'sharma')), 2);
      expect(await count(const TransactionFilter(search: 'zz%z')), 0);
      expect(await count(const TransactionFilter(needsCategory: true)), 0);

      final swiggy = (await all()).first;
      await (db.update(db.transactions)..where((t) => t.id.equals(swiggy.id)))
          .write(const TransactionsCompanion(categoryId: Value(null)));
      expect(await count(const TransactionFilter(needsCategory: true)), 1);
      expect(await repo.watchMonths().first, [LocalDate(2026, 10, 1)]);
    },
  );
}
