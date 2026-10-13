import 'package:finance_core/finance_core.dart';
import 'package:flutter/material.dart';

import '../tokens/typography.dart';

/// An amount in rupees, formatted Indian-style (₹1,23,456) with digits that
/// line up in columns.
class MoneyText extends StatelessWidget {
  const MoneyText(
    this.amount, {
    super.key,
    this.style,
    this.paise = PaiseDisplay.whenNonZero,
    this.compact = false,
    this.color,
  });

  final Paise amount;
  final TextStyle? style;
  final PaiseDisplay paise;

  /// ₹12.3K / ₹4.5L / ₹1.2Cr, for chart labels and tight spaces.
  final bool compact;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final base = style ?? DefaultTextStyle.of(context).style;
    final text = compact
        ? formatInrCompact(amount)
        : formatInr(amount, paise: paise);
    return Text(
      text,
      style: base.copyWith(fontFeatures: tabularFigures, color: color),
      semanticsLabel: _spoken(amount),
    );
  }

  // Screen readers say "450 rupees 50 paise" instead of reading symbols.
  static String _spoken(Paise amount) {
    final sign = amount.isNegative ? 'minus ' : '';
    final rupees = amount.abs().wholeRupees;
    final paise = amount.paisePart;
    return paise == 0
        ? '$sign$rupees rupees'
        : '$sign$rupees rupees $paise paise';
  }
}
