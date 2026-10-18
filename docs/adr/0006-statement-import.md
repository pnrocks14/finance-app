# 0006: CSV statement import

- Status: accepted
- Date: 2026-10-14

## Context

Phase 2 imports bank statements. The plan named CSV first, then PDF. Kartick
hasn't shared bank names or sample files yet.

## Decision

- **Banks:** presets for HDFC, ICICI, SBI, Axis and Kotak, built from each bank's
  published CSV layout, plus generic header names and an on-screen column mapper
  for anything else. The presets are unverified until real (anonymised) samples
  arrive.
- **No silent drops:** every line after the header is a transaction, a reported
  error (line number, reason, redacted excerpt), a blank line or the footer.
  Parsing stops at known footer markers such as "Statement summary" and
  "Opening balance".
- **Balance checksum:** a row whose balance doesn't follow from the previous row is
  imported but flagged. Both oldest-first and newest-first orders are tried.
- **Dedupe:** a hash of account, date, direction, amount, normalised description
  and balance, plus the occurrence number within the file. Importing the same
  statement twice creates nothing. Two genuinely identical rows stay two
  transactions.
- **Transfers:** pairs across your accounts (same amount, within 2 days), card bill
  payments and your own UPI IDs are marked `transfer`, so they count as neither
  spend nor income.
- **Schema 2** adds `transactions.flow_reason` and `transactions.transfer_pair_id`
  so "see why" can explain the flow. Existing rows get `direction`.
- **File access:** the Android document picker, so the app needs no storage
  permission. Files are capped at 20 MB.

## Consequences

- PDF statements (pdfrx text with positions and per-bank layouts) and Excel
  exports follow in a separate PR.
- When a statement and an SMS both describe one payment, they are matched in
  phase 5. Until then, statement rows are `reconciliation_status = single`.
