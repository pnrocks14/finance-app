import 'package:finance_core/finance_core.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';

import 'statement_password_hints.dart';

/// Asks for a locked statement's password, with each bank's usual rule as
/// a hint. The password is used on this phone only, and kept in secure
/// storage only if you tick "Remember".
class PdfPasswordStep extends StatefulWidget {
  const PdfPasswordStep({
    super.key,
    required this.fileName,
    required this.onUnlock,
    required this.onTryDetails,
    required this.onCancel,
    this.error,
    this.detailsError,
    this.busy = false,
  });

  final String fileName;
  final String? error;

  /// Why "Try my details" didn't open it.
  final String? detailsError;

  /// Trying passwords; the buttons wait.
  final bool busy;
  final void Function(String password, bool remember) onUnlock;

  /// Tries every known bank rule built from your details.
  final void Function(PasswordDetails details, bool remember) onTryDetails;
  final VoidCallback onCancel;

  @override
  State<PdfPasswordStep> createState() => _PdfPasswordStepState();
}

class _PdfPasswordStepState extends State<PdfPasswordStep> {
  final _controller = TextEditingController();
  final _name = TextEditingController();
  final _dob = TextEditingController();
  final _mobile = TextEditingController();
  final _customerId = TextEditingController();
  final _account = TextEditingController();
  final _card = TextEditingController();
  var _remember = true;
  var _obscure = true;

  @override
  void dispose() {
    for (final c in [
      _controller,
      _name,
      _dob,
      _mobile,
      _customerId,
      _account,
      _card,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _text(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  void _tryDetails() {
    if (widget.busy) return;
    widget.onTryDetails(
      PasswordDetails(
        name: _text(_name),
        dateOfBirth: parseStatementDate(_dob.text),
        mobile: _text(_mobile),
        customerId: _text(_customerId),
        accountNumber: _text(_account),
        cardLast4: _text(_card),
      ),
      _remember,
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    TextInputType? keyboard,
    String? hint,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: Space.s),
    child: TextField(
      controller: c,
      keyboardType: keyboard,
      autocorrect: false,
      enableSuggestions: false,
      decoration: InputDecoration(labelText: label, hintText: hint),
    ),
  );

  void _submit() {
    final p = _controller.text;
    if (p.isEmpty || widget.busy) return;
    widget.onUnlock(p, _remember);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    return ListView(
      padding: const EdgeInsets.all(Space.screen),
      children: [
        Text(widget.fileName, style: theme.titleLarge),
        const SizedBox(height: Space.xs),
        Text(
          'This statement is locked. Banks usually build the password from '
          'your name, date of birth, mobile number or customer ID.',
          style: theme.bodyMedium,
        ),
        const SizedBox(height: Space.l),
        TextField(
          controller: _controller,
          obscureText: _obscure,
          autocorrect: false,
          enableSuggestions: false,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
          decoration: InputDecoration(
            labelText: 'PDF password',
            errorText: widget.error,
            suffixIcon: IconButton(
              tooltip: _obscure ? 'Show password' : 'Hide password',
              icon: Icon(
                _obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
        ),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: _remember,
          onChanged: (v) => setState(() => _remember = v ?? false),
          title: const Text('Remember on this phone'),
          subtitle: const Text(
            "Kept in secure storage and tried first next month, so you won't "
            'be asked again.',
          ),
        ),
        const SizedBox(height: Space.m),
        PillButton(
          label: 'Unlock',
          icon: Icons.lock_open_rounded,
          expand: true,
          onPressed: _submit,
        ),
        const SizedBox(height: Space.s),
        PillButton(
          label: 'Choose a different file',
          kind: PillButtonKind.quiet,
          expand: true,
          onPressed: widget.onCancel,
        ),
        const SectionHeader("Don't know it?"),
        Text(
          'Fill in what you know and the app tries every rule banks use. '
          'These details are only used now, on this phone, and never saved.',
          style: theme.bodySmall,
        ),
        const SizedBox(height: Space.s),
        _field(_name, 'Name as on the account'),
        _field(
          _dob,
          'Date of birth',
          hint: 'DD/MM/YYYY',
          keyboard: TextInputType.datetime,
        ),
        _field(_mobile, 'Registered mobile', keyboard: TextInputType.phone),
        _field(_customerId, 'Customer ID / CRN'),
        _field(_account, 'Account number', keyboard: TextInputType.number),
        _field(_card, 'Card last 4 digits', keyboard: TextInputType.number),
        PillButton(
          label: 'Try my details',
          kind: PillButtonKind.secondary,
          icon: Icons.key_rounded,
          expand: true,
          onPressed: _tryDetails,
        ),
        if (widget.busy)
          const Padding(
            padding: EdgeInsets.only(top: Space.s),
            child: LinearProgressIndicator(),
          ),
        if (widget.detailsError case final e?)
          Padding(
            padding: const EdgeInsets.only(top: Space.s),
            child: Text(
              e,
              style: theme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        const SectionHeader('Usual passwords'),
        Text(
          'These are the rules banks publish. Check the email the statement '
          'came with if none fits.',
          style: theme.bodySmall,
        ),
        const SizedBox(height: Space.s),
        for (final h in statementPasswordHints)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.s),
            child: AppCard(
              soft: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(h.source, style: theme.titleSmall),
                  const SizedBox(height: Space.xs),
                  Text(h.rule, style: theme.bodySmall),
                  if (h.example != null) ...[
                    const SizedBox(height: Space.xs),
                    Text(
                      'e.g. ${h.example}',
                      style: theme.bodySmall?.copyWith(color: c.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}
