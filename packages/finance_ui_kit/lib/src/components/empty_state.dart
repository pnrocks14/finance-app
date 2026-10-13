import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../tokens/finance_colors.dart';
import '../tokens/layout_tokens.dart';
import 'basics.dart';

/// A friendly empty screen: a small drawn illustration, a short line of
/// copy and one action.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(Space.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CoinsIllustration(size: 120),
          const SizedBox(height: Space.xl),
          Text(title, style: theme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: Space.s),
          Text(message, style: theme.bodyMedium, textAlign: TextAlign.center),
          if (actionLabel != null) ...[
            const SizedBox(height: Space.xl),
            PillButton(label: actionLabel!, onPressed: onAction),
          ],
        ],
      ),
    );
  }
}

/// A soft blob with a small stack of coins, drawn from the palette so it
/// follows light and dark themes. A placeholder until the illustration set
/// is chosen.
class CoinsIllustration extends StatelessWidget {
  const CoinsIllustration({super.key, this.size = 120});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size.square(size),
        painter: _CoinsPainter(context.colors),
      ),
    );
  }
}

class _CoinsPainter extends CustomPainter {
  _CoinsPainter(this.c);

  final FinanceColors c;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final center = Offset(w / 2, w / 2);

    // Soft background blob.
    final blob = Path();
    for (var i = 0; i <= 64; i++) {
      final a = i / 64 * math.pi * 2;
      final r =
          w * 0.44 * (1 + 0.05 * math.sin(a * 3) + 0.03 * math.cos(a * 5));
      final p = center + Offset(math.cos(a) * r, math.sin(a) * r);
      i == 0 ? blob.moveTo(p.dx, p.dy) : blob.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(blob, Paint()..color = c.surfaceSoft);

    // Stack of coins.
    final coin = Paint()..color = c.accent;
    final rim = Paint()
      ..color = c.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.02;
    for (var i = 0; i < 3; i++) {
      final r = Rect.fromCenter(
        center: Offset(w * 0.42, w * (0.66 - i * 0.09)),
        width: w * 0.34,
        height: w * 0.12,
      );
      canvas.drawOval(r, coin);
      canvas.drawOval(r, rim);
    }

    // One coin standing, with a rupee mark.
    final standing = Offset(w * 0.64, w * 0.48);
    canvas.drawCircle(standing, w * 0.15, coin);
    canvas.drawCircle(standing, w * 0.15, rim);
    final tp = TextPainter(
      text: TextSpan(
        text: '₹',
        style: TextStyle(
          color: c.primary,
          fontSize: w * 0.17,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, standing - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(_CoinsPainter old) => old.c != c;
}
