# 0009: Categorisation on the device, rules first

- Status: accepted
- Date: 2026-10-18

## Context

Transactions need categories for budgets, goals and advice. Everything must
stay on the phone, Kartick must be able to see why a category was picked,
and a correction should stick without retraining anything.

## Decision

- **A fixed order, in pure Dart** (`Categorizer`): transfers, then your
  rules, then a built-in merchant dictionary, then simple heuristics.
  Nothing fitting means "Needs a category", not a guess.
- **Corrections make rules.** Changing a category with "Always for <payee>"
  on creates (or updates) a rule on the payee's merchant key, or its UPI ID
  when there is no name, limited to the same direction. Other transactions
  from that payee follow unless you set them by hand.
- **Hand-set is final.** The categoriser never changes a `manual` category.
- **Built-in categories have fixed ids** and are seeded on open with
  insert-or-ignore, so renaming one is safe and new ones need no migration.
- **Words match whole.** Dictionary keywords match whole words in the payee
  and UPI ID first (confidence 0.9) and the narration second (0.8), so
  "ola" doesn't match "Kolar".
- **No model yet.** Corrections are stored as training labels with features
  only, for the on-device model in phase 11.

## Consequences

- "See why" can always name the rule or word that matched.
- The dictionary needs upkeep as merchants change; misses show up as "Needs
  a category" and are fixed once per payee.
- A payee whose name changes between statements needs a second correction.
