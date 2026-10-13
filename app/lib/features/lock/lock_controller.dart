import 'package:finance_data/finance_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';

enum LockStatus {
  /// Reading whether a PIN exists.
  checking,

  /// First launch: no PIN yet.
  needsSetup,
  locked,
  unlocked,
}

/// Locks the app after this long in the background.
const Duration autoLockAfter = Duration(minutes: 1);

/// Owns the app lock: first-time PIN setup, unlocking with the PIN or
/// biometrics, and re-locking after [autoLockAfter] in the background.
class LockController extends Notifier<LockStatus> {
  DateTime? _backgroundedAt;

  /// Injectable clock for tests.
  DateTime Function() clock = DateTime.now;

  PinLock get _pin => ref.read(pinLockProvider);

  @override
  LockStatus build() {
    Future.microtask(_load);
    return LockStatus.checking;
  }

  Future<void> _load() async {
    state = await _pin.isSet ? LockStatus.locked : LockStatus.needsSetup;
  }

  /// Saves the first PIN and unlocks.
  Future<void> setUpPin(String pin, {required bool enableBiometric}) async {
    await _pin.setPin(pin);
    await _pin.setBiometricEnabled(enableBiometric);
    state = LockStatus.unlocked;
  }

  Future<PinCheck> unlockWithPin(String pin) async {
    final result = await _pin.verify(pin);
    if (result is PinAccepted) state = LockStatus.unlocked;
    return result;
  }

  /// Whether to offer the fingerprint key: the user turned it on and the
  /// device can do it right now.
  Future<bool> biometricOffered() async =>
      await _pin.biometricEnabled &&
      await ref.read(biometricAuthProvider).isAvailable();

  Future<bool> unlockWithBiometric() async {
    if (!await biometricOffered()) return false;
    final ok = await ref.read(biometricAuthProvider).authenticate();
    if (ok) state = LockStatus.unlocked;
    return ok;
  }

  void lockNow() {
    if (state == LockStatus.unlocked) state = LockStatus.locked;
  }

  void onBackgrounded() => _backgroundedAt = clock();

  void onResumed() {
    final since = _backgroundedAt;
    _backgroundedAt = null;
    if (since != null && clock().difference(since) >= autoLockAfter) lockNow();
  }
}

final lockControllerProvider = NotifierProvider<LockController, LockStatus>(
  LockController.new,
);
