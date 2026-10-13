import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';

import 'secret_store.dart';

/// The result of checking a PIN.
sealed class PinCheck {
  const PinCheck();
}

final class PinAccepted extends PinCheck {
  const PinAccepted();
}

final class PinRejected extends PinCheck {
  const PinRejected({required this.attemptsBeforeLockout});

  /// Wrong attempts left before a timed lockout starts (0 = locked out now).
  final int attemptsBeforeLockout;
}

final class PinLockedOut extends PinCheck {
  const PinLockedOut({required this.until});

  final DateTime until;
}

/// Sets and checks the app PIN.
///
/// The PIN is never stored. Only a salted PBKDF2-HMAC-SHA256 hash is kept in
/// the [SecretStore]. After [freeAttempts] wrong tries, each further wrong
/// try locks the PIN pad for a doubling period (30 s, 60 s, ... up to 1 h).
class PinLock {
  PinLock(
    this._store, {
    this.iterations = 120000,
    this.freeAttempts = 5,
    DateTime Function()? clock,
    Random? random,
  }) : _clock = clock ?? DateTime.now,
       _random = random ?? Random.secure();

  static final RegExp _validPin = RegExp(r'^\d{4,6}$');

  final SecretStore _store;
  final int iterations;
  final int freeAttempts;
  final DateTime Function() _clock;
  final Random _random;

  static bool isValidPin(String pin) => _validPin.hasMatch(pin);

  Future<bool> get isSet async => await _store.read(SecretKeys.pinHash) != null;

  Future<void> setPin(String pin) async {
    if (!isValidPin(pin)) {
      throw ArgumentError('A PIN is 4 to 6 digits');
    }
    final salt = List<int>.generate(16, (_) => _random.nextInt(256));
    final hash = await _derive(pin, salt, iterations);
    await _store.write(
      SecretKeys.pinHash,
      jsonEncode({
        'v': 1,
        'iterations': iterations,
        'salt': base64Encode(salt),
        'hash': base64Encode(hash),
      }),
    );
    await _store.delete(SecretKeys.pinFailures);
  }

  Future<PinCheck> verify(String pin) async {
    final stored = await _store.read(SecretKeys.pinHash);
    if (stored == null) throw StateError('No PIN has been set');

    final failures = await _readFailures();
    final now = _clock();
    if (failures.lockedUntil != null && now.isBefore(failures.lockedUntil!)) {
      return PinLockedOut(until: failures.lockedUntil!);
    }

    final record = jsonDecode(stored) as Map<String, Object?>;
    final salt = base64Decode(record['salt']! as String);
    final expected = base64Decode(record['hash']! as String);
    final actual = await _derive(pin, salt, record['iterations']! as int);

    if (_constantTimeEquals(actual, expected)) {
      await _store.delete(SecretKeys.pinFailures);
      return const PinAccepted();
    }

    final count = failures.count + 1;
    DateTime? lockedUntil;
    if (count >= freeAttempts) {
      final step = count - freeAttempts; // 0, 1, 2, ...
      final seconds = min(30 * pow(2, step).toInt(), 3600);
      lockedUntil = now.add(Duration(seconds: seconds));
    }
    await _store.write(
      SecretKeys.pinFailures,
      jsonEncode({
        'count': count,
        'lockedUntil': lockedUntil?.toUtc().toIso8601String(),
      }),
    );
    if (lockedUntil != null) return PinLockedOut(until: lockedUntil);
    return PinRejected(attemptsBeforeLockout: freeAttempts - count);
  }

  Future<bool> get biometricEnabled async =>
      await _store.read(SecretKeys.biometricEnabled) == 'true';

  Future<void> setBiometricEnabled(bool enabled) =>
      _store.write(SecretKeys.biometricEnabled, enabled.toString());

  Future<({int count, DateTime? lockedUntil})> _readFailures() async {
    final raw = await _store.read(SecretKeys.pinFailures);
    if (raw == null) return (count: 0, lockedUntil: null);
    final map = jsonDecode(raw) as Map<String, Object?>;
    final until = map['lockedUntil'] as String?;
    return (
      count: map['count']! as int,
      lockedUntil: until == null ? null : DateTime.parse(until),
    );
  }

  Future<List<int>> _derive(String pin, List<int> salt, int rounds) async {
    final kdf = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: rounds,
      bits: 256,
    );
    final key = await kdf.deriveKeyFromPassword(password: pin, nonce: salt);
    return key.extractBytes();
  }

  static bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}
