# 0010: Analytics home, tabs, manual entries and budgets

- Status: accepted
- Date: 2026-10-18

## Context

After phase 4, Kartick said home was "just a home screen with all the
transactions" and asked for the whole analytics dashboard as home, using a
popular expense tracker's screenshots as a reference for features: custom
categories, multiple accounts with balances, expense flow, an overview with
per-category percentages, adding records by hand with a calculator, a
budget planner, a period switcher and bottom tabs.

## Decision

- **Home is the dashboard**, built from our design system, not the
  reference's look. One period (week, month or year) drives every section.
  The reference's separate "Analysis" tab is merged into home.
- **Five tabs**: Home, Records, Budgets, Accounts, Categories, with a
  `StatefulShellRoute` so each keeps its scroll and filters.
- **Manual entries are ordinary transactions** with `channel = other`,
  `flow_reason = user` and no source record, so every total, filter and
  balance treats them like imported ones. Removing one is a soft delete and
  is only offered for entries you added.
- **Keypad sums are exact.** `evaluateAmount` uses fractions, never
  `double`, and rounds once to the paisa.
- **Budgets come forward from phase 6** as one monthly limit per category.
  Warnings and rollover stay in phase 6.
- **Balances need an opening balance** (schema v3), since statements only
  show movements; the closing balance column isn't trusted yet.
- **Account kinds gain cash and investment** (new wire values, no
  migration).

## Consequences

- A year view reads every transaction in the year; fine for a personal
  ledger, and it's one indexed range query.
- Opening balances are typed by hand. Reading them from a statement's
  opening line can come later.
