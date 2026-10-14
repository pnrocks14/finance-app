import 'package:finance_app/app/data_providers.dart';
import 'package:finance_app/app/finance_app.dart';
import 'package:finance_app/app/providers.dart';
import 'package:finance_app/features/import/statement_file_picker.dart';
import 'package:finance_app/features/lock/biometric_auth.dart';
import 'package:finance_data/finance_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Shared setup for widget tests: in-memory secrets and database, fast PIN
/// hashing, and fakes for biometrics and the file picker.
class FakeBiometric implements BiometricAuth {
  FakeBiometric({this.available = false, this.succeeds = true});

  final bool available;
  final bool succeeds;
  int prompts = 0;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<bool> authenticate() async {
    prompts++;
    return succeeds;
  }
}

ProviderContainer testContainer(
  MemorySecretStore store, {
  BiometricAuth? biometric,
  StatementFilePicker? picker,
}) => ProviderContainer(
  overrides: [
    if (picker != null) statementFilePickerProvider.overrideWithValue(picker),
    secretStoreProvider.overrideWithValue(store),
    pinLockProvider.overrideWithValue(PinLock(store, iterations: 1000)),
    biometricAuthProvider.overrideWithValue(biometric ?? FakeBiometric()),
    databaseProvider.overrideWith((ref) async {
      final db = openInMemoryFinanceDatabase();
      ref.onDispose(db.close);
      return db;
    }),
  ],
);

Future<void> typePin(WidgetTester tester, String pin) async {
  for (final ch in pin.split('')) {
    await tester.tap(find.text(ch));
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

Future<void> pumpApp(WidgetTester tester, ProviderContainer container) async {
  // A typical phone, so the whole PIN pad is on screen.
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.75;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const FinanceApp()),
  );
  await tester.pumpAndSettle();
}
