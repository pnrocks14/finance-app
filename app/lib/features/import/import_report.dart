import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../common/widgets.dart';

/// What happened to every row: added, already there, or couldn't be read
/// (with the line number and why), plus balance and transfer notes.
class ImportReport extends StatelessWidget {
  const ImportReport({
    super.key,
    required this.outcome,
    required this.onDone,
    required this.onImportAnother,
    this.rowLabel = 'Line',
  });

  final ImportOutcome outcome;

  /// How rows are numbered in the file: lines in a CSV, entries in a PDF.
  final String rowLabel;
  final VoidCallback onDone;
  final VoidCallback onImportAnother;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    return ListView(
      padding: const EdgeInsets.all(Space.screen),
      children: [
        Row(
          children: [
            Expanded(
              child: StatTile(
                value: '${outcome.created}',
                label: 'added',
                tone: BudgetTone.good,
              ),
            ),
            const SizedBox(width: Space.s),
            Expanded(
              child: StatTile(
                value: '${outcome.duplicates}',
                label: 'already here',
              ),
            ),
            const SizedBox(width: Space.s),
            Expanded(
              child: StatTile(
                value: '${outcome.failed}',
                label: "couldn't read",
                tone: outcome.failed == 0 ? null : BudgetTone.over,
              ),
            ),
          ],
        ),
        if (outcome.matched > 0) ...[
          const SizedBox(height: Space.m),
          _Note(
            icon: Icons.link_rounded,
            color: c.primary,
            text:
                '${outcome.matched} payments were already here from another '
                'statement. They were joined up, not added twice.',
          ),
        ],
        if (outcome.transfersMarked > 0) ...[
          const SizedBox(height: Space.m),
          _Note(
            icon: Icons.swap_horiz_rounded,
            color: c.primary,
            text:
                '${outcome.transfersMarked} transactions are transfers between '
                "your own accounts, so they won't count as spending or income.",
          ),
        ],
        if (outcome.errors.isNotEmpty) ...[
          const SectionHeader("Rows we couldn't read"),
          Text(
            'These were skipped. If they look like real transactions, the '
            'format may need a fix.',
            style: theme.bodyMedium,
          ),
          const SizedBox(height: Space.s),
          for (final e in outcome.errors)
            _RowIssue(
              label: rowLabel,
              line: e.lineNumber,
              message: e.problem.message,
              excerpt: e.excerpt,
            ),
        ],
        if (outcome.balanceWarnings.isNotEmpty) ...[
          const SectionHeader("Balances that don't add up"),
          Text(
            'These rows were imported, but the running balance on the '
            "statement doesn't follow from the previous row. A row may be "
            'missing from the file.',
            style: theme.bodyMedium,
          ),
          const SizedBox(height: Space.s),
          for (final w in outcome.balanceWarnings)
            _RowIssue(
              label: rowLabel,
              line: w.lineNumber,
              message:
                  'Expected ${formatInr(w.expected)}, the statement says '
                  '${formatInr(w.actual)}',
            ),
        ],
        const SizedBox(height: Space.xl),
        PillButton(label: 'See transactions', expand: true, onPressed: onDone),
        const SizedBox(height: Space.s),
        PillButton(
          label: 'Import another file',
          kind: PillButtonKind.quiet,
          expand: true,
          onPressed: onImportAnother,
        ),
      ],
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.color, required this.text});

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) => AppCard(
    soft: true,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color),
        const SizedBox(width: Space.m),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    ),
  );
}

class _RowIssue extends StatelessWidget {
  const _RowIssue({
    required this.label,
    required this.line,
    required this.message,
    this.excerpt,
  });

  final String label;
  final int line;
  final String message;
  final String? excerpt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.s),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$label $line · $message', style: theme.titleMedium),
            if (excerpt != null) ...[
              const SizedBox(height: Space.xs),
              Text(excerpt!, style: theme.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}
