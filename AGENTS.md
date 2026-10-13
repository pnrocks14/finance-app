# Working on this repo

Rules for AI coding agents and humans alike. Read [ARCHITECTURE.md](ARCHITECTURE.md) first.

## Non-negotiables

1. **No AI change is applied without explicit user approval.** That includes small
   ones. AI output becomes a `proposals` row with a before/after diff. It is
   applied only from the approval action, and every decision goes to `audit_log`.
   Never add a code path that writes AI output straight to user data.
2. **AI runs only when the user taps a button.** No background, scheduled or
   on-launch AI calls.
3. **Never log raw transaction contents, SMS bodies, statement rows, PINs, keys
   or API keys.** Log ids, counts and timings only. `avoid_print` is on, so use
   structured logging and redact.
4. **Secrets live only in `SecretStore`** (secure storage). Never put them in the
   database, `SharedPreferences`, source, tests or fixtures. CI runs gitleaks.
5. **Money is `Paise` (int).** Never use `double` for amounts. Format with
   `formatInr`.
6. **Dates:** UTC for instants, `LocalDate` (IST) for calendar logic.
7. **No new permissions** without a one-line reason in the PR and a rationale
   string shown to the user.
8. **Don't copy other apps' branding, assets or layouts.**

## Conventions

- Layering: `app` → `finance_ui_kit` / `finance_data` → `finance_core`. Don't
  import upward. Keep `finance_core` free of Flutter.
- Enums that are stored implement `WireEnum` with a stable snake_case `wire`.
  Never rename a wire value. Add a new one instead.
- Schema changes: edit `tables.dart`, bump `schemaVersion`, add the migration step,
  run `dart run build_runner build` and `dart run drift_dev make-migrations`, and
  commit the generated files and the new schema snapshot.
- UI: use tokens (`context.colors`, `Space`, `Radii`, `Motion`) and the kit
  components. No hex colours in screens. Tap targets must be at least 48 dp. Every
  chart needs a text alternative.
- State: Riverpod `Notifier` / `NotifierProvider`. Inject device services
  (secure storage, biometrics, clock) through providers so tests can override them.
- Write user-facing copy in plain, warm sentence case, and say what to do next.

## Before you push

```sh
dart format .
flutter analyze
(cd packages/finance_core && dart test)
(cd packages/finance_data && flutter test)
(cd packages/finance_ui_kit && flutter test)
(cd app && flutter test)
```

Bug fixes come with a test that fails without the fix. Record a significant
decision as a new ADR in `docs/adr/`.
