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
    required this.onCancel,
    this.error,
  });

  final String fileName;
  final String? error;
  final void Function(String password, bool remember) onUnlock;
  final VoidCallback onCancel;

  @override
  State<PdfPasswordStep> createState() => _PdfPasswordStepState();
}

class _PdfPasswordStepState extends State<PdfPasswordStep> {
  final _controller = TextEditingController();
  var _remember = true;
  var _obscure = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final p = _controller.text;
    if (p.isEmpty) return;
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
