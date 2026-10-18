import 'dart:math' as math;

import 'package:finance_core/finance_core.dart';
import 'package:flutter/material.dart';

import '../tokens/finance_colors.dart';
import '../tokens/layout_tokens.dart';
import '../tokens/typography.dart';
import 'money_text.dart';

/// How a spend compares with its limit.
enum BudgetTone {
  /// Under [warnAt] of the limit.
  good,

  /// Between [warnAt] and the limit.
  caution,

  /// Over the limit.
  over;

  static BudgetTone of(Paise spent, Paise limit, {double warnAt = 0.8}) {
    if (limit.value <= 0) return BudgetTone.over;
    final ratio = spent.value / limit.value;
    if (ratio > 1) return BudgetTone.over;
    if (ratio >= warnAt) return BudgetTone.caution;
    return BudgetTone.good;
  }

  Color color(FinanceColors c) => switch (this) {
    BudgetTone.good => c.good,
    BudgetTone.caution => c.caution,
    BudgetTone.over => c.over,
  };

  IconData get icon => switch (this) {
    BudgetTone.good => Icons.check_circle_rounded,
    BudgetTone.caution => Icons.error_outline_rounded,
    BudgetTone.over => Icons.warning_amber_rounded,
  };
}

/// A ring that fills toward a target: budgets and goals.
///
/// [progress] is 0 to 1; anything above 1 shows a full ring. The [child] sits
/// in the centre, usually the amount or a percentage.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.progress,
    required this.color,
    this.size = 120,
    this.thickness = 12,
    this.child,
    this.semanticLabel,
  });

  final double progress;
  final Color color;
  final double size;
  final double thickness;
  final Widget? child;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final track = context.colors.surfaceSoft;
    return Semantics(
      label: semanticLabel,
      value: '${(progress * 100).round()} percent',
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: progress.clamp(0, 1)),
        duration: Motion.chart,
        curve: Motion.curve,
        builder: (context, value, _) => CustomPaint(
          size: Size.square(size),
          painter: _RingPainter(value, color, track, thickness),
          child: SizedBox.square(
            dimension: size,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.value, this.color, this.track, this.thickness);

  final double value;
  final Color color;
  final Color track;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(thickness / 2);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(arcRect, 0, math.pi * 2, false, base..color = track);
    if (value > 0) {
      canvas.drawArc(
        arcRect,
        -math.pi / 2,
        math.pi * 2 * value,
        false,
        base..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.color != color || old.track != track;
}

/// One slice of a [CategoryDonut].
@immutable
class DonutSlice {
  const DonutSlice({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final Paise amount;
  final Color color;
}

/// Spending by category: a donut with the total in its centre.
class CategoryDonut extends StatelessWidget {
  const CategoryDonut({
    super.key,
    required this.slices,
    this.size = 200,
    this.thickness = 26,
    this.centerLabel = 'spent',
  });

  final List<DonutSlice> slices;
  final double size;
  final double thickness;

  /// The small word under the total, e.g. "spent in October".
  final String centerLabel;

  Paise get total => slices.fold(Paise.zero, (sum, s) => sum + s.amount);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    final spoken = slices
        .map((s) => '${s.label} ${formatInr(s.amount)}')
        .join(', ');
    return Semantics(
      label: 'Spending by category. Total ${formatInr(total)}. $spoken',
      excludeSemantics: true,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: Motion.chart,
        curve: Motion.curve,
        builder: (context, t, _) => CustomPaint(
          size: Size.square(size),
          painter: _DonutPainter(slices, t, thickness, c.surfaceSoft),
          child: SizedBox.square(
            dimension: size,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MoneyText(
                    total,
                    style: theme.headlineMedium,
                    paise: PaiseDisplay.never,
                  ),
                  Text(centerLabel, style: theme.bodySmall),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter(this.slices, this.t, this.thickness, this.track);

  final List<DonutSlice> slices;
  final double t;
  final double thickness;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final arcRect = (Offset.zero & size).deflate(thickness / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.butt;
    final total = slices.fold<int>(0, (sum, s) => sum + s.amount.value);
    if (total <= 0) {
      canvas.drawArc(arcRect, 0, math.pi * 2, false, paint..color = track);
      return;
    }
    // A small gap between slices keeps neighbours readable.
    const gap = 0.035;
    final sweepTotal = math.pi * 2 * t;
    var start = -math.pi / 2;
    for (final slice in slices) {
      final sweep = sweepTotal * slice.amount.value / total;
      final drawn = slices.length > 1 ? math.max(0.0, sweep - gap) : sweep;
      if (drawn > 0) {
        canvas.drawArc(
          arcRect,
          start,
          drawn,
          false,
          paint..color = slice.color,
        );
      }
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) => old.t != t || old.slices != slices;
}

/// A legend row for a donut: colour dot, name, amount and share.
class DonutLegend extends StatelessWidget {
  const DonutLegend({super.key, required this.slices, this.onTap});

  final List<DonutSlice> slices;

  /// Called with the slice's index when a row is tapped.
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final total = slices.fold<int>(0, (sum, s) => sum + s.amount.value);
    return Column(
      children: [
        for (final (i, s) in slices.indexed)
          InkWell(
            borderRadius: BorderRadius.circular(Radii.chip),
            onTap: onTap == null ? null : () => onTap!(i),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Space.xs),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: s.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: Space.m),
                  Expanded(child: Text(s.label, style: theme.labelMedium)),
                  MoneyText(
                    s.amount,
                    style: theme.labelMedium,
                    paise: PaiseDisplay.never,
                  ),
                  SizedBox(
                    width: 48,
                    child: Text(
                      total == 0
                          ? ''
                          : '${(s.amount.value * 100 / total).round()}%',
                      textAlign: TextAlign.end,
                      style: theme.bodySmall?.copyWith(
                        fontFeatures: tabularFigures,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// A horizontal budget bar: how much of a category's limit is used, with a
/// friendly line under it ("₹3,100 left" or "₹450 over").
class BudgetBar extends StatelessWidget {
  const BudgetBar({
    super.key,
    required this.label,
    required this.spent,
    required this.limit,
    this.warnAt = 0.8,
  });

  final String label;
  final Paise spent;
  final Paise limit;
  final double warnAt;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final theme = Theme.of(context).textTheme;
    final tone = BudgetTone.of(spent, limit, warnAt: warnAt);
    final color = tone.color(c);
    final ratio = limit.value <= 0
        ? 1.0
        : (spent.value / limit.value).clamp(0.0, 1.0);
    final left = limit - spent;
    final note = left.isNegative
        ? '${formatInr(-left)} over'
        : '${formatInr(left)} left';

    return Semantics(
      label: '$label: ${formatInr(spent)} of ${formatInr(limit)}. $note',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: theme.titleMedium)),
              MoneyText(
                spent,
                style: theme.titleMedium,
                paise: PaiseDisplay.never,
              ),
              Text(' / ', style: theme.bodyMedium),
              MoneyText(
                limit,
                style: theme.bodyMedium,
                paise: PaiseDisplay.never,
              ),
            ],
          ),
          const SizedBox(height: Space.s),
          ClipRRect(
            borderRadius: BorderRadius.circular(Radii.pill),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: ratio),
              duration: Motion.chart,
              curve: Motion.curve,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 10,
                color: color,
                backgroundColor: c.surfaceSoft,
              ),
            ),
          ),
          const SizedBox(height: Space.s),
          Row(
            children: [
              Icon(tone.icon, size: 16, color: color),
              const SizedBox(width: Space.xs),
              Text(
                note,
                style: theme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Spending through the month: this month's running total as a line, with
/// last month's as a faint dashed line to compare against. Each list has
/// one value per day; [current] may stop early (today).
class SpendCurve extends StatelessWidget {
  const SpendCurve({
    super.key,
    required this.current,
    this.previous = const [],
    this.height = 160,
  });

  final List<Paise> current;
  final List<Paise> previous;
  final double height;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final theme = Theme.of(context).textTheme;
    final top = [
      ...current,
      ...previous,
    ].fold<int>(0, (m, p) => math.max(m, p.value));
    final now = current.isEmpty ? Paise.zero : current.last;
    final then = previous.length >= current.length && current.isNotEmpty
        ? previous[current.length - 1]
        : null;
    return Semantics(
      label:
          'Spending so far ${formatInr(now)}'
          '${then == null ? '' : ', last month by this day ${formatInr(then)}'}',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Motion.chart,
            curve: Motion.curve,
            builder: (context, t, _) => CustomPaint(
              size: Size(double.infinity, height),
              painter: _CurvePainter(
                current: current,
                previous: previous,
                top: top,
                t: t,
                line: c.primary,
                faint: c.textSecondary.withValues(alpha: 0.45),
                grid: c.surfaceSoft,
              ),
            ),
          ),
          const SizedBox(height: Space.xs),
          Row(
            children: [
              Text('1', style: theme.bodySmall),
              const Spacer(),
              if (previous.isNotEmpty)
                Text('- - last month', style: theme.bodySmall),
              const Spacer(),
              Text(
                '${math.max(current.length, previous.length)}',
                style: theme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CurvePainter extends CustomPainter {
  _CurvePainter({
    required this.current,
    required this.previous,
    required this.top,
    required this.t,
    required this.line,
    required this.faint,
    required this.grid,
  });

  final List<Paise> current;
  final List<Paise> previous;
  final int top;
  final double t;
  final Color line;
  final Color faint;
  final Color grid;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (var i = 0; i <= 3; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    final days = math.max(current.length, previous.length);
    if (days < 2 || top <= 0) return;
    Offset at(int i, Paise p) => Offset(
      size.width * i / (days - 1),
      size.height - size.height * (math.max(0, p.value) / top) * t,
    );

    if (previous.length >= 2) {
      final paint = Paint()
        ..color = faint
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      for (var i = 1; i < previous.length; i += 2) {
        canvas.drawLine(at(i - 1, previous[i - 1]), at(i, previous[i]), paint);
      }
    }
    if (current.isNotEmpty) {
      final path = Path()..moveTo(at(0, current[0]).dx, at(0, current[0]).dy);
      for (var i = 1; i < current.length; i++) {
        final p = at(i, current[i]);
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = line
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke,
      );
      final end = at(current.length - 1, current.last);
      canvas.drawCircle(end, 5, Paint()..color = line);
    }
  }

  @override
  bool shouldRepaint(_CurvePainter old) =>
      old.t != t ||
      old.top != top ||
      old.current != current ||
      old.previous != previous ||
      old.line != line;
}
