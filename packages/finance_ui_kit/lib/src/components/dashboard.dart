import 'dart:math' as math;

import 'package:finance_core/finance_core.dart';
import 'package:flutter/material.dart';

import '../tokens/finance_colors.dart';
import '../tokens/layout_tokens.dart';
import '../tokens/typography.dart';
import 'money_text.dart';

/// One row of a category breakdown: a badge, the name, the amount, a bar
/// for its share of the total and the percent.
class BreakdownRow extends StatelessWidget {
  const BreakdownRow({
    super.key,
    required this.leading,
    required this.label,
    required this.amount,
    required this.share,
    required this.color,
    this.onTap,
  });

  final Widget leading;
  final String label;
  final Paise amount;

  /// 0 to 1.
  final double share;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    final percent = share <= 0
        ? '0%'
        : share < 0.01
        ? '<1%'
        : '${(share * 100).round()}%';
    return Semantics(
      button: onTap != null,
      label:
          '$label, ${formatInr(amount, paise: PaiseDisplay.never)}, '
          '$percent',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radii.chip),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Space.s),
          child: Row(
            children: [
              leading,
              const SizedBox(width: Space.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            label,
                            style: theme.bodyLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        MoneyText(
                          amount,
                          style: theme.titleSmall,
                          paise: PaiseDisplay.never,
                        ),
                      ],
                    ),
                    const SizedBox(height: Space.xs),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Radii.pill),
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(
                                begin: 0,
                                end: share.clamp(0.0, 1.0),
                              ),
                              duration: Motion.chart,
                              curve: Motion.curve,
                              builder: (context, v, _) =>
                                  LinearProgressIndicator(
                                    value: v,
                                    minHeight: 6,
                                    color: color,
                                    backgroundColor: c.surfaceSoft,
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 44,
                          child: Text(
                            percent,
                            textAlign: TextAlign.end,
                            style: theme.bodySmall?.copyWith(
                              fontFeatures: tabularFigures,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Amounts over time as a line with a soft fill: one point per day of a
/// week or month, or per month of a year. A dashed line marks the average.
class TrendChart extends StatelessWidget {
  const TrendChart({
    super.key,
    required this.values,
    required this.labels,
    required this.color,
    this.height = 160,
    this.semanticLabel,
  });

  final List<Paise> values;

  /// Labels under the chart, spread evenly: usually first, middle, last.
  final List<String> labels;
  final Color color;
  final double height;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final theme = Theme.of(context).textTheme;
    final top = values.fold<int>(0, (m, p) => math.max(m, p.value));
    final total = values.fold<int>(0, (s, p) => s + math.max(0, p.value));
    final average = values.isEmpty ? 0 : total ~/ values.length;
    return Semantics(
      label:
          semanticLabel ??
          'Highest ${formatInr(Paise(top), paise: PaiseDisplay.never)}, '
              'average ${formatInr(Paise(average), paise: PaiseDisplay.never)}',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Highest ${formatInrCompact(Paise(top))}',
                style: theme.bodySmall,
              ),
              const Spacer(),
              Text(
                '- - average ${formatInrCompact(Paise(average))}',
                style: theme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: Space.s),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Motion.chart,
            curve: Motion.curve,
            builder: (context, t, _) => CustomPaint(
              size: Size(double.infinity, height),
              painter: _TrendPainter(
                values: values,
                top: top,
                average: average,
                t: t,
                line: color,
                faint: c.textSecondary.withValues(alpha: 0.45),
                grid: c.surfaceSoft,
              ),
            ),
          ),
          const SizedBox(height: Space.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [for (final l in labels) Text(l, style: theme.bodySmall)],
          ),
        ],
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  _TrendPainter({
    required this.values,
    required this.top,
    required this.average,
    required this.t,
    required this.line,
    required this.faint,
    required this.grid,
  });

  final List<Paise> values;
  final int top;
  final int average;
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
    if (values.isEmpty || top <= 0) return;
    final n = values.length;
    Offset at(int i, int v) => Offset(
      n == 1 ? size.width / 2 : size.width * i / (n - 1),
      size.height - size.height * math.max(0, v) / top * t,
    );

    final path = Path()
      ..moveTo(at(0, values[0].value).dx, at(0, values[0].value).dy);
    for (var i = 1; i < n; i++) {
      final p = at(i, values[i].value);
      path.lineTo(p.dx, p.dy);
    }
    final fill = Path.from(path)
      ..lineTo(at(n - 1, 0).dx, size.height)
      ..lineTo(at(0, 0).dx, size.height)
      ..close();
    canvas
      ..drawPath(
        fill,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [line.withValues(alpha: 0.28), line.withValues(alpha: 0)],
          ).createShader(Offset.zero & size),
      )
      ..drawPath(
        path,
        Paint()
          ..color = line
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round,
      );
    if (n <= 12) {
      final dot = Paint()..color = line;
      for (var i = 0; i < n; i++) {
        canvas.drawCircle(at(i, values[i].value), 3.5, dot);
      }
    }
    // Dashed average.
    final y = size.height - size.height * average / top * t;
    final dash = Paint()
      ..color = faint
      ..strokeWidth = 1.5;
    for (var x = 0.0; x < size.width; x += 10) {
      canvas.drawLine(
        Offset(x, y),
        Offset(math.min(x + 5, size.width), y),
        dash,
      );
    }
  }

  @override
  bool shouldRepaint(_TrendPainter old) =>
      old.t != t || old.values != values || old.line != line;
}

/// A month as a calendar, Monday first: each day shows what was spent,
/// shaded by how much. Tap a day to see it.
class DayGrid extends StatelessWidget {
  const DayGrid({
    super.key,
    required this.month,
    required this.values,
    required this.color,
    this.onTap,
  });

  /// The first day of the month.
  final LocalDate month;

  /// One amount per day of the month.
  final List<Paise> values;
  final Color color;
  final ValueChanged<LocalDate>? onTap;

  static const _weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    final top = values.fold<int>(0, (m, p) => math.max(m, p.value));
    final lead = month.weekday - 1;
    final cells = lead + values.length;
    final rows = (cells / 7).ceil();
    return Column(
      children: [
        Row(
          children: [
            for (final d in _weekdays)
              Expanded(
                child: Text(
                  d,
                  textAlign: TextAlign.center,
                  style: theme.bodySmall,
                ),
              ),
          ],
        ),
        const SizedBox(height: Space.xs),
        for (var r = 0; r < rows; r++)
          Row(
            children: [
              for (var col = 0; col < 7; col++)
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final i = r * 7 + col - lead;
                      if (i < 0 || i >= values.length) {
                        return const SizedBox(height: 52);
                      }
                      final v = values[i];
                      final day = month.addDays(i);
                      final strength = top <= 0 || v.value <= 0
                          ? 0.0
                          : 0.12 + 0.6 * v.value / top;
                      return Padding(
                        padding: const EdgeInsets.all(2),
                        child: Material(
                          color: v.value > 0
                              ? color.withValues(alpha: strength)
                              : c.surfaceSoft,
                          borderRadius: BorderRadius.circular(Radii.chip / 2),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(Radii.chip / 2),
                            onTap: onTap == null ? null : () => onTap!(day),
                            child: Semantics(
                              label:
                                  '${day.day}: ${formatInr(v, paise: PaiseDisplay.never)}',
                              excludeSemantics: true,
                              child: SizedBox(
                                height: 48,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${day.day}',
                                      style: theme.labelMedium,
                                    ),
                                    if (v.value > 0)
                                      Text(
                                        formatInrCompact(v),
                                        style: theme.bodySmall?.copyWith(
                                          fontSize: 10,
                                          fontFeatures: tabularFigures,
                                        ),
                                        maxLines: 1,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

/// A calculator keypad for amounts. Sends each key as text: digits, `.`,
/// `+ − × ÷`, `⌫` to delete and `=` to work the sum out.
class CalcKeypad extends StatelessWidget {
  const CalcKeypad({super.key, required this.onKey});

  final ValueChanged<String> onKey;

  static const _rows = [
    ['7', '8', '9', '÷'],
    ['4', '5', '6', '×'],
    ['1', '2', '3', '−'],
    ['.', '0', '⌫', '+'],
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final theme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in _rows)
          Row(
            children: [
              for (final k in row)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(Space.xs / 2),
                    child: Material(
                      color: amountOperators.contains(k)
                          ? c.primary.withValues(alpha: 0.12)
                          : c.surfaceSoft,
                      borderRadius: BorderRadius.circular(Radii.chip),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(Radii.chip),
                        onTap: () => onKey(k),
                        child: SizedBox(
                          height: 52,
                          child: Center(
                            child: k == '⌫'
                                ? Icon(
                                    Icons.backspace_outlined,
                                    semanticLabel: 'Delete',
                                    color: c.textPrimary,
                                  )
                                : Text(
                                    k,
                                    style: theme.titleLarge?.copyWith(
                                      color: amountOperators.contains(k)
                                          ? c.primary
                                          : c.textPrimary,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

/// Applies one keypad key to the text of a sum: keeps at most two decimals
/// per number and one operator in a row, and never starts with an
/// operator.
String applyKey(String text, String key) {
  if (key == '⌫') {
    return text.isEmpty ? text : text.substring(0, text.length - 1);
  }
  if (key == '=') return text;
  final last = text.isEmpty ? '' : text[text.length - 1];
  if (amountOperators.contains(key)) {
    if (text.isEmpty) return text;
    if (amountOperators.contains(last)) {
      return text.substring(0, text.length - 1) + key;
    }
    return text + key;
  }
  final current = text.split(RegExp('[+−×÷]')).last;
  if (key == '.') {
    if (current.contains('.')) return text;
    return text + (current.isEmpty ? '0.' : '.');
  }
  final dot = current.indexOf('.');
  if (dot >= 0 && current.length - dot > 2) return text;
  if (current == '0') return text.substring(0, text.length - 1) + key;
  if (current.replaceAll('.', '').length >= 9) return text;
  return text + key;
}
