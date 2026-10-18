import 'package:finance_app/app/providers.dart';
import 'package:finance_app/features/lock/lock_controller.dart';
import 'package:finance_data/finance_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  testWidgets('first launch: choose and confirm a PIN, then land on home', (
    tester,
  ) async {
    final store = MemorySecretStore();
    final container = testContainer(store);
    addTearDown(container.dispose);
    await pumpApp(tester, container);

    expect(find.text('Pick a 4-digit PIN'), findsOneWidget);
    await typePin(tester, '2580');
    expect(find.text('Type it once more'), findsOneWidget);
    await typePin(tester, '2580');

    expect(find.text('Your money, all in one place'), findsOneWidget);
    expect(await PinLock(store).isSet, isTrue);
  });

  testWidgets('mismatched confirmation starts over', (tester) async {
    final container = testContainer(MemorySecretStore());
    addTearDown(container.dispose);
    await pumpApp(tester, container);

    await typePin(tester, '1111');
    await typePin(tester, '2222');
    expect(find.text('Pick a 4-digit PIN'), findsOneWidget);
    expect(find.text("Those didn't match. Let's start again."), findsOneWidget);
  });

  testWidgets('returning user unlocks with the PIN; a wrong PIN is refused', (
    tester,
  ) async {
    final store = MemorySecretStore();
    await PinLock(store, iterations: 1000).setPin('4826');
    final container = testContainer(store);
    addTearDown(container.dispose);
    await pumpApp(tester, container);

    expect(find.text('Welcome back'), findsOneWidget);
    await typePin(tester, '0000');
    expect(find.text("That's not it. Try again."), findsOneWidget);
    await typePin(tester, '4826');
    expect(find.text('Your money, all in one place'), findsOneWidget);
  });

  testWidgets('fingerprint unlock is offered when turned on', (tester) async {
    final store = MemorySecretStore();
    final lock = PinLock(store, iterations: 1000);
    await lock.setPin('4826');
    await lock.setBiometricEnabled(true);
    final biometric = FakeBiometric(available: true);
    final container = testContainer(store, biometric: biometric);
    addTearDown(container.dispose);
    await pumpApp(tester, container);

    expect(biometric.prompts, 1);
    expect(find.text('Your money, all in one place'), findsOneWidget);
  });

  testWidgets('style sheet renders in light and dark', (tester) async {
    final store = MemorySecretStore();
    await PinLock(store, iterations: 1000).setPin('4826');
    final container = testContainer(store);
    addTearDown(container.dispose);
    await pumpApp(tester, container);
    await typePin(tester, '4826');

    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Style sheet'));
    await tester.pumpAndSettle();
    expect(find.text('Style sheet'), findsOneWidget);
    expect(find.text('₹3,100 left'), findsOneWidget);

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(container.read(themeModeProvider), ThemeMode.dark);
    expect(tester.takeException(), isNull);
  });

  test('auto-locks only after a minute in the background', () async {
    final store = MemorySecretStore();
    await PinLock(store, iterations: 1000).setPin('4826');
    final container = testContainer(store);
    addTearDown(container.dispose);
    final controller = container.read(lockControllerProvider.notifier);
    await Future<void>.delayed(Duration.zero);
    await controller.unlockWithPin('4826');
    expect(container.read(lockControllerProvider), LockStatus.unlocked);

    var now = DateTime(2026, 10, 12, 10);
    controller.clock = () => now;
    controller.onBackgrounded();
    now = now.add(const Duration(seconds: 30));
    controller.onResumed();
    expect(container.read(lockControllerProvider), LockStatus.unlocked);

    controller.onBackgrounded();
    now = now.add(const Duration(seconds: 61));
    controller.onResumed();
    expect(container.read(lockControllerProvider), LockStatus.locked);
  });
}
