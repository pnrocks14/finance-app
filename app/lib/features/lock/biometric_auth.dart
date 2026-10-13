import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Fingerprint or face unlock, behind an interface so tests can fake it.
abstract interface class BiometricAuth {
  /// Whether this device has biometrics enrolled and usable.
  Future<bool> isAvailable();

  /// Shows the system prompt. Returns true only on a successful match.
  Future<bool> authenticate();
}

class LocalBiometricAuth implements BiometricAuth {
  LocalBiometricAuth([LocalAuthentication? auth])
    : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  @override
  Future<bool> isAvailable() async {
    try {
      if (!await _auth.isDeviceSupported()) return false;
      final enrolled = await _auth.getAvailableBiometrics();
      return enrolled.isNotEmpty;
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Unlock your finances',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on PlatformException {
      return false;
    } on LocalAuthException {
      return false;
    }
  }
}
