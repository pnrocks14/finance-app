# 0003: Money as integer paise, dates in IST

- Status: accepted
- Date: 2026-10-12

## Decision

- **Money:** `Paise`, a Dart extension type over `int`. Parsing accepts
  ₹/Rs/INR prefixes and Indian or Western digit grouping, and rejects ambiguous
  input such as `12,34`. Percentages round half away from zero. Formatting uses
  Indian grouping (₹1,23,456.50) and a compact form (₹1.2L, ₹3.4Cr).
- **Instants:** UTC `DateTime`.
- **Calendar dates:** `LocalDate` in IST (+05:30, no DST), stored as
  `YYYY-MM-DD`. A month means an IST calendar month.
- **Stored enums:** stable snake_case wire names.

## Consequences

- No float rounding errors in totals or budgets.
- A transaction at 00:30 IST on the 1st belongs to that month, not the previous
  one.
