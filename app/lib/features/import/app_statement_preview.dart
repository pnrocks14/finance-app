import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/data_providers.dart';
import '../../common/format.dart';
import '../../common/widgets.dart';

/// Preview of a PhonePe or Google Pay statement. One statement covers
/// several accounts and cards, so this shows each one with the account its
/// payments will go to, and lets you change it before importing.
class AppStatementPreview extends ConsumerStatefulWidget {
  const AppStatementPreview({
    super.key,
    required this.fileName,
    required this.preview,
    required this.onImport,
    required this.onCancel,
  });

  final String fileName;
  final AppImportPreview preview;

  /// Called with instrument key → account id (null adds a new account).
  final ValueChanged<Map<String, String?>> onImport;
  final VoidCallback onCancel;

  @override
  ConsumerState<AppStatementPreview> createState() =>
      _AppStatementPreviewState();
}

class _AppStatementPreviewState extends ConsumerState<AppStatementPreview> {
  late final Map<String, String?> _choice = {
    for (final i in widget.preview.instruments) i.key: i.account?.id,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    final p = widget.preview;
    final r = p.result;
    final from = r.periodFrom;
    final to = r.periodTo;
    final accounts = ref.watch(accountsProvider).value ?? const <Account>[];
    final totals = r.totalsMatch;
    return ListView(
      padding: const EdgeInsets.all(Space.screen),
      children: [
        Text(widget.fileName, style: theme.titleLarge),
        const SizedBox(height: Space.xs),
        Text(
          [
            '${r.app.label} statement',
            if (from != null && to != null) formatPeriod(from, to),
          ].join(' · '),
          style: theme.bodyMedium,
        ),
        const SizedBox(height: Space.l),
        Row(
          children: [
            Expanded(
              child: StatTile(
                value: '${p.newRows}',
                label: 'new',
                tone: BudgetTone.good,
              ),
            ),
            const SizedBox(width: Space.s),
            Expanded(
              child: StatTile(
                value: '${p.alreadyImported}',
                label: 'already here',
              ),
            ),
            const SizedBox(width: Space.s),
            Expanded(
              child: StatTile(
                value: '${r.errors.length}',
                label: "can't read",
                tone: r.errors.isEmpty ? null : BudgetTone.over,
              ),
            ),
          ],
        ),
        if (p.matchesBankRows > 0) ...[
          const SizedBox(height: Space.m),
          Text(
            '${p.matchesBankRows} of these are already here from a bank '
            "statement. They'll be joined up, with the app's payee names, "
            'not added twice.',
            style: theme.bodyMedium,
          ),
        ],
        if (totals != null) ...[
          const SizedBox(height: Space.s),
          Row(
            children: [
              Icon(
                totals ? Icons.check_circle_rounded : Icons.error_rounded,
                size: 18,
                color: totals ? c.good : c.over,
              ),
              const SizedBox(width: Space.xs),
              Expanded(
                child: Text(
                  totals
                      ? 'Adds up to the totals on the statement.'
                      : "Doesn't add up to the totals on the statement. "
                            'Some entries may not have been read.',
                  style: theme.bodySmall,
                ),
              ),
            ],
          ),
        ],
        const SectionHeader('Where the payments go'),
        for (final i in p.instruments)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.s),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        i.instrument?.kind == AccountKind.creditCard
                            ? Icons.credit_card_rounded
                            : Icons.account_balance_outlined,
                        color: c.primary,
                      ),
                      const SizedBox(width: Space.m),
                      Expanded(
                        child: Text(
                          i.instrument?.label ?? 'No account shown',
                          style: theme.titleMedium,
                        ),
                      ),
                      Text('${i.rows}', style: theme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: Space.xs),
                  DropdownButton<String?>(
                    isExpanded: true,
                    // Accounts can still be loading on the first frame.
                    value: accounts.any((a) => a.id == _choice[i.key])
                        ? _choice[i.key]
                        : null,
                    underline: const SizedBox.shrink(),
                    items: [
                      DropdownMenuItem<String?>(
                        child: Text(
                          i.instrument == null
                              ? 'No account'
                              : 'Add as a new account',
                        ),
                      ),
                      for (final a in accounts)
                        DropdownMenuItem<String?>(
                          value: a.id,
                          child: Text(
                            a.last4 == null
                                ? a.displayName
                                : '${a.displayName} · ••${a.last4}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (id) => setState(() => _choice[i.key] = id),
                  ),
                ],
              ),
            ),
          ),
        if (r.rows.any((x) => x.isSelfTransfer)) ...[
          Text(
            'Self transfers between your accounts are marked as transfers, '
            'not spending.',
            style: theme.bodySmall,
          ),
        ],
        const SizedBox(height: Space.xl),
        PillButton(
          label: p.newRows == 0
              ? 'Nothing new to import'
              : 'Import ${p.newRows} payments',
          expand: true,
          onPressed: p.newRows == 0 ? null : () => widget.onImport(_choice),
        ),
        const SizedBox(height: Space.s),
        PillButton(
          label: 'Choose a different file',
          kind: PillButtonKind.quiet,
          expand: true,
          onPressed: widget.onCancel,
        ),
      ],
    );
  }
}
