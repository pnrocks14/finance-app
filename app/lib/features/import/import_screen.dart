import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/data_providers.dart';
import '../../common/format.dart';
import '../../common/widgets.dart';
import '../accounts/add_account_sheet.dart';
import 'column_mapper.dart';
import 'import_report.dart';
import 'statement_file_picker.dart';

/// Statement import: pick the account, pick the file, check the preview,
/// then import and read the report. Nothing is saved before "Import".
class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

enum _Step { account, file, mapColumns, preview, importing, report }

class _ImportScreenState extends ConsumerState<ImportScreen> {
  _Step _step = _Step.account;
  Account? _account;
  String? _fileName;
  String? _text;
  List<List<String>> _table = const [];
  ImportPreview? _preview;
  ImportOutcome? _outcome;
  String? _error;

  Future<void> _pickFile() async {
    setState(() => _error = null);
    final PickedStatement? picked;
    try {
      picked = await ref.read(statementFilePickerProvider).pick();
    } on FormatException catch (e) {
      setState(() => _error = e.message);
      return;
    }
    if (picked == null) return;
    final text = decodeStatementBytes(picked.bytes);
    _fileName = picked.name;
    _text = text;
    final delimiter = detectDelimiter(text);
    _table = parseCsv(text, delimiter: delimiter);
    final layout = detectLayout(_table);
    if (layout == null) {
      setState(() => _step = _Step.mapColumns);
      return;
    }
    await _buildPreview(layout);
  }

  Future<void> _buildPreview(DetectedLayout layout) async {
    final StatementParseResult result;
    try {
      result = parseStatement(_text!, layout: layout);
    } on FormatException {
      setState(() {
        _error = "That file doesn't look like a bank statement.";
        _step = _Step.file;
      });
      return;
    }
    final importer = await ref.read(statementImporterProvider.future);
    final preview = await importer.preview(
      accountId: _account!.id,
      result: result,
    );
    if (!mounted) return;
    setState(() {
      _preview = preview;
      _step = _Step.preview;
    });
  }

  Future<void> _import() async {
    setState(() => _step = _Step.importing);
    final importer = await ref.read(statementImporterProvider.future);
    final outcome = await importer.import(
      accountId: _account!.id,
      result: _preview!.result,
    );
    if (!mounted) return;
    setState(() {
      _outcome = outcome;
      _step = _Step.report;
    });
  }

  void _startOver() => setState(() {
    _step = _Step.file;
    _preview = null;
    _outcome = null;
    _text = null;
    _fileName = null;
    _error = null;
  });

  @override
  Widget build(BuildContext context) {
    final title = switch (_step) {
      _Step.account => 'Import a statement',
      _Step.file => 'Choose the file',
      _Step.mapColumns => 'Match the columns',
      _Step.preview => 'Check before importing',
      _Step.importing => 'Importing',
      _Step.report => 'Import done',
    };
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: switch (_step) {
          _Step.account => _AccountStep(
            selected: _account,
            onSelect: (a) => setState(() {
              _account = a;
              _step = _Step.file;
            }),
          ),
          _Step.file => _FileStep(
            account: _account!,
            error: _error,
            onPick: _pickFile,
            onChangeAccount: () => setState(() => _step = _Step.account),
          ),
          _Step.mapColumns => ColumnMapper(
            table: _table,
            onDone: _buildPreview,
            onCancel: _startOver,
          ),
          _Step.preview => _PreviewStep(
            account: _account!,
            fileName: _fileName!,
            preview: _preview!,
            onImport: _import,
            onCancel: _startOver,
          ),
          _Step.importing => const Center(child: CircularProgressIndicator()),
          _Step.report => ImportReport(
            outcome: _outcome!,
            onDone: () => context.go('/transactions'),
            onImportAnother: _startOver,
          ),
        },
      ),
    );
  }
}

class _AccountStep extends ConsumerWidget {
  const _AccountStep({required this.selected, required this.onSelect});

  final Account? selected;
  final ValueChanged<Account> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);
    final theme = Theme.of(context).textTheme;
    Future<void> add() async {
      final a = await showAddAccountSheet(context);
      if (a != null) onSelect(a);
    }

    return accounts.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) =>
          const Center(child: Text("Couldn't load your accounts.")),
      data: (list) => ListView(
        padding: const EdgeInsets.all(Space.screen),
        children: [
          Text('Which account is this statement for?', style: theme.titleLarge),
          const SizedBox(height: Space.l),
          if (list.isEmpty)
            EmptyState(
              title: 'Add your first account',
              message:
                  'Pick your bank and give it a name. Account numbers are '
                  'never needed.',
              actionLabel: 'Add an account',
              onAction: add,
            )
          else ...[
            for (final a in list)
              Padding(
                padding: const EdgeInsets.only(bottom: Space.s),
                child: AppCard(
                  onTap: () => onSelect(a),
                  child: Row(
                    children: [
                      Icon(
                        a.kind == AccountKind.creditCard
                            ? Icons.credit_card_rounded
                            : Icons.account_balance_outlined,
                        color: context.colors.primary,
                      ),
                      const SizedBox(width: Space.m),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.displayName, style: theme.titleMedium),
                            Text(
                              a.last4 == null
                                  ? a.institution
                                  : '${a.institution} · ••${a.last4}',
                              style: theme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: Space.s),
            PillButton(
              label: 'Add another account',
              kind: PillButtonKind.secondary,
              icon: Icons.add_rounded,
              onPressed: add,
            ),
          ],
        ],
      ),
    );
  }
}

class _FileStep extends StatelessWidget {
  const _FileStep({
    required this.account,
    required this.error,
    required this.onPick,
    required this.onChangeAccount,
  });

  final Account account;
  final String? error;
  final VoidCallback onPick;
  final VoidCallback onChangeAccount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    return ListView(
      padding: const EdgeInsets.all(Space.screen),
      children: [
        AppCard(
          soft: true,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Importing into ${account.displayName}',
                  style: theme.titleMedium,
                ),
              ),
              TextButton(
                onPressed: onChangeAccount,
                child: const Text('Change'),
              ),
            ],
          ),
        ),
        const SizedBox(height: Space.xl),
        Text('Download a CSV from your bank', style: theme.titleLarge),
        const SizedBox(height: Space.s),
        Text(
          'In net banking, open your account statement, pick the dates, and '
          'download it as CSV (sometimes called "delimited"). Then choose '
          'that file here. The file is read on this phone and never uploaded.',
          style: theme.bodyMedium,
        ),
        const SizedBox(height: Space.xl),
        PillButton(
          label: 'Choose CSV file',
          icon: Icons.upload_file_rounded,
          expand: true,
          onPressed: onPick,
        ),
        if (error != null) ...[
          const SizedBox(height: Space.m),
          Text(error!, style: theme.bodyMedium?.copyWith(color: c.over)),
        ],
        const SizedBox(height: Space.l),
        Text(
          'PDF and Excel statements are coming next.',
          style: theme.bodySmall,
        ),
      ],
    );
  }
}

class _PreviewStep extends StatelessWidget {
  const _PreviewStep({
    required this.account,
    required this.fileName,
    required this.preview,
    required this.onImport,
    required this.onCancel,
  });

  final Account account;
  final String fileName;
  final ImportPreview preview;
  final VoidCallback onImport;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final r = preview.result;
    final bank = r.layout.preset?.institution;
    final from = r.periodFrom;
    final to = r.periodTo;
    final sample = r.rows.take(3).toList();
    return ListView(
      padding: const EdgeInsets.all(Space.screen),
      children: [
        Text(fileName, style: theme.titleLarge),
        const SizedBox(height: Space.xs),
        Text(
          [
            if (bank != null) 'Looks like $bank' else 'Columns matched by you',
            if (from != null && to != null) formatPeriod(from, to),
          ].join(' · '),
          style: theme.bodyMedium,
        ),
        const SizedBox(height: Space.l),
        Row(
          children: [
            Expanded(
              child: StatTile(
                value: '${preview.newRows}',
                label: 'new',
                tone: BudgetTone.good,
              ),
            ),
            const SizedBox(width: Space.s),
            Expanded(
              child: StatTile(
                value: '${preview.alreadyImported}',
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
        if (sample.isNotEmpty) ...[
          const SectionHeader('First few rows'),
          AppCard(
            child: Column(
              children: [
                for (final row in sample)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: Space.xs),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                parseDescription(row.description)
                                        .counterpartyName ??
                                    row.description,
                                style: theme.bodyLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                formatShortDate(row.date),
                                style: theme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        SignedAmount(
                          amount: row.amount,
                          direction: row.direction,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
        if (r.balanceWarnings.isNotEmpty) ...[
          const SizedBox(height: Space.m),
          Text(
            "${r.balanceWarnings.length} row(s) don't add up with the running "
            "balance. They'll still be imported and flagged in the report.",
            style: theme.bodyMedium,
          ),
        ],
        const SizedBox(height: Space.xl),
        PillButton(
          label: preview.newRows == 0
              ? 'Nothing new to import'
              : 'Import ${preview.newRows} transactions',
          expand: true,
          onPressed: preview.newRows == 0 ? null : onImport,
        ),
        const SizedBox(height: Space.s),
        PillButton(
          label: 'Choose a different file',
          kind: PillButtonKind.quiet,
          expand: true,
          onPressed: onCancel,
        ),
      ],
    );
  }
}
