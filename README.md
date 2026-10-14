# Finance

A private, offline-first personal finance app for one person in India. Money is in
INR and everything lives on the phone. Bank statements and SMS come in, get matched
up and categorised on the device, and turn into clear pictures of where the month
went. There is no server. AI is used only when you tap a button, and nothing it
suggests changes your data until you approve it.

Status: **Phase 2** (statement import). Phase 1 built the scaffold, the encrypted
database, the app lock (PIN plus fingerprint), the design system and a style sheet
screen. Phase 2 adds CSV statement import with presets for HDFC, ICICI, SBI, Axis
and Kotak, a column mapper for other banks, duplicate protection, transfer
detection, an import report and a transactions list. PDF statements, the
categoriser, SMS, budgets and AI arrive in later phases. The plan lives in
[the plan doc](https://claude.ai/code/artifact/d641d641-c3c2-44a0-8234-2bcf6671e465).

## Repository layout

```
app/                     Flutter app (Android first)
packages/finance_core/   Pure Dart domain: money, dates, ids, enums, statement parsing
packages/finance_data/   Encrypted Drift database, importer, repositories, PIN lock
packages/finance_ui_kit/ Design tokens, themes, shared components, font
docs/adr/                Architecture decision records
knowledge/               Reference notes (bank formats, guidelines)
```

It is a [Dart pub workspace](https://dart.dev/tools/pub/workspaces), so one
`flutter pub get` at the root resolves every package.

## Setup

You need Flutter **3.47.x** (Dart 3.13) and, to build for a phone, the Android SDK
with Java 17.

```sh
flutter pub get
```

The database is encrypted with SQLite3MultipleCiphers. The root `pubspec.yaml`
selects it through the `sqlite3` build hook, and the native library is downloaded
on the first build.

## Run and test

```sh
# Static checks
dart format --output=none --set-exit-if-changed .
flutter analyze

# Tests, package by package
(cd packages/finance_core && dart test)
(cd packages/finance_data && flutter test)
(cd packages/finance_ui_kit && flutter test)
(cd app && flutter test)

# Run on a connected Android phone or emulator
cd app && flutter run
```

If you change the database tables, regenerate the Drift code:

```sh
cd packages/finance_data && dart run build_runner build
```

## Install on your phone

CI builds a release APK for every pull request and every push to `main`. Open the
workflow run on GitHub, download the `finance-apk` artifact, unzip it, and open
`app-release.apk` on the phone. Android will ask you to allow installs from that
source once.

You can also build it yourself with `cd app && flutter build apk --release`. The
output is at `app/build/app/outputs/flutter-apk/app-release.apk`.

> The release build is currently signed with the Android **debug** key. That is
> fine for sideloading onto your own phone. Before the app goes anywhere else it
> needs a private release keystore, and that keystore must never be committed.

## Importing a statement

1. In net banking, download your account statement as **CSV** (some banks call
   it "delimited").
2. In the app, tap the upload icon on home, pick or add the account, and choose
   the file. The app uses Android's file picker, so it needs no storage
   permission and only sees the file you pick.
3. Check the preview, then import. The report lists every row that couldn't be
   read, with its line number and reason. Importing the same file again adds
   nothing.

## Privacy and security

- All data stays on the device, in a SQLite database encrypted with a random
  256-bit key. The key is kept in Android Keystore-backed secure storage.
- The app locks behind a 4-digit PIN, with optional fingerprint unlock. It locks
  again after a minute in the background. Repeated wrong PINs trigger growing
  pauses.
- Screenshots and the recent-apps preview are blocked (`FLAG_SECURE`). Cloud
  backup and device-to-device transfer are turned off.
- Raw transaction contents and secrets are never logged.

## Docs

- [ARCHITECTURE.md](ARCHITECTURE.md): layers, data model conventions and the main flows
- [AGENTS.md](AGENTS.md): working rules for AI coding agents (and humans)
- [docs/adr](docs/adr): decision records
