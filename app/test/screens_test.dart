import 'package:finance_app/app/providers.dart';
import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

// Made-up statements in HDFC's layout: September, then October.
const _september = '''
Date,Narration,Chq./Ref.No.,Value Dt,Withdrawal Amt.,Deposit Amt.,Closing Balance
05/09/26,UPI-SWIGGY-swiggy@ybl-YESB0000001-412233440001-Payment,0000412233440001,05/09/26,"1,000.00",,"49,000.00"
''';
const _october = '''
Date,Narration,Chq./Ref.No.,Value Dt,Withdrawal Amt.,Deposit Amt.,Closing Balance
01/10/26,UPI-SWIGGY-swiggy@ybl-YESB0000001-412233445566-Payment,0000412233445566,01/10/26,450.00,,"24,550.00"
02/10/26,NEFT CR-ICIC0000104-ACME TECHNOLOGIES PVT LTD-SALARY OCT-ICICN52026100212345,ICICN52026100212345,02/10/26,,"85,000.00","1,09,550.00"
03/10/26,UPI-BLINKIT-blinkit@ybl-YESB0000001-412233445577-Payment,0000412233445577,03/10/26,"2,000.00",,"1,07,550.00"
04/10/26,UPI-XYZ123-q98765@ybl-YESB0000001-412233445588-Payment,0000412233445588,04/10/26,300.00,,"1,07,250.00"
05/10/26,UPI-XYZ123-q98765@ybl-YESB0000001-412233445599-Payment,0000412233445599,05/10/26,200.00,,"1,07,050.00"
''';

Future<void> _seed(FinanceDatabase db) async {
  final account = await AccountsRepository(db).create(
    kind: AccountKind.bankAccount,
    institution: 'HDFC Bank',
    displayName: 'HDFC Savings',
  );
  final importer = StatementImporter(db);
  await importer.import(
    accountId: account.id,
    result: parseStatement(_september),
  );
  await importer.import(
    accountId: account.id,
    result: parseStatement(_october),
  );
}

Future<void> _open(WidgetTester tester) async {
  final store = MemorySecretStore();
  await PinLock(store, iterations: 1000).setPin('4826');
  final container = testContainer(store);
  addTearDown(container.dispose);
  await _seed(await container.read(databaseProvider.future));
  await pumpApp(tester, container);
  await typePin(tester, '4826');
}

Finder get _home => find.byType(Scrollable).first;

void main() {
  testWidgets('home shows what is left, where it went and the month curve', (
    tester,
  ) async {
    await _open(tester);
    expect(find.text('October 2026'), findsOneWidget);
    // ₹85,000 in, ₹2,950 spent.
    expect(
      find.bySemanticsLabel(RegExp('^₹82,050 left of ₹85,000')),
      findsOneWidget,
    );
    expect(find.text('2 transactions need a category'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Groceries'),
      200,
      scrollable: _home,
    );
    expect(find.text('Food delivery'), findsWidgets);
    expect(find.text('Needs a category'), findsWidgets);
    await tester.scrollUntilVisible(
      find.textContaining('than last month by this day'),
      200,
      scrollable: _home,
    );
    // October so far against September by the same day (₹1,000).
    expect(
      find.text('₹1,950 more than last month by this day.'),
      findsOneWidget,
    );

    // Step back a month.
    await tester.scrollUntilVisible(
      find.byTooltip('Earlier month'),
      -300,
      scrollable: _home,
    );
    await tester.tap(find.byTooltip('Earlier month'));
    await tester.pumpAndSettle();
    expect(find.text('September 2026'), findsOneWidget);
    expect(find.text('No income this month yet.'), findsOneWidget);
    expect(find.byTooltip('Earlier month'), findsOneWidget);
  });

  testWidgets('a donut slice opens that category for the month', (
    tester,
  ) async {
    await _open(tester);
    final groceries = find.text('Groceries');
    await tester.scrollUntilVisible(groceries, 200, scrollable: _home);
    await tester.tap(groceries);
    await tester.pumpAndSettle();
    expect(find.text('Transactions'), findsOneWidget);
    expect(find.text('October 2026'), findsOneWidget); // the month chip
    expect(find.text('Blinkit'), findsOneWidget);
    expect(find.text('Swiggy'), findsNothing);
    expect(find.textContaining('1 transaction ·'), findsOneWidget);
  });

  testWidgets('search and the money filter narrow the list', (tester) async {
    await _open(tester);
    await tester.scrollUntilVisible(
      find.text('See all'),
      300,
      scrollable: _home,
    );
    await tester.ensureVisible(find.text('See all'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('See all'));
    await tester.pumpAndSettle();
    expect(find.textContaining('6 transactions ·'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'swig');
    await tester.pumpAndSettle();
    expect(find.textContaining('2 transactions ·'), findsOneWidget);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('In and out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Money in'));
    await tester.pumpAndSettle();
    expect(find.textContaining('1 transaction ·'), findsOneWidget);
    expect(find.text('Acme Technologies Pvt Ltd'), findsOneWidget);
  });

  testWidgets('the sort queue files a payee once for all their payments', (
    tester,
  ) async {
    await _open(tester);
    await tester.tap(find.text('Sort them'));
    await tester.pumpAndSettle();
    expect(find.text('2 to go'), findsOneWidget);
    expect(find.text('Always for Xyz123'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Shopping'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('1 more from Xyz123 sorted too.'),
      findsOneWidget,
    );
    expect(find.text('All sorted'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.textContaining('need a category'), findsNothing);
  });
}
