import 'package:finance_core/finance_core.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';

/// A big number with a short label, for import counts.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.value,
    required this.label,
    this.tone,
  });

  final String value;
  final String label;
  final BudgetTone? tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final color = tone?.color(context.colors);
    return AppCard(
      soft: true,
      padding: const EdgeInsets.symmetric(
        vertical: Space.l,
        horizontal: Space.s,
      ),
      child: Semantics(
        label: '$value $label',
        excludeSemantics: true,
        child: Column(
          children: [
            Text(value, style: theme.headlineMedium?.copyWith(color: color)),
            Text(label, style: theme.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

/// `−₹450` for money out, `+₹85,000` in the "good" colour for money in.
class SignedAmount extends StatelessWidget {
  const SignedAmount({
    super.key,
    required this.amount,
    required this.direction,
    this.muted = false,
  });

  final Paise amount;
  final Direction direction;

  /// Transfers are shown muted, since they aren't spend or income.
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final theme = Theme.of(context).textTheme;
    final credit = direction == Direction.credit;
    final text = '${credit ? '+' : '−'}${formatInr(amount)}';
    return Semantics(
      label: '${credit ? 'In' : 'Out'} ${formatInr(amount)}',
      excludeSemantics: true,
      child: Text(
        text,
        style: theme.titleMedium?.copyWith(
          color: muted
              ? c.textSecondary
              : credit
              ? c.good
              : c.textPrimary,
          fontFeatures: tabularFigures,
        ),
      ),
    );
  }
}
