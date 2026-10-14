import 'package:drift/drift.dart' hide isNull;
import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:flutter_test/flutter_test.dart';

// Made-up statements in HDFC and SBI layouts.
const hdfc = '''
Date,Narration,Chq./Ref.No.,Value Dt,Withdrawal Amt.,Deposit Amt.,Closing Balance
01/10/26,UPI-SWIGGY-swiggy@ybl-YESB0000001-412233445566-Payment,0000412233445566,01/10/26,450.00,,"24,550.00"
02/10/26,NEFT CR-ICIC0000104-ACME TECHNOLOGIES PVT LTD-SALARY OCT-ICICN52026100212345,ICICN52026100212345,02/10/26,,"85,000.00","1,09,550.00"
03/10/26,IMPS-627612345678-SELF SBI-Savings,627612345678,03/10/26,"10,000.00",,"99,550.00"
04/10/26,UPI-ZOMATO-zomato@hdfcbank-HDFC0000001-412255554444-Refund,0000412255554444,04/10/26,,180.00,"99,730.00"
xx/10/26,BROKEN ROW,,,10.00,,
''';

const sbi =
    'Txn Date\tValue Date\tDescription\tRef No./Cheque No.\tDebit\tCredit\tBalance\n'
    '3 Oct 2026\t3 Oct 2026\tBY TRANSFER-IMPS/627612345678/HDFC/Savings\t-\t\t10,000.00\t60,000.00\n';

void main() {
  late FinanceDatabase db;
  late AccountsRepository accounts;
  late StatementImporter importer;

  setUp(() {
    db = openInMemoryFinanceDatabase();
    accounts = AccountsRepository(db);
    importer = StatementImporter(db, clock: () => DateTime.utc(2026, 10, 14));
  });
  tearDown(() => db.close());

  Future<Account> bank(String name) => accounts.create(
    kind: AccountKind.bankAccount,
    institution: name,
    displayName: '$name Savings',
    last4: '1234',
  );

  test('imports rows as evidence plus ledger entries, with a report', () async {
    final acc = await bank('HDFC Bank');
    final parsed = parseStatement(hdfc);
    final out = await importer.import(accountId: acc.id, result: parsed);

    expect(out.created, 4);
    expect(out.duplicates, 0);
    expect(out.failed, 1);
    expect(await db.select(db.sourceRecords).get(), hasLength(4));
    expect(await db.select(db.transactionSources).get(), hasLength(4));

    final txs = await (db.select(
      db.transactions,
    )..orderBy([(t) => OrderingTerm.asc(t.localDate)])).get();
    final swiggy = txs.first;
    expect(swiggy.amountPaise, 45000);
    expect(swiggy.channel, Channel.upi);
    expect(swiggy.merchantKey, 'swiggy');
    expect(swiggy.vpa, 'swiggy@ybl');
    expect(swiggy.upiRef, '412233445566');
    expect(swiggy.flow, TransactionFlow.spend);
    expect(swiggy.localDate, LocalDate(2026, 10, 1));
    expect(swiggy.reconciliationStatus, ReconciliationStatus.single);

    expect(txs[1].flow, TransactionFlow.income);
    expect(txs[3].flow, TransactionFlow.refund);
    expect(txs[3].flowReason, FlowReason.refundKeyword);

    final batch = await db.select(db.importBatches).getSingle();
    expect(batch.status, ImportStatus.completed);
    expect(batch.adapter, 'hdfc_csv');
    expect(batch.createdCount, 4);
    expect(batch.failedCount, 1);
    expect(batch.periodFrom, LocalDate(2026, 10, 1));
    final error = batch.errors.single! as Map<String, Object?>;
    expect(error['line'], 6);
    expect(error['reason'], 'badDate');
  });

  test('importing the same statement again creates nothing', () async {
    final acc = await bank('HDFC Bank');
    await importer.import(accountId: acc.id, result: parseStatement(hdfc));

    final preview = await importer.preview(
      accountId: acc.id,
      result: parseStatement(hdfc),
    );
    expect(preview.alreadyImported, 4);
    expect(preview.newRows, 0);

    final again = await importer.import(
      accountId: acc.id,
      result: parseStatement(hdfc),
    );
    expect(again.created, 0);
    expect(again.duplicates, 4);
    expect(await db.select(db.transactions).get(), hasLength(4));
    expect(await db.select(db.importBatches).get(), hasLength(2));
  });

  test('a second account completes a transfer pair', () async {
    final hdfcAcc = await bank('HDFC Bank');
    final sbiAcc = await bank('State Bank of India');
    await importer.import(accountId: hdfcAcc.id, result: parseStatement(hdfc));
    final out = await importer.import(
      accountId: sbiAcc.id,
      result: parseStatement(sbi),
    );
    expect(out.transfersMarked, 2);

    final transfers = await (db.select(
      db.transactions,
    )..where((t) => t.flow.equalsValue(TransactionFlow.transfer))).get();
    expect(transfers, hasLength(2));
    final debit = transfers.firstWhere((t) => t.direction == Direction.debit);
    final credit = transfers.firstWhere((t) => t.direction == Direction.credit);
    expect(debit.accountId, hdfcAcc.id);
    expect(debit.transferPairId, credit.id);
    expect(credit.transferPairId, debit.id);
    expect(debit.flowReason, FlowReason.transferPair);
    expect(debit.version, 2);
  });

  test('a flow you set by hand is never overwritten', () async {
    final hdfcAcc = await bank('HDFC Bank');
    final sbiAcc = await bank('State Bank of India');
    await importer.import(accountId: hdfcAcc.id, result: parseStatement(hdfc));
    await (db.update(
      db.transactions,
    )..where((t) => t.amountPaise.equals(1000000))).write(
      const TransactionsCompanion(
        flow: Value(TransactionFlow.spend),
        flowReason: Value(FlowReason.user),
      ),
    );
    await importer.import(accountId: sbiAcc.id, result: parseStatement(sbi));

    final hdfcSide =
        await (db.select(db.transactions)..where(
              (t) =>
                  t.accountId.equals(hdfcAcc.id) &
                  t.amountPaise.equals(1000000),
            ))
            .getSingle();
    expect(hdfcSide.flow, TransactionFlow.spend);
    expect(hdfcSide.transferPairId, isNull);
  });

  test('account last4 must be four digits', () async {
    expect(
      () => accounts.create(
        kind: AccountKind.bankAccount,
        institution: 'X',
        displayName: 'X',
        last4: '12',
      ),
      throwsArgumentError,
    );
  });

  test('transactions repository lists newest first and by month', () async {
    final acc = await bank('HDFC Bank');
    await importer.import(accountId: acc.id, result: parseStatement(hdfc));
    final repo = TransactionsRepository(db);
    final all = await repo.watch().first;
    expect(all.first.localDate, LocalDate(2026, 10, 4));
    expect(await repo.watch(month: LocalDate(2026, 9, 1)).first, isEmpty);
    expect(await repo.watchCount().first, 4);
  });
}
