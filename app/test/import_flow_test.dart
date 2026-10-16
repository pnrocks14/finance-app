import 'dart:convert';

import 'package:finance_app/app/providers.dart';
import 'package:finance_app/features/import/pdf_text.dart';
import 'package:finance_app/features/import/statement_file_picker.dart';
import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

// A made-up statement in HDFC's CSV layout.
const _hdfc = '''
Date,Narration,Chq./Ref.No.,Value Dt,Withdrawal Amt.,Deposit Amt.,Closing Balance
01/10/26,UPI-SWIGGY-swiggy@ybl-YESB0000001-412233445566-Payment,0000412233445566,01/10/26,450.00,,"24,550.00"
02/10/26,NEFT CR-ICIC0000104-ACME TECHNOLOGIES PVT LTD-SALARY OCT-ICICN52026100212345,ICICN52026100212345,02/10/26,,"85,000.00","1,09,550.00"
xx/10/26,BROKEN ROW,,,10.00,,
''';

// Made-up Google Pay statement text, as PDFium extracts it.
const _gpay = '''
Transaction statement
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

class FakePicker implements StatementFilePicker {
  FakePicker(this.text, {this.name = 'october.csv'});
  final String text;
  final String name;

  @override
  Future<PickedStatement?> pick() async =>
      PickedStatement(name: name, bytes: utf8.encode(text));
}

class FakePdfText implements PdfTextExtractor {
  FakePdfText(this.text);
  final String text;

  @override
  Future<String> extract(List<int> bytes) async => text;
}

void main() {
  testWidgets('add an account, import a statement, read the report, see why', (
    tester,
  ) async {
    final store = MemorySecretStore();
    await PinLock(store, iterations: 1000).setPin('4826');
    final container = testContainer(store, picker: FakePicker(_hdfc));
    addTearDown(container.dispose);
    await pumpApp(tester, container);
    await typePin(tester, '4826');

    expect(find.text('Your money, all in one place'), findsOneWidget);
    await tester.tap(find.text('Import a statement'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose file'));
    await tester.pumpAndSettle();

    // A bank CSV needs its account. There are none yet: add one.
    await tester.tap(find.text('Add an account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('HDFC Bank'));
    await tester.pump();
    await tester.tap(find.text('Add account'));
    await tester.pumpAndSettle();

    expect(find.text('october.csv'), findsOneWidget);
    expect(find.textContaining('Looks like HDFC Bank'), findsOneWidget);
    expect(find.text('Import 2 transactions'), findsOneWidget);
    await tester.tap(find.text('Import 2 transactions'));
    await tester.pumpAndSettle();

    expect(find.text("Rows we couldn't read"), findsOneWidget);
    expect(find.textContaining('Line 4'), findsOneWidget);
    await tester.tap(find.text('See transactions'));
    await tester.pumpAndSettle();

    expect(find.text('Swiggy'), findsOneWidget);
    expect(find.text('Acme Technologies Pvt Ltd'), findsOneWidget);
    await tester.tap(find.text('Swiggy'));
    await tester.pumpAndSettle();
    expect(find.text('Why it counts this way'), findsOneWidget);
    expect(find.text('swiggy@ybl'), findsOneWidget);
  });

  testWidgets('importing the same file again adds nothing', (tester) async {
    final store = MemorySecretStore();
    await PinLock(store, iterations: 1000).setPin('4826');
    final container = testContainer(store, picker: FakePicker(_hdfc));
    addTearDown(container.dispose);
    final db = await container.read(databaseProvider.future);
    final account = await AccountsRepository(db).create(
      kind: AccountKind.bankAccount,
      institution: 'HDFC Bank',
      displayName: 'HDFC Savings',
    );
    await StatementImporter(db)
        .import(accountId: account.id, result: parseStatement(_hdfc));

    await pumpApp(tester, container);
    await typePin(tester, '4826');
    expect(find.text('Swiggy'), findsOneWidget);

    await tester.tap(find.byTooltip('Import a statement'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose file'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('HDFC Savings'));
    await tester.pumpAndSettle();
    expect(find.text('Nothing new to import'), findsOneWidget);
  });

  testWidgets('a Google Pay PDF fills several accounts at once', (
    tester,
  ) async {
    final store = MemorySecretStore();
    await PinLock(store, iterations: 1000).setPin('4826');
    final container = testContainer(
      store,
      picker: FakePicker('%PDF-1.7', name: 'gpay.pdf'),
      pdfText: FakePdfText(_gpay),
    );
    addTearDown(container.dispose);
    final db = await container.read(databaseProvider.future);
    await AccountsRepository(db).create(
      kind: AccountKind.bankAccount,
      institution: 'Kotak Mahindra Bank',
      displayName: 'Kotak Savings',
    );

    await pumpApp(tester, container);
    await typePin(tester, '4826');
    await tester.tap(find.text('Import a statement'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose file'));
    await tester.pumpAndSettle();
    expect(find.text('gpay.pdf'), findsOneWidget);
    expect(find.textContaining('Google Pay statement'), findsOneWidget);
    expect(
      find.text('Adds up to the totals on the statement.'),
      findsOneWidget,
    );
    expect(find.text('Kotak Mahindra Bank ••7890'), findsOneWidget);
    expect(find.text('Kotak Savings'), findsOneWidget);
    expect(find.text('Unity Small Finance Bank Ltd ••65'), findsOneWidget);
    expect(find.text('Add as a new account'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Import 3 payments'), 200);
    await tester.tap(find.text('Import 3 payments'));
    await tester.pumpAndSettle();
    expect(find.text('3'), findsOneWidget);
    await tester.tap(find.text('See transactions'));
    await tester.pumpAndSettle();

    expect(find.text('Udupi Flavours'), findsOneWidget);
    final accounts = await AccountsRepository(db).all();
    expect(accounts.map((a) => a.last4).toSet(), {'7890', '65'});
  });

  testWidgets('a PDF that is not a Google Pay statement is turned away', (
    tester,
  ) async {
    final store = MemorySecretStore();
    await PinLock(store, iterations: 1000).setPin('4826');
    final container = testContainer(
      store,
      picker: FakePicker('%PDF-1.7', name: 'bank.pdf'),
      pdfText: FakePdfText('Statement of account\nOpening balance 100.00'),
    );
    addTearDown(container.dispose);
    await pumpApp(tester, container);
    await typePin(tester, '4826');
    await tester.tap(find.text('Import a statement'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose file'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Only Google Pay PDF statements'),
      findsOneWidget,
    );
  });
}
