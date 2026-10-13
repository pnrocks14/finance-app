# 0002: Drift on SQLite3MultipleCiphers for the encrypted database

- Status: accepted (supersedes "Drift + SQLCipher" in plan v2)
- Date: 2026-10-12

## Context

All data is on the device and must be encrypted at rest. The plan named
SQLCipher, through `sqlcipher_flutter_libs`. Since `sqlite3` 3.x, native SQLite is
provided by build hooks, and the old `*_flutter_libs` packages are deprecated. The
hook can build SQLite3MultipleCiphers (sqlite3mc) instead of plain SQLite.

## Decision

- Use Drift as the ORM, with typed tables, migrations and schema snapshots.
- Use `sqlite3` 3.x with `hooks: user_defines: sqlite3: source: sqlite3mc` in
  the root `pubspec.yaml`.
- Generate a 256-bit key with a CSPRNG on first run and save it in
  `flutter_secure_storage` (Android Keystore). Apply it with `PRAGMA hexkey`
  before any other statement, then verify that it opened with a read.
- Refuse to open (`StateError`) if the linked SQLite has no cipher support. The
  app must never silently fall back to plaintext.

## Alternatives

- **SQLCipher via `sqlcipher_flutter_libs`:** deprecated with `sqlite3` 3.x.
- **Hive or Isar:** weaker relational querying for reconciliation and reports.
  Isar's maintenance is uncertain.

## Consequences

- The default cipher is ChaCha20-Poly1305 (sqlite3mc), not SQLCipher's AES-CBC.
  Database files are not SQLCipher-compatible. That's fine because nothing
  outside the app reads them.
- Tests verify that the file has no plaintext and no SQLite header, and that a
  wrong key fails.
- In-memory databases (tests only) are unencrypted.
- If the secure-storage key is lost (app data cleared), the database is
  unrecoverable. Encrypted export and backup is a later phase.
