import 'dart:convert';

import 'package:finance_app/app/providers.dart';
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

class FakePicker implements StatementFilePicker {
  FakePicker(this.text);
  final String text;

  @override
  Future<PickedStatement?> pick() async =>
      PickedStatement(name: 'october.csv', bytes: utf8.encode(text));
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

    // No accounts yet: add one.
    await tester.tap(find.text('Add an account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('HDFC Bank'));
    await tester.pump();
    await tester.tap(find.text('Add account'));
    await tester.pumpAndSettle();

    expect(find.text('Importing into HDFC Savings'), findsOneWidget);
    await tester.tap(find.text('Choose CSV file'));
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
    await tester.tap(find.text('HDFC Savings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose CSV file'));
    await tester.pumpAndSettle();
    expect(find.text('Nothing new to import'), findsOneWidget);
  });
}
