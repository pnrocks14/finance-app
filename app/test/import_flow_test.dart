import 'dart:convert';

import 'package:finance_app/app/providers.dart';
import 'package:finance_app/features/import/pdf_text.dart';
import 'package:finance_app/features/import/statement_file_picker.dart';
import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

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

// Two Swiggy orders, made up.
const _twoSwiggy = '''
Date,Narration,Chq./Ref.No.,Value Dt,Withdrawal Amt.,Deposit Amt.,Closing Balance
01/10/26,UPI-SWIGGY-swiggy@ybl-YESB0000001-412233445566-Payment,0000412233445566,01/10/26,450.00,,"24,550.00"
03/10/26,UPI-SWIGGY-swiggy@ybl-YESB0000001-412233445577-Payment,0000412233445577,03/10/26,300.00,,"24,250.00"
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
  FakePdfText(this.text, {this.password});
  final String text;

  /// When set, the PDF opens only with this password.
  final String? password;
  final tried = <String?>[];

  @override
  Future<String> extract(List<int> bytes, {String? password}) async {
    tried.add(password);
    if (this.password != null && password != this.password) {
      throw const PdfPasswordRequired();
    }
    return text;
  }
}

// A made-up bank statement as PDF text.
const _bankPdf = '''
HDFC BANK Ltd. Statement of account
Date Narration Chq./Ref.No. Value Dt Withdrawal Amt. Deposit Amt. Closing Balance
Opening Balance 25,000.00
01/10/26 UPI-SWIGGY-SWIGGY@YBL-YESB0000001-412233445566 01/10/26 450.00 24,550.00
02/10/26 NEFT CR-ICIC0000104-ACME TECHNOLOGIES PVT LTD 02/10/26 85,000.00 1,09,550.00
''';

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
    await tester.ensureVisible(find.text('Add account'));
    await tester.pumpAndSettle();
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

    // It lands on the Records tab, so the tabs (and home) are still there.
    expect(find.text('Records'), findsWidgets);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Swiggy'), findsOneWidget);
    expect(find.text('Acme Technologies Pvt Ltd'), findsOneWidget);
    await tester.tap(find.text('Swiggy'));
    await tester.pumpAndSettle();
    expect(find.text('Food delivery'), findsWidgets);
    expect(
      find.text('"swiggy" looks like a food delivery app.'),
      findsOneWidget,
    );
  });

  testWidgets('change a category for a payee, then undo the rule', (
    tester,
  ) async {
    final store = MemorySecretStore();
    await PinLock(store, iterations: 1000).setPin('4826');
    final container = testContainer(store);
    addTearDown(container.dispose);
    final db = await container.read(databaseProvider.future);
    final account = await AccountsRepository(db).create(
      kind: AccountKind.bankAccount,
      institution: 'HDFC Bank',
      displayName: 'HDFC Savings',
    );
    await StatementImporter(db)
        .import(accountId: account.id, result: parseStatement(_twoSwiggy));
    await pumpApp(tester, container);
    await typePin(tester, '4826');
    await tester.scrollUntilVisible(
      find.text('See all'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text('See all'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('See all'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Food delivery ·'), findsNWidgets(2));

    await tester.tap(find.text('Swiggy').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Change'));
    await tester.pumpAndSettle();
    expect(find.text('Always for Swiggy'), findsOneWidget);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Eating out'));
    await tester.pumpAndSettle();
    expect(find.textContaining('1 more from Swiggy'), findsOneWidget);
    expect(find.text('You picked this.'), findsOneWidget);
    await tester.tapAt(const Offset(10, 10)); // close the sheet
    await tester.pumpAndSettle();
    expect(find.textContaining('Eating out ·'), findsNWidgets(2));

    await tester.tap(find.byTooltip('Your rules'));
    await tester.pumpAndSettle();
    expect(find.text('Paid to swiggy'), findsOneWidget);
    await tester.tap(find.byTooltip('Delete rule'));
    await tester.pumpAndSettle();
    expect(find.text('No rules yet'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    // The one you picked by hand stays; the other goes back to the guess.
    expect(find.textContaining('Eating out ·'), findsOneWidget);
    expect(find.textContaining('Food delivery ·'), findsOneWidget);
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
    await tester.scrollUntilVisible(
      find.text('Swiggy'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
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

  testWidgets('a locked bank PDF asks for its password once', (tester) async {
    final store = MemorySecretStore();
    await PinLock(store, iterations: 1000).setPin('4826');
    final pdf = FakePdfText(_bankPdf, password: 'ASHA0101');
    final container = testContainer(
      store,
      picker: FakePicker('%PDF-1.7', name: 'hdfc.pdf'),
      pdfText: pdf,
    );
    addTearDown(container.dispose);
    final db = await container.read(databaseProvider.future);
    await AccountsRepository(db).create(
      kind: AccountKind.bankAccount,
      institution: 'HDFC Bank',
      displayName: 'HDFC Savings',
    );
    await pumpApp(tester, container);
    await typePin(tester, '4826');

    Future<void> choose() async {
      await tester.tap(find.byTooltip('Import a statement'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose file'));
      await tester.pumpAndSettle();
    }

    await choose();
    expect(find.text('Unlock the PDF'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextField, 'PDF password'),
      'wrong',
    );
    await tester.tap(find.text('Unlock'));
    await tester.pumpAndSettle();
    expect(find.textContaining("didn't open it"), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'PDF password'),
      'ASHA0101',
    );
    await tester.tap(find.text('Unlock'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('HDFC Savings'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Looks like HDFC Bank'), findsOneWidget);
    await tester.tap(find.text('Import 2 transactions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('See transactions'));
    await tester.pumpAndSettle();
    expect(find.text('Swiggy'), findsOneWidget);

    // Remembered: the next statement opens without asking.
    expect(await StatementPasswords(store).all(), ['ASHA0101']);
    pdf.tried.clear();
    GoRouter.of(tester.element(find.byType(Scaffold).first)).go('/import');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose file'));
    await tester.pumpAndSettle();
    expect(find.text('Unlock the PDF'), findsNothing);
    expect(pdf.tried, [null, 'ASHA0101']);
  });

  testWidgets('a locked PDF opens from your details', (tester) async {
    final store = MemorySecretStore();
    await PinLock(store, iterations: 1000).setPin('4826');
    // Made-up details: ASHA + 05/01 is the Axis-style rule.
    final pdf = FakePdfText(_bankPdf, password: 'ASHA0501');
    final container = testContainer(
      store,
      picker: FakePicker('%PDF-1.7', name: 'axis.pdf'),
      pdfText: pdf,
    );
    addTearDown(container.dispose);
    await pumpApp(tester, container);
    await typePin(tester, '4826');
    await tester.tap(find.text('Import a statement'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose file'));
    await tester.pumpAndSettle();
    expect(find.text('Unlock the PDF'), findsOneWidget);

    final tryDetails = find.text('Try my details');
    final list = find
        .descendant(
          of: find.byType(ListView),
          matching: find.byType(Scrollable),
        )
        .first;
    Future<void> scrollTo(Finder f, double delta) =>
        tester.scrollUntilVisible(f, delta, scrollable: list);
    await scrollTo(tryDetails, 200);
    await tester.tap(tryDetails);
    await tester.pumpAndSettle();
    expect(find.textContaining('name and date of birth'), findsOneWidget);

    final name = find.widgetWithText(TextField, 'Name as on the account');
    await scrollTo(name, -200);
    await tester.enterText(name, 'Asha Kumar');
    final dob = find.widgetWithText(TextField, 'Date of birth');
    await scrollTo(dob, 200);
    await tester.enterText(dob, '05/01/1990');
    await scrollTo(tryDetails, 200);
    await tester.tap(tryDetails);
    await tester.pumpAndSettle();
    expect(find.text('Unlock the PDF'), findsNothing);
    expect(find.text('Add an account'), findsOneWidget);
    // Only the password that worked is kept, never the details.
    expect(await StatementPasswords(store).all(), ['ASHA0501']);
  });

  testWidgets('a PDF with no transactions is turned away', (tester) async {
    final store = MemorySecretStore();
    await PinLock(store, iterations: 1000).setPin('4826');
    final container = testContainer(
      store,
      picker: FakePicker('%PDF-1.7', name: 'letter.pdf'),
      pdfText: FakePdfText('Dear customer\nThank you'),
    );
    addTearDown(container.dispose);
    await pumpApp(tester, container);
    await typePin(tester, '4826');
    await tester.tap(find.text('Import a statement'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose file'));
    await tester.pumpAndSettle();
    expect(find.textContaining('No transactions were found'), findsOneWidget);
  });
}
