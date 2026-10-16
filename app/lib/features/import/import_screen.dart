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
import 'app_statement_preview.dart';
import 'column_mapper.dart';
import 'import_report.dart';
import 'pdf_text.dart';
import 'statement_file_picker.dart';

/// Statement import: pick the file, then the account it belongs to (bank
/// statements) or check which accounts its payments go to (PhonePe and
/// Google Pay statements), check the preview, import and read the report.
/// Nothing is saved before "Import".
class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

enum _Step {
  file,
  reading,
  account,
  mapColumns,
  preview,
  appPreview,
  importing,
  report,
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  _Step _step = _Step.file;
  Account? _account;
  String? _fileName;
  String? _text;
  List<List<String>> _table = const [];
  ImportPreview? _preview;
  AppImportPreview? _appPreview;
  ImportOutcome? _outcome;
  String? _error;

  static bool _isPdf(PickedStatement file) =>
      file.name.toLowerCase().endsWith('.pdf') ||
      file.bytes.length > 4 &&
          String.fromCharCodes(file.bytes.take(5)) == '%PDF-';

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
    _fileName = picked.name;
    if (_isPdf(picked)) {
      await _readPdf(picked);
      return;
    }
    final text = decodeStatementBytes(picked.bytes);
    _text = text;
    _table = parseCsv(text, delimiter: detectDelimiter(text));
    if (looksLikePhonePeCsv(_table)) {
      await _buildAppPreview(parsePhonePeCsv(text));
      return;
    }
    setState(() => _step = _Step.account);
  }

  Future<void> _readPdf(PickedStatement file) async {
    setState(() => _step = _Step.reading);
    String? text;
    String? error;
    try {
      text = await ref.read(pdfTextExtractorProvider).extract(file.bytes);
    } on PdfPasswordRequired {
      error =
          'That PDF is locked with a password. Password-protected '
          'statements are coming soon. For now, download a CSV instead.';
    } on Object {
      error = "That PDF couldn't be opened.";
    }
    if (text != null && !looksLikeGooglePayText(text)) {
      error =
          'Only Google Pay PDF statements can be read so far. For a bank '
          'statement, download it as CSV from net banking.';
    }
    if (error != null || text == null) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _step = _Step.file;
      });
      return;
    }
    await _buildAppPreview(parseGooglePayText(text));
  }

  Future<void> _buildAppPreview(AppStatementResult result) async {
    if (result.rows.isEmpty) {
      setState(() {
        _error = 'No payments were found in that file.';
        _step = _Step.file;
      });
      return;
    }
    final importer = await ref.read(appStatementImporterProvider.future);
    final preview = await importer.preview(result);
    if (!mounted) return;
    setState(() {
      _appPreview = preview;
      _step = _Step.appPreview;
    });
  }

  Future<void> _chooseAccount(Account account) async {
    _account = account;
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

  Future<void> _importApp(Map<String, String?> accounts) async {
    setState(() => _step = _Step.importing);
    final importer = await ref.read(appStatementImporterProvider.future);
    final result = _appPreview!.result;
    final outcome = await importer.import(
      result: result,
      accounts: accounts,
      kind: result.app == UpiApp.googlePay
          ? ImportKind.statementPdf
          : ImportKind.statementCsv,
    );
    if (!mounted) return;
    setState(() {
      _outcome = outcome;
      _step = _Step.report;
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
    _appPreview = null;
    _outcome = null;
    _text = null;
    _fileName = null;
    _error = null;
  });

  @override
  Widget build(BuildContext context) {
    final title = switch (_step) {
      _Step.file => 'Import a statement',
      _Step.reading => 'Reading the file',
      _Step.account => 'Which account?',
      _Step.mapColumns => 'Match the columns',
      _Step.preview || _Step.appPreview => 'Check before importing',
      _Step.importing => 'Importing',
      _Step.report => 'Import done',
    };
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: switch (_step) {
          _Step.file => _FileStep(error: _error, onPick: _pickFile),
          _Step.reading ||
          _Step.importing => const Center(child: CircularProgressIndicator()),
          _Step.account => _AccountStep(
            selected: _account,
            onSelect: _chooseAccount,
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
          _Step.appPreview => AppStatementPreview(
            fileName: _fileName!,
            preview: _appPreview!,
            onImport: _importApp,
            onCancel: _startOver,
          ),
          _Step.report => ImportReport(
            outcome: _outcome!,
            rowLabel: _appPreview?.result.app == UpiApp.googlePay
                ? 'Entry'
                : 'Line',
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
          Text(
            'Which account is this statement from?',
            style: theme.titleLarge,
          ),
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
  const _FileStep({required this.error, required this.onPick});

  final String? error;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    return ListView(
      padding: const EdgeInsets.all(Space.screen),
      children: [
        Text('Choose a statement', style: theme.titleLarge),
        const SizedBox(height: Space.s),
        Text('These work today:', style: theme.bodyMedium),
        const SizedBox(height: Space.s),
        const _Source(
          icon: Icons.account_balance_outlined,
          title: 'Bank statement (CSV)',
          detail:
              'In net banking, open your account statement, pick the dates '
              'and download it as CSV (sometimes called "delimited").',
        ),
        const _Source(
          icon: Icons.qr_code_rounded,
          title: 'Google Pay (PDF) or PhonePe (CSV)',
          detail:
              'From the app, request your transaction statement. It covers '
              'every bank account and card you pay from.',
        ),
        const SizedBox(height: Space.s),
        Text(
          'The file is read on this phone and never uploaded. Payments that '
          'show up in both a bank and an app statement are joined, not '
          'counted twice.',
          style: theme.bodySmall,
        ),
        const SizedBox(height: Space.xl),
        PillButton(
          label: 'Choose file',
          icon: Icons.upload_file_rounded,
          expand: true,
          onPressed: onPick,
        ),
        if (error != null) ...[
          const SizedBox(height: Space.m),
          Text(error!, style: theme.bodyMedium?.copyWith(color: c.over)),
        ],
      ],
    );
  }
}

class _Source extends StatelessWidget {
  const _Source({
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.s),
      child: AppCard(
        soft: true,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: context.colors.primary),
            const SizedBox(width: Space.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.titleMedium),
                  const SizedBox(height: Space.xs),
                  Text(detail, style: theme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
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
