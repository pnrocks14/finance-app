# 0001: Pub workspace with four packages

- Status: accepted
- Date: 2026-10-12

## Context

The app has pure logic (money, parsing, categorisation), storage, a design system
and screens. We want fast tests for the logic and a clear dependency direction.

## Decision

Use a Dart pub workspace (`workspace:` in the root `pubspec.yaml`) with these members:

- `packages/finance_core` (pure Dart)
- `packages/finance_data` (Drift, secure storage)
- `packages/finance_ui_kit` (design system)
- `app` (Flutter app)

Dependencies point only toward `finance_core`.

## Consequences

- One `flutter pub get` and one lockfile for everything.
- Core logic tests run with `dart test`, without a Flutter engine.
- Packages are not published. They use `path:` dependencies.
