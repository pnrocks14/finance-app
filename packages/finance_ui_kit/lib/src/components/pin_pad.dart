import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tokens/finance_colors.dart';
import '../tokens/layout_tokens.dart';

/// Dots that show how many PIN digits have been entered.
class PinDots extends StatelessWidget {
  const PinDots({
    super.key,
    required this.filled,
    required this.length,
    this.error = false,
  });

  final int filled;
  final int length;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      label: '$filled of $length digits entered',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < length; i++)
            AnimatedContainer(
              duration: Motion.fast,
              margin: const EdgeInsets.symmetric(horizontal: Space.s),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < filled
                    ? (error ? c.over : c.primary)
                    : Colors.transparent,
                border: Border.all(color: error ? c.over : c.outline, width: 2),
              ),
            ),
        ],
      ),
    );
  }
}

/// A large-key number pad for PIN entry, with optional biometric and
/// backspace keys. Never shows the digits.
class PinPad extends StatelessWidget {
  const PinPad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    this.onBiometric,
    this.enabled = true,
  });

  final ValueChanged<int> onDigit;
  final VoidCallback onBackspace;

  /// Shown as a fingerprint key in the bottom-left when not null.
  final VoidCallback? onBiometric;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    Widget key(Widget child, VoidCallback? onTap, String label) =>
        _PadKey(label: label, onTap: enabled ? onTap : null, child: child);
    final text = Theme.of(context).textTheme.headlineMedium;

    Widget digit(int d) => key(Text('$d', style: text), () {
      HapticFeedback.selectionClick();
      onDigit(d);
    }, '$d');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in const [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
        ])
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [for (final d in row) digit(d)],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (onBiometric != null)
              key(
                const Icon(Icons.fingerprint_rounded, size: 30),
                onBiometric,
                'Use fingerprint',
              )
            else
              const SizedBox(width: _PadKey.size + 2 * Space.m),
            digit(0),
            key(
              const Icon(Icons.backspace_outlined, size: 26),
              onBackspace,
              'Delete',
            ),
          ],
        ),
      ],
    );
  }
}

class _PadKey extends StatelessWidget {
  const _PadKey({
    required this.child,
    required this.onTap,
    required this.label,
  });

  static const double size = 72;

  final Widget child;
  final VoidCallback? onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Space.m,
        vertical: Space.s,
      ),
      child: Semantics(
        button: true,
        label: label,
        excludeSemantics: true,
        child: Material(
          color: context.colors.surfaceSoft,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox.square(
              dimension: size,
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
