import 'package:flutter/material.dart';

import '../tokens/finance_colors.dart';
import '../tokens/layout_tokens.dart';

/// A rounded card on the surface colour. The basic container for content.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Space.l),
    this.onTap,
    this.soft = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  /// Uses the softer sand surface, for grouped or secondary content.
  final bool soft;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: soft ? c.surfaceSoft : c.surface,
      borderRadius: BorderRadius.circular(Radii.card),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

enum PillButtonKind { primary, secondary, quiet }

/// The app's button: pill-shaped, at least 48 dp tall.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.kind = PillButtonKind.primary,
    this.icon,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final PillButtonKind kind;
  final IconData? icon;

  /// Stretch to the available width.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final child = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: Space.s),
              Text(label),
            ],
          );
    final button = switch (kind) {
      PillButtonKind.primary => FilledButton(
        onPressed: onPressed,
        child: child,
      ),
      PillButtonKind.secondary => OutlinedButton(
        onPressed: onPressed,
        child: child,
      ),
      PillButtonKind.quiet => TextButton(onPressed: onPressed, child: child),
    };
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// A category label with its colour dot, e.g. in transaction rows.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.onTap,
    this.selected = false,
  });

  final String label;
  final Color color;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme.labelMedium;
    return Semantics(
      button: onTap != null,
      selected: selected,
      child: Material(
        color: selected ? color.withValues(alpha: 0.18) : c.surfaceSoft,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.pill),
          side: BorderSide(
            color: selected ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 36),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Space.m,
                vertical: Space.s,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null)
                    Icon(icon, size: 16, color: color)
                  else
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  const SizedBox(width: Space.s),
                  Text(label, style: text),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A section title with an optional action on the right.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Space.xl, bottom: Space.m),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
          ?action,
        ],
      ),
    );
  }
}
