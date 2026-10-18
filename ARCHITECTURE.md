# Architecture

## Principles

1. **On the device, offline first.** There is no backend. Every feature works
   without a network connection except AI, which is opt-in per tap.
2. **The user approves every change.** Nothing proposed by AI is ever applied
   automatically. Proposals show a before/after diff, need explicit approval, and
   expire if the underlying data changes. Every decision is written to an
   append-only, hash-chained audit log.
3. **Exact money.** Amounts are integer paise. Floating point never touches money.
4. **Least privilege.** The app asks only for permissions it needs, explains why,
   and keeps read access separate from write access.

## Layers

```
┌──────────────────────────────────────────────┐
│ app            screens, routing, providers   │  Flutter, Riverpod, go_router
├──────────────────────┬───────────────────────┤
│ finance_ui_kit       │ finance_data          │
│ tokens, theme,       │ Drift DB, secret      │
│ components           │ store, PIN lock,      │
│                      │ (later) importers,    │
│                      │ categoriser, AI gw    │
├──────────────────────┴───────────────────────┤
│ finance_core   money, dates, ids, enums      │  pure Dart
└──────────────────────────────────────────────┘
```

Dependencies only point downward. `finance_core` has no Flutter dependency, so
parsers and the categoriser can be tested quickly with `dart test`. Screens never
talk to Drift directly. They go through repositories in `finance_data`, which arrive
in phase 2.

## Data model conventions

| Concern | Rule |
|---|---|
| Money | `Paise` (int). Amounts in `transactions.amount_paise` are always positive, and `direction` says debit or credit. Display goes through `formatInr` with Indian grouping (₹1,23,456). |
| Instants | Stored in UTC (`DateTime` columns, ISO-8601 text). |
| Calendar dates | `LocalDate` in IST, stored as `YYYY-MM-DD`. Budgets and months are keyed by IST dates, never by UTC. |
| Ids | UUID v7 strings (time-ordered). |
| Enums | Stored as stable snake_case wire names (`WireEnum`), never as Dart indexes, so reordering an enum can't corrupt data. |
| Row metadata | Every table has `id`, `created_at`, `updated_at` and `version` (for optimistic concurrency and a future sync). |
| Provenance | Every transaction links back to the raw `source_records` it came from (statement row or SMS) through `transaction_sources`. |

The database has 18 tables, defined in
[`packages/finance_data/lib/src/db/tables.dart`](packages/finance_data/lib/src/db/tables.dart).
Schema snapshots are kept in `packages/finance_data/drift_schemas/` so migrations
can be generated and tested.

## Storage and secrets

- **Database:** Drift over `sqlite3` built with SQLite3MultipleCiphers (ADR 0002).
  On first run, a random 32-byte key is generated and saved to secure storage. It
  is applied with `PRAGMA hexkey` before any other statement. Foreign keys are on.
  `audit_log` rejects `UPDATE` and `DELETE` through triggers.
- **Secrets:** `flutter_secure_storage`, backed by Android Keystore. It holds the
  database key, the PIN hash, the lockout counter, the biometric preference and,
  later, the AI API keys (primary and backup). Secrets are never written to the
  database, logs or source control.
- **PIN:** a salted PBKDF2-HMAC-SHA256 hash (120k iterations), checked with a
  constant-time compare. After 5 wrong tries the lockout starts at 30 s and doubles
  up to 1 h.

## Main flows

### Statement import (phase 2, built)

```
CSV bytes ─▶ decodeStatementBytes (UTF-8/16, Latin-1) ─▶ parseCsv (delimiter detected)
          ─▶ detectLayout: header row + bank preset, or the column mapper on screen
          ─▶ parseStatement: every line after the header becomes a row, an error,
             a blank, or the footer (nothing is dropped silently)
          ─▶ checkBalances: the running balance is a checksum (warnings only)
          ─▶ StatementImporter.preview: how many rows are new
          ─▶ StatementImporter.import, in one DB transaction:
               import_batches (counts, errors, period)
               source_records (one per new row, dedupeHash unique)
               transactions + transaction_sources (description parsed)
               detectTransfers over the period ±3 days, across all accounts
```

- **Parsing is pure Dart** in `finance_core/lib/src/import/`. Presets map header
  spellings to fields. A bank without a preset falls back to generic header
  names, then to the column mapper.
- **Description parser:** turns narrations such as
  `UPI-SWIGGY-swiggy@ybl-YESB0000001-412233445566-…` into the channel, payee, VPA,
  UPI ref, bank code and merchant key. It also guesses merchant versus person from
  the VPA and name.
- **Dedupe:** `sha256(account | date | direction | amount | normalised description
  | balance | occurrence)`. The occurrence number keeps two identical rows (two
  ₹20 chai payments) as two transactions, while re-importing the file reproduces
  the same hashes.
- **Flow:** debits are spend and credits are income. Credits that read like a
  refund or reversal are refunds. Transfer detection then marks transfers:
  - debit and credit pairs of the same amount across your accounts, within 2 days
    (and the same UPI reference when both sides have one)
  - credit card bill payments, including payments to the bank behind one of
    your cards
  - payments to your own UPI IDs
  - self transfers named in a payment app's statement

  `flow_reason` records why, for "see why". A flow set by hand
  (`flow_reason = user`) is never overwritten.
- **Report excerpts** mask every run of 5 or more digits except the last 4.

### UPI app statements (phase 2, built)

```
Google Pay PDF ─▶ PDFium text (pdfrx) ─▶ parseGooglePayText ─┐
PhonePe CSV ─────────────────────────▶ parsePhonePeCsv ──────┤
                                                             ▼
        rows with payee, exact time, UPI ref and instrument ("Kotak … 7890")
          ─▶ AppStatementImporter.preview: instrument → account suggestions
          ─▶ import, in one DB transaction:
               source_records (kind upi_app_row)
               same UPI ref + direction + amount already in the ledger?
                 yes: join it (app payee and time, bank account and narration)
                 no:  new transaction in the instrument's account
               detectTransfers over the period
```

- The bank importer joins the other way too, so the import order doesn't
  matter (ADR 0007).
- Google Pay's PDF text is read field by field inside each dated entry, so it
  doesn't depend on the extractor's text order. Its printed totals are a
  checksum.

### Bank statement PDFs (phase 2, built)

```
PDF ─▶ open unlocked? ─no─▶ remembered passwords ─no─▶ password step
                                                      typed, or built from
                                                      your details
     ─▶ PDFium text ─▶ Google Pay? ─▶ app statement flow above
                    ─▶ bank text?  ─▶ parseBankPdfText ─▶ account step ─▶ preview
```

- **Rows** start at a line beginning with a date (after an optional serial
  number); following lines without a date are wrapped narration. Page
  headers and footers are skipped.
- **Amounts:** the last amount on a row is the balance and the one before
  it is the transaction. Direction comes from the balance chain, which works
  for oldest-first and newest-first statements. An opening balance or B/F
  row seeds the chain. A row whose direction can't be told is reported, not
  guessed.
- **Passwords:** `statementPasswordCandidates` builds every published bank
  rule from what you type (name, date of birth, mobile, customer ID, account
  number, card digits). The details stay in memory for that attempt only.
  A password that opens the file is saved in secure storage
  (`StatementPasswords`, at most 8) when you tick Remember. Nothing about
  passwords is logged.

### Bank SMS parser (phase 2, used from phase 5)

`parseTransactionSms(sender, body)` turns one SMS into direction, amount,
channel, account or card digits, payee, VPA, UPI ref, balance or limit and
date, or returns null. It knows the DLT sender headers of the major banks
and ignores promotional (`-P`) senders, OTPs, requests, reminders, offers,
declines, mandates and failed payments (unless refunded). Bold or italic
Unicode letters some banks use are read as plain text.

### Reconcile with SMS (phase 5)

```
SMS inbox ─▶ per-sender templates ─▶ source_records (deduped by hash)
          ─▶ matcher: same amount ± date window ± reference ─▶ existing transaction
          ─▶ unsure matches ─▶ reconciliation_reviews ─▶ user decides
```

### Categorisation (phase 3, built), fully on device

```
import ─▶ markTransfers ─▶ CategoryService.recategorize(period)
                              Categorizer (finance_core, pure Dart):
                              1. transfer / card bill  ─▶ transfer categories
                              2. your rules (priority) ─▶ method rule
                              3. merchant dictionary on payee + UPI ID,
                                 then on the narration ─▶ method pattern
                              4. bank entries, salary, refunds, people
                              nothing fits ─▶ uncategorised
change category ─▶ setCategory: manual + training label
                   "Always for <payee>" ─▶ merchant-key or UPI ID rule
                                         ─▶ re-run for that payee
```

- **Categories** start from 29 built-in ones with fixed ids (`cat.food_delivery`),
  added on every database open if missing, so new ones arrive with updates.
  Each has a spend class (fixed, flexible, income, transfer).
- **Never overwritten:** a category you set by hand (`categorized_by = manual`).
- **Rules** are rows in `category_rules` (merchant key, UPI ID, keyword or
  regex, optionally by direction). A correction updates your existing rule for
  that payee rather than adding a second one. Deleting a rule re-runs the
  categoriser on what it had matched.
- **"See why"** re-runs the categoriser for the transaction on the device and
  shows the matched rule or word. Guesses below confidence 0.75 (a payee that
  looks like a person) say so.
- **Training labels** keep only model features (merchant key, UPI handle,
  direction, channel), never names, amounts or narration. The on-device model
  that learns from them is phase 11.

### AI gateway and consent (phase 5)

```
user taps "Ask AI" ─▶ build minimal, redacted context ─▶ provider adapter
                     (primary key, then backup key)          │
                                                             ▼
                         proposals (pending, with a before/after diff
                         and a base version of every row they touch)
                                                             │
                                user approves / rejects ◀────┘
                                                             │
                       apply in one transaction; if any row's version
                       moved, the proposal is marked stale instead
                                                             │
                                                             ▼
                                                 audit_log (hash chained)
```

- The gateway interface is provider-agnostic. Each provider is an adapter.
- AI never gets write access. It can only create `proposals`.
- `ai_requests` records what was sent (as a redacted summary), the token counts,
  the cost and the outcome, never the raw prompt contents.

## UI

- `finance_ui_kit` owns every colour, spacing, radius, motion and type token.
  Screens read them from `context.colors` and the theme.
- Light and dark themes are both WCAG AA for text (enforced by `tokens_test`).
- The style is diagram first: donut, budget bars and progress rings. Every insight
  has a "see why" that shows the numbers behind it.
- Material 3 is used on Android. `UiStyle` leaves room for Cupertino on iOS later.

### Screens (phase 4 and 4b)

Five tabs along the bottom (`AppShell`, a go_router `StatefulShellRoute`, so
each tab keeps its place): Home, Records, Budgets, Accounts and Categories.
Sheets open on the root navigator so they cover the tab bar.

- **Home** is the analytics dashboard for an IST week (Monday first), month
  or year (`Period`, `summarizePeriod` in `finance_core`): spent, came in
  and the difference (tap either of the first two to switch the breakdown),
  against the previous period; for a month, a ring of what's left of the
  income; the "needs a category" count; account balances; a donut with a
  `BreakdownRow` per category (amount, bar, percent) that opens the
  filtered list; a `TrendChart` per day or month with its average; for a
  month, `SpendCurve` against last month and a `DayGrid` calendar; the
  three fullest budgets; and the latest transactions. Transfers never count
  and refunds come off the category they were filed under.
- **Records** (and the pushed `/transactions`) filter by month or date
  range, money in or out, category, account and "needs a category", plus a
  search over payee, UPI ID and narration (`TransactionsRepository
  .watchFiltered`, in SQL). Routes carry the filter as query parameters
  (`/transactions?month=2026-10&category=cat.groceries`,
  `?from=2026-10-05&to=2026-10-11`).
- **Add** (`/add`) records an expense, income or transfer by hand
  (`ManualEntries`): a `CalcKeypad` whose sum `evaluateAmount` works out in
  exact paise, account and category pickers, a note, date and time. A
  transfer is two linked rows with `flow = transfer`. A category you pick is
  `manual`, so the categoriser never changes it. Entries with no
  `transaction_sources` row are yours and can be removed (soft delete).
- **Budgets** set one monthly limit per spending category (`budgets` table,
  `BudgetsRepository`), shown against the month's spending with
  `budgetMonth`, plus "Not budgeted this month".
- **Accounts** list balances by kind (bank, card, cash, wallet,
  investment). A balance is `opening_balance_paise` (schema v3) plus money in
  less money out, worked out in SQL (`watchBalances`).
- **Categories** lists money out, money in and transfers. You can add your
  own (name, fixed or flexible, icon, colour), edit any, set a budget, or
  remove one you added: its transactions go back to "Needs a category" and
  its rules and budget go too. Built-in ones can't be removed.
- **Sort** (`/sort`) is the labelling queue: one transaction at a time, with
  the guess if there is one, "Always for <payee>", and skip.
- **Appearance** (home's toolbar) picks light, dark or same as phone; the
  choice is kept in `SecretStore` so no extra storage plugin is needed.

## App lock

`LockController` (Riverpod) is the single source of truth: `checking`,
`needsSetup`, `locked` or `unlocked`. The router redirects every route to the lock
screens unless the state is `unlocked`, so nothing behind the lock can render. An
`AppLifecycleListener` re-locks after `autoLockAfter` (1 minute) in the background.
`MainActivity` is a `FlutterFragmentActivity` (needed by `local_auth`) with
`FLAG_SECURE` set.
