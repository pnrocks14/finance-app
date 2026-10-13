# 0004: Warm, diagram-first design system

- Status: proposed (waiting for Kartick to review the style sheet screen)
- Date: 2026-10-12

## Decision

- **Palette:** warm terracotta primary, saffron accent, sage for "good", amber for
  "caution", berry for "over". Light and dark sets live in `FinanceColors`.
  Light-mode status colours were darkened until text passed WCAG AA (4.5:1) on
  both the background and surface. `tokens_test` enforces this.
- **Type:** Plus Jakarta Sans (OFL, bundled, no network fetch). Amounts use
  tabular figures.
- **Shape:** 16 dp cards, pill buttons, 48 dp minimum tap targets, and motion of
  150/250/700 ms with ease-out-cubic.
- **Components:** money text with a spoken label, donut with legend, budget bar
  ("₹3,100 left" or "₹450 over", always with an icon and text, never colour
  alone), progress ring, PIN pad, empty states.
- **Platform:** Material 3 on Android. `UiStyle` allows Cupertino on iOS later.

## Consequences

Screens must use tokens and kit components. The style sheet screen (palette icon
on home) is the reference to review in light and dark.
