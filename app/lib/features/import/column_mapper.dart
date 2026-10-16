import 'package:finance_core/finance_core.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';

/// For a bank without a preset: tap the header row, then say which column
/// holds what. The mapping applies to this file only.
class ColumnMapper extends StatefulWidget {
  const ColumnMapper({
    super.key,
    required this.table,
    required this.onDone,
    required this.onCancel,
  });

  final List<List<String>> table;
  final ValueChanged<DetectedLayout> onDone;
  final VoidCallback onCancel;

  @override
  State<ColumnMapper> createState() => _ColumnMapperState();
}

const _fields = [
  (StatementField.date, 'Date', true),
  (StatementField.description, 'Description', true),
  (StatementField.debit, 'Money out (debit)', false),
  (StatementField.credit, 'Money in (credit)', false),
  (StatementField.amount, 'Single amount column', false),
  (StatementField.drCr, 'Dr / Cr column', false),
  (StatementField.balance, 'Balance', false),
];

class _ColumnMapperState extends State<ColumnMapper> {
  int? _headerRow;
  final Map<StatementField, int> _map = {};

  List<(int, List<String>)> get _candidates => [
    for (var i = 0; i < widget.table.length && i < 40; i++)
      if (widget.table[i].where((c) => c.trim().isNotEmpty).length >= 2)
        (i, widget.table[i]),
  ].take(15).toList();

  void _chooseHeader(int row) {
    final headers = widget.table[row];
    final guess = detectLayout([headers]);
    setState(() {
      _headerRow = row;
      _map
        ..clear()
        ..addAll(guess?.columns.columns ?? const {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    final header = _headerRow;
    if (header == null) {
      return ListView(
        padding: const EdgeInsets.all(Space.screen),
        children: [
          Text(
            "We don't know this bank's layout yet. Tap the row that has the "
            'column names.',
            style: theme.bodyLarge,
          ),
          const SizedBox(height: Space.l),
          for (final (i, cells) in _candidates)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.s),
              child: AppCard(
                onTap: () => _chooseHeader(i),
                child: Text(
                  cells.where((c) => c.trim().isNotEmpty).join('  ·  '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.bodyMedium,
                ),
              ),
            ),
          PillButton(
            label: 'Choose a different file',
            kind: PillButtonKind.quiet,
            expand: true,
            onPressed: widget.onCancel,
          ),
        ],
      );
    }

    final headers = widget.table[header];
    final map = ColumnMap(Map.of(_map));
    return ListView(
      padding: const EdgeInsets.all(Space.screen),
      children: [
        Text('Which column holds what?', style: theme.titleLarge),
        const SizedBox(height: Space.xs),
        Text(
          'Date and description are needed, plus either money out and in, '
          'or a single amount column.',
          style: theme.bodyMedium,
        ),
        const SizedBox(height: Space.l),
        for (final (field, label, required) in _fields)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.m),
            child: DropdownButtonFormField<int?>(
              initialValue: _map[field],
              isExpanded: true,
              decoration: InputDecoration(
                labelText: required ? '$label *' : label,
              ),
              items: [
                const DropdownMenuItem<int?>(child: Text('Not in this file')),
                for (var i = 0; i < headers.length; i++)
                  if (headers[i].trim().isNotEmpty)
                    DropdownMenuItem<int?>(
                      value: i,
                      child: Text(
                        headers[i].trim(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
              ],
              onChanged: (v) => setState(() {
                if (v == null) {
                  _map.remove(field);
                } else {
                  _map[field] = v;
                }
              }),
            ),
          ),
        if (!map.isComplete)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.m),
            child: Text(
              'Pick the date, the description and at least one amount column.',
              style: theme.bodyMedium?.copyWith(color: c.caution),
            ),
          ),
        PillButton(
          label: 'Use these columns',
          expand: true,
          onPressed: map.isComplete
              ? () => widget.onDone(
                  DetectedLayout(
                    headerRow: header,
                    headers: headers,
                    columns: map,
                  ),
                )
              : null,
        ),
        const SizedBox(height: Space.s),
        PillButton(
          label: 'Pick a different header row',
          kind: PillButtonKind.quiet,
          expand: true,
          onPressed: () => setState(() => _headerRow = null),
        ),
      ],
    );
  }
}
