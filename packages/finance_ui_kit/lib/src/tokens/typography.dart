import 'package:flutter/material.dart';

/// Plus Jakarta Sans, bundled with this package (SIL Open Font License, see
/// assets/fonts/OFL.txt). Fonts from a package need the package name.
const String fontFamily = 'PlusJakartaSans';
const String fontPackage = 'finance_ui_kit';

/// The type scale: 32 display, 24 title, 18 heading, 16 body, 14 secondary,
/// 12 caption.
TextTheme buildTextTheme(Color primary, Color secondary) {
  TextStyle style(
    double size,
    FontWeight weight,
    Color color, {
    double? height,
  }) => TextStyle(
    fontFamily: fontFamily,
    package: fontPackage,
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: 0,
  );

  return TextTheme(
    displayLarge: style(32, FontWeight.w800, primary, height: 1.15),
    displayMedium: style(28, FontWeight.w800, primary, height: 1.15),
    headlineMedium: style(24, FontWeight.w700, primary, height: 1.2),
    titleLarge: style(18, FontWeight.w700, primary, height: 1.3),
    titleMedium: style(16, FontWeight.w600, primary, height: 1.35),
    bodyLarge: style(16, FontWeight.w400, primary, height: 1.45),
    bodyMedium: style(14, FontWeight.w500, secondary, height: 1.45),
    labelLarge: style(16, FontWeight.w700, primary),
    labelMedium: style(14, FontWeight.w600, primary),
    bodySmall: style(12, FontWeight.w500, secondary, height: 1.35),
  );
}

/// Digits line up in columns of amounts.
const List<FontFeature> tabularFigures = [FontFeature.tabularFigures()];
