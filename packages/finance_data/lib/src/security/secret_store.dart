import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Small secrets kept outside the database: the database key, the PIN hash
/// and (later) AI API keys. On Android this is backed by the Keystore.
abstract interface class SecretStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

/// Names of everything kept in the [SecretStore], in one place so nothing is
/// written under an ad-hoc key.
abstract final class SecretKeys {
  static const databaseKey = 'db_key_v1';
  static const pinHash = 'pin_hash_v1';
  static const pinFailures = 'pin_failures_v1';
  static const biometricEnabled = 'biometric_enabled_v1';
  static const statementPasswords = 'statement_pdf_passwords_v1';
}

/// Passwords of locked statement PDFs that you chose to remember, kept in
/// the [SecretStore], never in the database. Banks reuse the same password
/// every month, so remembered ones are tried before asking.
class StatementPasswords {
  StatementPasswords(this._store);

  final SecretStore _store;

  /// At most this many are kept, newest first.
  static const limit = 8;

  Future<List<String>> all() async {
    final raw = await _store.read(SecretKeys.statementPasswords);
    if (raw == null) return const [];
    return (jsonDecode(raw) as List).cast<String>();
  }

  Future<void> remember(String password) async {
    final list = [password, ...(await all()).where((p) => p != password)];
    await _store.write(
      SecretKeys.statementPasswords,
      jsonEncode(list.take(limit).toList()),
    );
  }

  Future<void> forgetAll() => _store.delete(SecretKeys.statementPasswords);
}

class FlutterSecretStore implements SecretStore {
  FlutterSecretStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

/// An in-memory store for tests and previews.
class MemorySecretStore implements SecretStore {
  final Map<String, String> values = {};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<void> delete(String key) async => values.remove(key);
}

/// Returns the database key, creating a random 256-bit key on first use.
Future<String> obtainDatabaseKey(SecretStore store, {Random? random}) async {
  final existing = await store.read(SecretKeys.databaseKey);
  if (existing != null) return existing;
  final rng = random ?? Random.secure();
  final key = List.generate(
    32,
    (_) => rng.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ).join();
  await store.write(SecretKeys.databaseKey, key);
  return key;
}
