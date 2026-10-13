# finance_data

Everything that touches disk: the encrypted Drift database (SQLite3MultipleCiphers),
the secret store over Android Keystore, and the PIN lock.

After changing `lib/src/db/tables.dart` or `database.dart`:

```sh
dart run build_runner build
dart run drift_dev make-migrations   # when bumping schemaVersion
```

Run the tests with `flutter test` from this folder.
