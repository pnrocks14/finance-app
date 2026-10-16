import 'package:drift/drift.dart' hide isNull;
import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:flutter_test/flutter_test.dart';

// Made-up statements in Kotak's CSV layout and Google Pay's PDF text layout.
// The first two Kotak rows and the first two Google Pay entries are the same
// payments, with the same UPI references.
const kotak = '''
"Sl. No.","Transaction Date","Value Date","Description","Chq /Ref No.","Amount","Dr / Cr","Balance","Dr / Cr"
"1","01-07-2026 09:46:50","01-07-2026","UPI/TEA STALL OWN/FDRL/611122223333/Pay to Bhara","UPI-600000000001","20.00","DR","980.00","CR"
"2","08-07-2026 09:46:24","08-07-2026","UPI/ASHA RAVI KUMA/IPOS/633344445555/UPI","UPI-600000000003","300.00","DR","680.00","CR"
"3","05-07-2026 17:21:16","05-07-2026","UPI/UNITY SMALL FI/NSPB/644455556666/UPI","UPI-600000000004","500.00","DR","180.00","CR"
"Closing Balance","as on 30/09/2026 INR 180.00"
''';

const gpay = '''
Sent
₹1,020
Received
₹0
Date & time Transaction details Amount
01 Jul, 2026
09:46 AM
Paid to TEA STALL OWNER NAME
UPI Transaction ID: 611122223333
Paid by Kotak Mahindra Bank 7890
₹20
08 Jul, 2026
09:46 AM
Self transfer to India Post Payment Bank 4321
UPI Transaction ID: 633344445555
Paid by Kotak Mahindra Bank 7890
₹300
08 Jul, 2026
01:08 PM
Paid to Udupi Flavours
UPI Transaction ID: 677788889999
Paid by Unity Small Finance Bank Ltd XX65 | RuPay credit card
₹1,000
''';

void main() {
  late FinanceDatabase db;
  late AccountsRepository accounts;
  late StatementImporter bank;
  late AppStatementImporter app;

  setUp(() {
    db = openInMemoryFinanceDatabase();
    accounts = AccountsRepository(db);
    DateTime clock() => DateTime.utc(2026, 10, 17);
    bank = StatementImporter(db, clock: clock);
    app = AppStatementImporter(db, clock: clock);
  });
  tearDown(() => db.close());

  Future<Account> kotakAccount() => accounts.create(
    kind: AccountKind.bankAccount,
    institution: 'Kotak Mahindra Bank',
    displayName: 'Kotak Savings',
  );

  Future<ImportOutcome> importApp() async {
    final p = await app.preview(parseGooglePayText(gpay));
    return app.import(
      result: p.result,
      accounts: {for (final i in p.instruments) i.key: i.account?.id},
    );
  }

  Future<List<Transaction>> ledger() => (db.select(
    db.transactions,
  )..orderBy([(t) => OrderingTerm.asc(t.occurredAt)])).get();

  test('preview matches instruments to accounts by bank name', () async {
    final k = await kotakAccount();
    final p = await app.preview(parseGooglePayText(gpay));
    expect(p.newRows, 3);
    expect(p.alreadyImported, 0);
    expect(p.matchesBankRows, 0);
    expect(p.instruments, hasLength(2));
    expect(p.instruments.first.account?.id, k.id);
    expect(p.instruments.last.instrument?.kind, AccountKind.creditCard);
    expect(p.instruments.last.account, isNull);
  });

  test('bank first, then the app: joined, not doubled', () async {
    final k = await kotakAccount();
    await bank.import(accountId: k.id, result: parseStatement(kotak));
    final p = await app.preview(parseGooglePayText(gpay));
    expect(p.matchesBankRows, 2);

    final out = await importApp();
    expect(out.matched, 2);
    expect(out.created, 1);
    // The card from the statement became an account, and its bank makes the
    // earlier UNITY SMALL FI debit a card bill.
    expect(out.transfersMarked, 1);

    final txs = await ledger();
    expect(txs, hasLength(4));
    final tea = txs.firstWhere((t) => t.upiRef == '611122223333');
    expect(tea.accountId, k.id);
    expect(tea.counterpartyName, 'TEA STALL OWNER NAME');
    expect(tea.occurredAt, DateTime.utc(2026, 7, 1, 4, 16));
    expect(tea.reconciliationStatus, ReconciliationStatus.matched);
    expect(tea.descriptionRaw, contains('UPI/TEA STALL OWN'));

    final self = txs.firstWhere((t) => t.upiRef == '633344445555');
    expect(self.flow, TransactionFlow.transfer);
    expect(self.flowReason, FlowReason.selfTransfer);
    expect(self.counterpartyKind, CounterpartyKind.self);

    final cardBill = txs.firstWhere((t) => t.upiRef == '644455556666');
    expect(cardBill.flow, TransactionFlow.transfer);
    expect(cardBill.flowReason, FlowReason.cardBill);

    final sources = await (db.select(
      db.transactionSources,
    )..where((s) => s.transactionId.equals(tea.id))).get();
    expect(sources.map((s) => s.kind).toSet(), {
      SourceKind.statementRow,
      SourceKind.upiAppRow,
    });

    // The Kotak account learned its last digits for next time.
    final saved = await (db.select(
      db.accounts,
    )..where((a) => a.id.equals(k.id))).getSingle();
    expect(saved.last4, '7890');
    final card = (await accounts.all()).firstWhere(
      (a) => a.kind == AccountKind.creditCard,
    );
    expect(card.last4, '65');
    expect(card.institution, 'Unity Small Finance Bank Ltd');
  });

  test('the app first, then the bank: still one transaction each', () async {
    final k = await kotakAccount();
    await importApp();
    final out = await bank.import(
      accountId: k.id,
      result: parseStatement(kotak),
    );
    expect(out.matched, 2);
    expect(out.created, 1);

    final txs = await ledger();
    expect(txs, hasLength(4));
    final tea = txs.firstWhere((t) => t.upiRef == '611122223333');
    expect(tea.counterpartyName, 'TEA STALL OWNER NAME');
    expect(tea.reconciliationStatus, ReconciliationStatus.matched);
    final self = txs.firstWhere((t) => t.upiRef == '633344445555');
    expect(self.flowReason, FlowReason.selfTransfer);
  });

  test('importing the same app statement again adds nothing', () async {
    await kotakAccount();
    await importApp();
    final again = await importApp();
    expect(again.created, 0);
    expect(again.matched, 0);
    expect(again.duplicates, 3);
    expect(await ledger(), hasLength(3));
    expect(await accounts.all(), hasLength(2));
  });

  test('a flow you set by hand survives a later app import', () async {
    final k = await kotakAccount();
    await bank.import(accountId: k.id, result: parseStatement(kotak));
    final self = (await ledger()).firstWhere((t) => t.upiRef == '633344445555');
    await (db.update(
      db.transactions,
    )..where((t) => t.id.equals(self.id))).write(
      const TransactionsCompanion(
        flow: Value(TransactionFlow.spend),
        flowReason: Value(FlowReason.user),
      ),
    );
    await importApp();
    final after = (await ledger()).firstWhere((t) => t.id == self.id);
    expect(after.flow, TransactionFlow.spend);
    expect(after.flowReason, FlowReason.user);
  });

  test('suggestAccount matches last digits before bank names', () async {
    final a = await accounts.create(
      kind: AccountKind.bankAccount,
      institution: 'India Post Payments Bank',
      displayName: 'IPPB',
      last4: '4321',
    );
    await accounts.create(
      kind: AccountKind.bankAccount,
      institution: 'India Post Payments Bank',
      displayName: 'Other IPPB',
    );
    const inst = PaymentInstrument(
      kind: AccountKind.bankAccount,
      digits: '4321',
    );
    expect(suggestAccount(inst, await accounts.all())?.id, a.id);
    const card = PaymentInstrument(
      kind: AccountKind.creditCard,
      digits: '4321',
    );
    expect(suggestAccount(card, await accounts.all()), isNull);
  });
}
