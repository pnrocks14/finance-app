import 'dart:math';

import 'package:finance_data/finance_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('obtainDatabaseKey', () {
    test('creates a 256-bit hex key once and then reuses it', () async {
      final store = MemorySecretStore();
      final first = await obtainDatabaseKey(store, random: Random(1));
      expect(first, matches(RegExp(r'^[0-9a-f]{64}$')));
      expect(await obtainDatabaseKey(store), first);
    });
  });

  group('PinLock', () {
    late MemorySecretStore store;
    late DateTime now;
    late PinLock lock;

    setUp(() {
      store = MemorySecretStore();
      now = DateTime.utc(2026, 10, 12, 10);
      // Few iterations keep the test fast; the app uses the default.
      lock = PinLock(store, iterations: 1000, clock: () => now);
    });

    test('accepts only 4 to 6 digits', () async {
      expect(PinLock.isValidPin('1234'), isTrue);
      expect(PinLock.isValidPin('123456'), isTrue);
      expect(PinLock.isValidPin('123'), isFalse);
      expect(PinLock.isValidPin('1234567'), isFalse);
      expect(PinLock.isValidPin('12a4'), isFalse);
      await expectLater(lock.setPin('12'), throwsArgumentError);
    });

    test('never stores the PIN itself', () async {
      await lock.setPin('482913');
      expect(await lock.isSet, isTrue);
      expect(store.values.values.any((v) => v.contains('482913')), isFalse);
    });

    test('accepts the right PIN and rejects a wrong one', () async {
      await lock.setPin('4829');
      expect(await lock.verify('4829'), isA<PinAccepted>());
      final wrong = await lock.verify('0000');
      expect(wrong, isA<PinRejected>());
      expect((wrong as PinRejected).attemptsBeforeLockout, 4);
    });

    test('locks out after five wrong tries, doubling each time', () async {
      await lock.setPin('4829');
      for (var i = 0; i < 4; i++) {
        expect(await lock.verify('0000'), isA<PinRejected>());
      }
      final fifth = await lock.verify('0000');
      expect(fifth, isA<PinLockedOut>());
      expect(
        (fifth as PinLockedOut).until,
        now.add(const Duration(seconds: 30)),
      );

      // Even the right PIN is refused during the lockout.
      expect(await lock.verify('4829'), isA<PinLockedOut>());

      now = now.add(const Duration(seconds: 31));
      final sixth = await lock.verify('0000');
      expect(
        (sixth as PinLockedOut).until,
        now.add(const Duration(seconds: 60)),
      );

      now = now.add(const Duration(seconds: 61));
      expect(await lock.verify('4829'), isA<PinAccepted>());
      // A success resets the counter.
      expect(await lock.verify('0000'), isA<PinRejected>());
    });

    test('remembers the biometric preference', () async {
      expect(await lock.biometricEnabled, isFalse);
      await lock.setBiometricEnabled(true);
      expect(await lock.biometricEnabled, isTrue);
    });
  });
}
