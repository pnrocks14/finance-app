# 0005: App lock with PIN and biometrics

- Status: accepted
- Date: 2026-10-12

## Decision

- **PIN:** 4 digits for now (the storage layer accepts 4 to 6). The hash is
  PBKDF2-HMAC-SHA256 with 120k iterations and a random salt, stored in secure
  storage and compared in constant time.
- **Wrong tries:** after 5 wrong PINs, a 30 s pause that doubles up to 1 h. The
  counter is kept in secure storage, so restarting the app doesn't reset it.
- **Fingerprint:** optional unlock, chosen at setup. It uses `local_auth` with
  `biometricOnly`. The PIN always works as a fallback.
- **Auto-lock:** after 1 minute in the background.
- **Routing:** the router redirects to the lock screens unless the app is
  unlocked.
- **Screen protection:** `FLAG_SECURE` blocks screenshots and the recents preview.
  Cloud backup and device transfer are off.

## Consequences

- `MainActivity` is a `FlutterFragmentActivity` and `minSdk` is 24.
- A forgotten PIN can't be recovered. The user has to clear the app data, which
  also loses the database. A recovery path (encrypted backup) is a later phase.
