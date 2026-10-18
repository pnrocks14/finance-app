import 'package:finance_app/app/providers.dart';
import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

// A made-up October statement in HDFC's layout.
const _october = '''
Date,Narration,Chq./Ref.No.,Value Dt,Withdrawal Amt.,Deposit Amt.,Closing Balance
01/10/26,UPI-SWIGGY-swiggy@ybl-YESB0000001-412233445566-Payment,0000412233445566,01/10/26,450.00,,"24,550.00"
02/10/26,NEFT CR-ICIC0000104-ACME TECHNOLOGIES PVT LTD-SALARY OCT-ICICN52026100212345,ICICN52026100212345,02/10/26,,"85,000.00","1,09,550.00"
03/10/26,UPI-BLINKIT-blinkit@ybl-YESB0000001-412233445577-Payment,0000412233445577,03/10/26,"2,000.00",,"1,07,550.00"
''';

Future<void> _open(WidgetTester tester) async {
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
      .import(accountId: account.id, result: parseStatement(_october));
  await pumpApp(tester, container);
  await typePin(tester, '4826');
}

Future<void> _tab(WidgetTester tester, String label) async {
  await tester.tap(
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label)),
  );
  await tester.pumpAndSettle();
}

Future<void> _keys(WidgetTester tester, String keys) async {
  for (final k in keys.split('')) {
    await tester.tap(find.text(k).last);
    await tester.pump();
  }
}

/// The list on the open tab, not a text field's own scrollable.
Finder get _list => find
    .descendant(of: find.byType(ListView), matching: find.byType(Scrollable))
    .first;

void main() {
  testWidgets('the dashboard switches between week, month and year', (
    tester,
  ) async {
    await _open(tester);
    expect(find.text('October 2026'), findsOneWidget);
    expect(find.text('₹2,450'), findsWidgets); // spent

    await tester.tap(find.text('Week'));
    await tester.pumpAndSettle();
    // The newest transaction is Saturday 3 October.
    expect(find.text('28 Sep to 4 Oct 2026'), findsOneWidget);
    expect(find.byTooltip('Earlier week'), findsOneWidget);

    await tester.tap(find.text('Year'));
    await tester.pumpAndSettle();
    expect(find.text('2026'), findsOneWidget);

    // Tap "Came in" to see where money came from.
    await tester.tap(find.text('Came in'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Where it came from'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Salary'), findsOneWidget);
  });

  testWidgets('add a cash spend with the keypad', (tester) async {
    await _open(tester);
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    expect(find.text('Save expense'), findsOneWidget);

    await _keys(tester, '120+30');
    expect(find.text('= ₹150'), findsOneWidget);

    await tester.tap(find.text('Pick a category'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Groceries'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Vegetables');
    await tester.tap(find.text('Save expense'));
    await tester.pumpAndSettle();

    expect(find.text('₹150 spend added.'), findsOneWidget);
    await _tab(tester, 'Records');
    expect(find.text('Vegetables'), findsOneWidget);
    expect(
      find.text('Groceries · Added by you · HDFC Savings'),
      findsOneWidget,
    );

    // Entries you added can be removed again.
    await tester.tap(find.text('Vegetables'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Remove this entry'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove this entry'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();
    expect(find.text('Vegetables'), findsNothing);
  });

  testWidgets('a transfer between accounts', (tester) async {
    await _open(tester);
    await _tab(tester, 'Accounts');
    expect(find.text('All accounts'), findsOneWidget);
    expect(find.text('₹82,550'), findsWidgets);

    // Add a cash account with ₹500 in it.
    await tester.tap(find.text('Add new account'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Cash'));
    await tester.pump();
    await tester.enterText(
      find.widgetWithText(TextField, 'Opening balance (optional)'),
      '500',
    );
    await tester.pump();
    await tester.ensureVisible(find.text('Add account'));
    await tester.tap(find.text('Add account'));
    await tester.pumpAndSettle();
    expect(find.text('₹83,050'), findsOneWidget);

    // Take ₹1,000 out of the bank into cash.
    await _tab(tester, 'Home');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Transfer'));
    await tester.pumpAndSettle();
    // Accounts are in name order, so From starts on Cash.
    await tester.tap(find.text('Cash'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'HDFC Savings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pick an account'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Cash'));
    await tester.pumpAndSettle();
    await _keys(tester, '1000');
    await tester.tap(find.text('Save transfer'));
    await tester.pumpAndSettle();

    await _tab(tester, 'Accounts');
    expect(find.text('₹1,500'), findsWidgets); // cash
    expect(find.text('₹81,550'), findsWidgets); // bank
    expect(find.text('₹83,050'), findsOneWidget); // total unchanged
  });

  testWidgets('add a category and give it a budget', (tester) async {
    await _open(tester);
    await _tab(tester, 'Categories');
    await tester.tap(find.text('New category'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Pets');
    await tester.tap(find.byTooltip('pets'));
    await tester.pump();
    await tester.ensureVisible(find.text('Add category'));
    await tester.tap(find.text('Add category'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('Pets'), 200, scrollable: _list);
    await tester.pumpAndSettle();
    expect(find.text('Flexible · Yours'), findsOneWidget);
    await tester.tap(find.byTooltip('Options for Pets'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Set a budget'));
    await tester.pumpAndSettle();
    await _keys(tester, '2000');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(
      find.text('Flexible · Budget ₹2,000 a month · Yours'),
      findsOneWidget,
    );
  });

  testWidgets('budgets show what is used and what has no budget', (
    tester,
  ) async {
    await _open(tester);
    await _tab(tester, 'Budgets');
    expect(find.text('No budgets yet'), findsOneWidget);
    expect(find.text('Not budgeted this month'), findsOneWidget);

    await tester.tap(find.text('New budget'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Groceries'));
    await tester.pumpAndSettle();
    await _keys(tester, '1500');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(
      find.bySemanticsLabel('Groceries: ₹2,000 of ₹1,500. ₹500 over'),
      findsOneWidget,
    );
    expect(find.text('₹2,000 of ₹1,500 used'), findsOneWidget);
    // Food delivery still has no budget.
    expect(find.widgetWithText(ListTile, 'Food delivery'), findsOneWidget);

    // Home shows it too.
    await _tab(tester, 'Home');
    await tester.scrollUntilVisible(
      find.text('All budgets'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('All budgets'), findsOneWidget);
  });
}
