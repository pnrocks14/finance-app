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
            AlwaysForSwitch(
              payee: payee,
              value: _always,
              onChanged: (v) => setState(() => _always = v),
            ),
          CategoryGroups(
            categories: widget.categories,
            direction: widget.direction,
            currentId: widget.currentId,
            onPick: (id) =>
                Navigator.of(context).pop((categoryId: id, always: _always)),
          ),
        ],
      ),
    );
  }
}

/// "Always for (payee)": makes a rule when on.
class AlwaysForSwitch extends StatelessWidget {
  const AlwaysForSwitch({
    super.key,
    required this.payee,
    required this.value,
    required this.onChanged,
  });

  final String payee;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => SwitchListTile(
    contentPadding: EdgeInsets.zero,
    value: value,
    onChanged: onChanged,
    title: Text('Always for $payee'),
    subtitle: const Text(
      'Makes a rule, and updates their other transactions that you '
      "haven't set by hand.",
    ),
  );
}

/// Every category as chips, grouped: money out first for a debit and money
/// in first for a credit.
class CategoryGroups extends StatelessWidget {
  const CategoryGroups({
    super.key,
    required this.categories,
    required this.direction,
    required this.onPick,
    this.currentId,
  });

  final List<Category> categories;
  final Direction direction;
  final String? currentId;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    List<Category> of(Set<SpendClass> classes) => [
      for (final c in categories)
        if (classes.contains(c.spendClass)) c,
    ];
    final out = ('Money out', of({SpendClass.flexible, SpendClass.fixed}));
    final income = ('Money in', of({SpendClass.income}));
    final moves = ('Transfers and savings', of({SpendClass.transfer}));
    final groups = direction == Direction.debit
        ? [out, moves, income]
        : [income, moves, out];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                    selected: c.id == currentId,
                    onSelected: (_) => onPick(c.id),
                  ),
              ],
            ),
          ],
      ],
    );
  }
}
