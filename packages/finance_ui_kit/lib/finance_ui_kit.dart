/// The finance app's design system: colour, type, spacing and motion tokens,
/// light and dark themes, and shared components.
///
/// Screens build from these components and tokens only. Platform-specific
/// rendering (Material now, Cupertino later) lives here, never in screens.
library;

export 'src/components/basics.dart';
export 'src/components/charts.dart';
export 'src/components/empty_state.dart';
export 'src/components/money_text.dart';
export 'src/components/pin_pad.dart';
export 'src/platform/ui_style.dart';
export 'src/theme/finance_theme.dart';
export 'src/tokens/finance_colors.dart';
export 'src/tokens/layout_tokens.dart';
export 'src/tokens/typography.dart';
