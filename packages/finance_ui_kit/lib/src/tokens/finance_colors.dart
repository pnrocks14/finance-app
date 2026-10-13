import 'package:flutter/material.dart';

/// The app's colour tokens. Screens and components read colours only from
/// here (`context.colors.primary`), never from hex literals, so light and
/// dark themes stay consistent.
///
/// Text tokens meet WCAG AA (4.5:1) on [bg] and [surface]; a test in this
/// package checks it.
@immutable
class FinanceColors extends ThemeExtension<FinanceColors> {
  const FinanceColors({
    required this.bg,
    required this.surface,
    required this.surfaceSoft,
    required this.outline,
    required this.textPrimary,
    required this.textSecondary,
    required this.primary,
    required this.onPrimary,
    required this.accent,
    required this.onAccent,
    required this.good,
    required this.caution,
    required this.over,
    required this.chart,
  });

  /// Page background (cream in light mode).
  final Color bg;

  /// Cards and sheets.
  final Color surface;

  /// Grouped areas, chips, tracks behind rings and bars (sand in light mode).
  final Color surfaceSoft;

  /// Hairlines and dividers.
  final Color outline;
  final Color textPrimary;
  final Color textSecondary;

  /// Main buttons and active states (terracotta).
  final Color primary;
  final Color onPrimary;

  /// Highlights and celebrations (marigold). Text on it uses [onAccent].
  final Color accent;
  final Color onAccent;

  /// On track, under budget (sage).
  final Color good;

  /// Approaching a limit (amber).
  final Color caution;

  /// Over budget (berry). Always paired with an icon and words, never colour
  /// alone.
  final Color over;

  /// Eight category colours for donuts, legends and trend lines, referred to
  /// by token name (`chart1` … `chart8`) in stored data.
  final List<Color> chart;

  Color chartToken(String token) {
    final index = int.tryParse(token.replaceFirst('chart', ''));
    if (index == null || index < 1 || index > chart.length) return chart.first;
    return chart[index - 1];
  }

  static const light = FinanceColors(
    bg: Color(0xFFFFF8F1),
    surface: Color(0xFFFFFFFF),
    surfaceSoft: Color(0xFFF7EBDD),
    outline: Color(0xFFE6D6C5),
    textPrimary: Color(0xFF2B1E16),
    textSecondary: Color(0xFF6E5A4D),
    primary: Color(0xFFB5471F),
    onPrimary: Color(0xFFFFFFFF),
    accent: Color(0xFFF5B841),
    onAccent: Color(0xFF2B1E16),
    good: Color(0xFF3B7347),
    caution: Color(0xFF8A5F00),
    over: Color(0xFFA8325E),
    chart: [
      Color(0xFFC4532A), // terracotta
      Color(0xFFE9A23B), // marigold
      Color(0xFF5E9A6B), // sage
      Color(0xFF4F86B5), // sky
      Color(0xFF8C5BA3), // plum
      Color(0xFFEE8A6A), // peach
      Color(0xFF2F8F8A), // teal
      Color(0xFFB39B7C), // sand
    ],
  );

  static const dark = FinanceColors(
    bg: Color(0xFF1C1512),
    surface: Color(0xFF271E19),
    surfaceSoft: Color(0xFF33271F),
    outline: Color(0xFF4A3B31),
    textPrimary: Color(0xFFF6EDE4),
    textSecondary: Color(0xFFC7B5A6),
    primary: Color(0xFFE8794F),
    onPrimary: Color(0xFF1C1512),
    accent: Color(0xFFF5C561),
    onAccent: Color(0xFF1C1512),
    good: Color(0xFF7DB88A),
    caution: Color(0xFFE3AE3A),
    over: Color(0xFFE27FA1),
    chart: [
      Color(0xFFE8794F),
      Color(0xFFF5C561),
      Color(0xFF8CC49A),
      Color(0xFF7FB0DA),
      Color(0xFFB98ACF),
      Color(0xFFF4A68C),
      Color(0xFF5CC0B9),
      Color(0xFFD1BC9E),
    ],
  );

  @override
  FinanceColors copyWith({
    Color? bg,
    Color? surface,
    Color? surfaceSoft,
    Color? outline,
    Color? textPrimary,
    Color? textSecondary,
    Color? primary,
    Color? onPrimary,
    Color? accent,
    Color? onAccent,
    Color? good,
    Color? caution,
    Color? over,
    List<Color>? chart,
  }) {
    return FinanceColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surfaceSoft: surfaceSoft ?? this.surfaceSoft,
      outline: outline ?? this.outline,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      good: good ?? this.good,
      caution: caution ?? this.caution,
      over: over ?? this.over,
      chart: chart ?? this.chart,
    );
  }

  @override
  FinanceColors lerp(FinanceColors? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return FinanceColors(
      bg: mix(bg, other.bg),
      surface: mix(surface, other.surface),
      surfaceSoft: mix(surfaceSoft, other.surfaceSoft),
      outline: mix(outline, other.outline),
      textPrimary: mix(textPrimary, other.textPrimary),
      textSecondary: mix(textSecondary, other.textSecondary),
      primary: mix(primary, other.primary),
      onPrimary: mix(onPrimary, other.onPrimary),
      accent: mix(accent, other.accent),
      onAccent: mix(onAccent, other.onAccent),
      good: mix(good, other.good),
      caution: mix(caution, other.caution),
      over: mix(over, other.over),
      chart: [
        for (var i = 0; i < chart.length; i++) mix(chart[i], other.chart[i]),
      ],
    );
  }
}

extension FinanceColorsContext on BuildContext {
  /// The current theme's colour tokens.
  FinanceColors get colors =>
      Theme.of(this).extension<FinanceColors>() ?? FinanceColors.light;
}
