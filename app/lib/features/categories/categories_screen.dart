import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/data_providers.dart';
import '../../common/amount_sheet.dart';
import 'category_visuals.dart';

/// Which list the categories screen shows.
enum _Tab { spending, income, transfers }

/// Your categories for money out, money in and transfers. Add your own,
/// rename any, change their icon and colour, set a monthly budget, or
/// remove the ones you added.
class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  var _tab = _Tab.spending;

  bool _inTab(Category c) => switch (_tab) {
    _Tab.spending =>
      c.spendClass == SpendClass.fixed || c.spendClass == SpendClass.flexible,
    _Tab.income => c.spendClass == SpendClass.income,
    _Tab.transfers => c.spendClass == SpendClass.transfer,
  };

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(categoriesProvider).value ?? const <Category>[];
    final limits = ref.watch(budgetLimitsProvider).value ?? const {};
    final list = all.where(_inTab).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            tooltip: 'Your rules',
            icon: const Icon(Icons.rule_rounded),
            onPressed: () => context.push('/rules'),
          ),
        ],
      ),
      floatingActionButton: _tab == _Tab.transfers
          ? null
          : FloatingActionButton.extended(
              heroTag: 'add-category',
              onPressed: () =>
                  showCategoryEditor(context, income: _tab == _Tab.income),
              icon: const Icon(Icons.add_rounded),
              label: const Text('New category'),
            ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Space.screen,
          Space.s,
          Space.screen,
          96,
        ),
        children: [
          SegmentedButton<_Tab>(
            segments: const [
              ButtonSegment(value: _Tab.spending, label: Text('Money out')),
              ButtonSegment(value: _Tab.income, label: Text('Money in')),
              ButtonSegment(value: _Tab.transfers, label: Text('Transfers')),
            ],
            showSelectedIcon: false,
            selected: {_tab},
            onSelectionChanged: (s) => setState(() => _tab = s.first),
          ),
          const SizedBox(height: Space.m),
          if (_tab == _Tab.transfers)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.s),
              child: Text(
                "Transfers never count as spending or income, so they can't "
                'have a budget.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          for (final cat in list) _CategoryRow(cat, limit: limits[cat.id]),
        ],
      ),
    );
  }
}

class _CategoryRow extends ConsumerWidget {
  const _CategoryRow(this.category, {this.limit});

  final Category category;
  final Paise? limit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).textTheme;
    final cat = category;
    final spending =
        cat.spendClass == SpendClass.fixed ||
        cat.spendClass == SpendClass.flexible;
    final subtitle = [
      if (cat.spendClass == SpendClass.fixed) 'Fixed',
      if (cat.spendClass == SpendClass.flexible) 'Flexible',
      if (limit case final l?)
        'Budget ${formatInr(l, paise: PaiseDisplay.never)} a month',
      if (!cat.isSystem) 'Yours',
    ].join(' · ');

    Future<void> budget() async {
      final r = await showAmountSheet(
        context,
        title: 'Monthly budget for ${cat.name}',
        initial: limit,
        canRemove: limit != null,
      );
      if (r == null) return;
      final repo = await ref.read(budgetsRepositoryProvider.future);
      if (r.remove) {
        await repo.remove(cat.id);
      } else if (r.amount case final a?) {
        await repo.setLimit(cat.id, a);
      }
    }

    Future<void> delete() async {
      final ok = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Remove ${cat.name}?'),
          content: const Text(
            'Its transactions go back to needing a category, and its rules '
            'and budget go too.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Keep'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Remove'),
            ),
          ],
        ),
      );
      if (ok != true) return;
      final repo = await ref.read(categoriesRepositoryProvider.future);
      await repo.delete(cat.id);
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CategoryBadge(cat),
      title: Text(cat.name, style: theme.bodyLarge),
      subtitle: subtitle.isEmpty ? null : Text(subtitle),
      onTap: () => showCategoryEditor(context, editing: cat),
      trailing: PopupMenuButton<String>(
        tooltip: 'Options for ${cat.name}',
        onSelected: (v) => switch (v) {
          'edit' => showCategoryEditor(context, editing: cat),
          'budget' => budget(),
          'list' => context.push('/transactions?category=${cat.id}'),
          _ => delete(),
        },
        itemBuilder: (_) => [
          const PopupMenuItem(value: 'edit', child: Text('Edit')),
          if (spending)
            PopupMenuItem(
              value: 'budget',
              child: Text(limit == null ? 'Set a budget' : 'Change budget'),
            ),
          const PopupMenuItem(value: 'list', child: Text('See transactions')),
          if (!cat.isSystem)
            const PopupMenuItem(value: 'delete', child: Text('Remove')),
        ],
      ),
    );
  }
}

/// A sheet to add a category, or edit [editing]: name, fixed or flexible,
/// icon and colour.
Future<void> showCategoryEditor(
  BuildContext context, {
  Category? editing,
  bool income = false,
}) => showModalBottomSheet<void>(
  context: context,
  useRootNavigator: true,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _CategoryEditor(editing: editing, income: income),
);

class _CategoryEditor extends ConsumerStatefulWidget {
  const _CategoryEditor({this.editing, this.income = false});

  final Category? editing;
  final bool income;

  @override
  ConsumerState<_CategoryEditor> createState() => _CategoryEditorState();
}

class _CategoryEditorState extends ConsumerState<_CategoryEditor> {
  late final _name = TextEditingController(text: widget.editing?.name);
  late var _class =
      widget.editing?.spendClass ??
      (widget.income ? SpendClass.income : SpendClass.flexible);
  late var _icon = widget.editing?.icon ?? 'category';
  late var _color = widget.editing?.colorToken ?? 'chart3';
  var _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) return;
    setState(() => _saving = true);
    final repo = await ref.read(categoriesRepositoryProvider.future);
    if (widget.editing case final c?) {
      await repo.update(
        c.id,
        name: _name.text,
        icon: _icon,
        colorToken: _color,
        spendClass: _class == c.spendClass ? null : _class,
      );
    } else {
      await repo.create(
        name: _name.text,
        spendClass: _class,
        icon: _icon,
        colorToken: _color,
      );
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    final color = c.chartToken(_color);
    final editing = widget.editing;
    final spending =
        _class == SpendClass.fixed || _class == SpendClass.flexible;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Space.screen,
        0,
        Space.screen,
        Space.screen + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: color.withValues(alpha: 0.16),
                  child: Icon(iconNamed(_icon), color: color),
                ),
                const SizedBox(width: Space.m),
                Text(
                  editing == null ? 'New category' : 'Edit category',
                  style: theme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: Space.l),
            TextField(
              controller: _name,
              autofocus: editing == null,
              decoration: const InputDecoration(labelText: 'Name'),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) => setState(() {}),
            ),
            if (editing == null || spending) ...[
              const SizedBox(height: Space.l),
              Wrap(
                spacing: Space.s,
                runSpacing: Space.s,
                children: [
                  for (final (k, label) in [
                    (SpendClass.flexible, 'Flexible spending'),
                    (SpendClass.fixed, 'Fixed spending'),
                    if (editing == null) (SpendClass.income, 'Money in'),
                  ])
                    ChoiceChip(
                      label: Text(label),
                      selected: _class == k,
                      showCheckmark: false,
                      onSelected: (_) => setState(() => _class = k),
                    ),
                ],
              ),
              if (spending)
                Padding(
                  padding: const EdgeInsets.only(top: Space.xs),
                  child: Text(
                    _class == SpendClass.fixed
                        ? 'Fixed: about the same each month, like rent or EMIs.'
                        : 'Flexible: you choose how much, like eating out.',
                    style: theme.bodySmall,
                  ),
                ),
            ],
            const SectionHeader('Colour'),
            Wrap(
              spacing: Space.s,
              runSpacing: Space.s,
              children: [
                for (final t in categoryColorTokens)
                  Semantics(
                    label: 'Colour ${t.substring(5)}',
                    selected: t == _color,
                    button: true,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => setState(() => _color = t),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: c.chartToken(t),
                        child: t == _color
                            ? Icon(Icons.check_rounded, color: c.onPrimary)
                            : null,
                      ),
                    ),
                  ),
              ],
            ),
            const SectionHeader('Icon'),
            Wrap(
              spacing: Space.xs,
              runSpacing: Space.xs,
              children: [
                for (final name in categoryIconNames)
                  IconButton(
                    tooltip: name.replaceAll('_', ' '),
                    isSelected: name == _icon,
                    style: IconButton.styleFrom(
                      backgroundColor: name == _icon
                          ? color.withValues(alpha: 0.16)
                          : null,
                    ),
                    icon: Icon(
                      iconNamed(name),
                      color: name == _icon ? color : c.textSecondary,
                    ),
                    onPressed: () => setState(() => _icon = name),
                  ),
              ],
            ),
            const SizedBox(height: Space.xl),
            PillButton(
              label: editing == null ? 'Add category' : 'Save',
              expand: true,
              onPressed: _name.text.trim().isEmpty || _saving ? null : _save,
            ),
          ],
        ),
      ),
    );
  }
}
