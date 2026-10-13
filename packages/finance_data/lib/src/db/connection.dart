import 'dart:io';

import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';

import 'database.dart';

final RegExp _hexKey = RegExp(r'^[0-9a-f]{64}$');

/// Opens the encrypted database file at [file] with a 256-bit key given as 64
/// lowercase hex characters. The work runs on a background isolate.
FinanceDatabase openFinanceDatabaseFile(File file, {required String hexKey}) {
  _checkKey(hexKey);
  return FinanceDatabase(
    NativeDatabase.createInBackground(
      file,
      setup: (db) => applyEncryptionKey(db, hexKey),
    ),
  );
}

/// An in-memory database for tests. SQLite cannot encrypt in-memory
/// databases, so use [openFinanceDatabaseFile] to test encryption itself.
FinanceDatabase openInMemoryFinanceDatabase() =>
    FinanceDatabase(NativeDatabase.memory());

/// Whether this build of SQLite can encrypt databases. True for the
/// SQLite3MultipleCiphers build selected in the workspace pubspec.
bool sqliteSupportsEncryption() {
  final db = sqlite3.openInMemory();
  try {
    return db.select('PRAGMA cipher').isNotEmpty;
  } finally {
    db.close();
  }
}

/// Unlocks [db] with [hexKey]. Must run before anything else touches the
/// file. Throws if this SQLite build cannot encrypt, so the app never
/// silently writes financial data in plain text.
void applyEncryptionKey(Database db, String hexKey) {
  _checkKey(hexKey);
  if (db.select('PRAGMA cipher').isEmpty) {
    throw StateError(
      'This SQLite build has no encryption support. Check the sqlite3 '
      'user_defines in the workspace pubspec.yaml.',
    );
  }
  db.execute("PRAGMA hexkey = '$hexKey'");
  // Reading the schema fails with "file is not a database" when the key is
  // wrong, so a bad key is caught here instead of on the first real query.
  db.select('SELECT count(*) FROM sqlite_master');
}

void _checkKey(String hexKey) {
  if (!_hexKey.hasMatch(hexKey)) {
    throw ArgumentError('Database key must be 64 lowercase hex characters');
  }
}
