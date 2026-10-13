import 'dart:math' as math;

import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

double _luminance(Color c) {
  double channel(double v) =>
      v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * channel(c.r) + 0.7152 * channel(c.g) + 0.0722 * channel(c.b);
}

double contrast(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  final hi = math.max(la, lb);
  final lo = math.min(la, lb);
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  for (final (name, c) in [
    ('light', FinanceColors.light),
    ('dark', FinanceColors.dark),
  ]) {
    group('$name palette meets WCAG AA', () {
      final textTokens = {
        'textPrimary': c.textPrimary,
        'textSecondary': c.textSecondary,
        'primary': c.primary,
        'good': c.good,
        'caution': c.caution,
        'over': c.over,
      };
      for (final entry in textTokens.entries) {
        test('${entry.key} on bg and surface', () {
          expect(contrast(entry.value, c.bg), greaterThanOrEqualTo(4.5));
          expect(contrast(entry.value, c.surface), greaterThanOrEqualTo(4.5));
        });
      }
      test('button and accent text', () {
        expect(contrast(c.onPrimary, c.primary), greaterThanOrEqualTo(4.5));
        expect(contrast(c.onAccent, c.accent), greaterThanOrEqualTo(4.5));
      });
      test('has eight chart colours', () {
        expect(c.chart, hasLength(8));
        expect(c.chartToken('chart3'), c.chart[2]);
        expect(c.chartToken('nonsense'), c.chart.first);
      });
    });
  }

  test('themes carry the colour tokens', () {
    expect(
      FinanceTheme.light().extension<FinanceColors>(),
      FinanceColors.light,
    );
    expect(FinanceTheme.dark().extension<FinanceColors>(), FinanceColors.dark);
    expect(FinanceTheme.dark().brightness, Brightness.dark);
  });

  test('UiStyle follows the platform', () {
    expect(UiStyle.forPlatform(TargetPlatform.android), UiStyle.material);
    expect(UiStyle.forPlatform(TargetPlatform.iOS), UiStyle.cupertino);
  });
}
