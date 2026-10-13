import 'package:finance_data/finance_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/lock/biometric_auth.dart';

/// Device-backed secret storage. Overridden with an in-memory store in tests.
final secretStoreProvider = Provider<SecretStore>(
  (ref) => FlutterSecretStore(),
);

final pinLockProvider = Provider<PinLock>(
  (ref) => PinLock(ref.watch(secretStoreProvider)),
);

final biometricAuthProvider = Provider<BiometricAuth>(
  (ref) => LocalBiometricAuth(),
);

/// The encrypted local database, opened once and closed with the app.
final databaseProvider = FutureProvider<FinanceDatabase>((ref) async {
  final db = await openAppDatabase(ref.watch(secretStoreProvider));
  ref.onDispose(db.close);
  return db;
});

/// Light, dark or follow the system. Starts on system; the style sheet has a
/// switch to try both.
class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void set(ThemeMode mode) => state = mode;
}

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);
