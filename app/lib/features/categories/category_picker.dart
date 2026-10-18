import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';

import 'category_visuals.dart';

/// What you picked: a category, and whether to use it for this payee from
/// now on.
typedef CategoryChoice = ({String categoryId, bool always});

/// A sheet listing every category, money out first for a debit and money
/// in first for a credit. [payee] names the switch that makes a rule; with
/// null, the change is a one-off.
Future<CategoryChoice?> showCategoryPicker(
  BuildContext context, {
  required List<Category> categories,
  required Direction direction,
  String? currentId,
  String? payee,
}) => showModalBottomSheet<CategoryChoice>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _CategoryPicker(
    categories: categories,
    direction: direction,
    currentId: currentId,
    payee: payee,
  ),
);

class _CategoryPicker extends StatefulWidget {
  const _CategoryPicker({
    required this.categories,
    required this.direction,
    this.currentId,
    this.payee,
  });

  final List<Category> categories;
  final Direction direction;
  final String? currentId;
  final String? payee;

  @override
  State<_CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<_CategoryPicker> {
  late var _always = widget.payee != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    List<Category> of(Set<SpendClass> classes) => [
      for (final c in widget.categories)
        if (classes.contains(c.spendClass)) c,
    ];
    final out = ('Money out', of({SpendClass.flexible, SpendClass.fixed}));
    final income = ('Money in', of({SpendClass.income}));
    final moves = ('Transfers and savings', of({SpendClass.transfer}));
    final groups = widget.direction == Direction.debit
        ? [out, moves, income]
        : [income, moves, out];

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (context, scroll) => ListView(
        controller: scroll,
        padding: const EdgeInsets.fromLTRB(
          Space.screen,
          0,
          Space.screen,
          Space.xl,
        ),
        children: [
          Text('Pick a category', style: theme.headlineSmall),
          if (widget.payee case final payee?)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _always,
              onChanged: (v) => setState(() => _always = v),
              title: Text('Always for $payee'),
              subtitle: const Text(
                'Makes a rule, and updates their other transactions that you '
                "haven't set by hand.",
              ),
            ),
          for (final (title, list) in groups)
            if (list.isNotEmpty) ...[
              SectionHeader(title),
              Wrap(
                spacing: Space.s,
                runSpacing: Space.s,
                children: [
                  for (final c in list)
                    ChoiceChip(
                      avatar: Icon(
                        categoryIcon(c),
                        size: 18,
                        color: context.colors.chartToken(c.colorToken),
                      ),
                      label: Text(c.name),
                      selected: c.id == widget.currentId,
                      onSelected: (_) =>
                          Navigator.of(context)
                              .pop((categoryId: c.id, always: _always)),
                    ),
                ],
              ),
            ],
        ],
      ),
    );
  }
}
