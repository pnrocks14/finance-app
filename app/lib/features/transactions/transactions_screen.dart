import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/data_providers.dart';
import '../../common/format.dart';
import '../../common/widgets.dart';

/// Every transaction, newest first, grouped by day. Tap one to see where it
/// came from and why it counts the way it does.
class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txs = ref.watch(transactionsProvider);
    final accounts = ref.watch(accountsProvider).value ?? const [];
    final names = {for (final a in accounts) a.id: a.displayName};
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            tooltip: 'Import a statement',
            icon: const Icon(Icons.upload_file_rounded),
            onPressed: () => context.push('/import'),
          ),
        ],
      ),
      body: txs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) =>
            const Center(child: Text("Couldn't load your transactions.")),
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: EmptyState(
                title: 'No transactions yet',
                message: 'Import a bank statement and they will show up here.',
                actionLabel: 'Import a statement',
                onAction: () => context.push('/import'),
              ),
            );
          }
          final items = <Object>[];
          LocalDate? day;
          for (final t in list) {
            if (t.localDate != day) {
              day = t.localDate;
              items.add(day);
            }
            items.add(t);
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              Space.screen,
              0,
              Space.screen,
              Space.xxxl,
            ),
            itemCount: items.length,
            itemBuilder: (context, i) => switch (items[i]) {
              final LocalDate d => Padding(
                padding: const EdgeInsets.only(top: Space.l, bottom: Space.xs),
                child: Text(
                  formatDayHeader(d),
                  style: theme.labelLarge?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
              final Transaction t => TransactionTile(
                transaction: t,
                accountName: names[t.accountId],
              ),
              _ => const SizedBox.shrink(),
            },
          );
        },
      ),
    );
  }
}

/// One row of the list: icon, payee, channel and account, signed amount.
class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.transaction,
    this.accountName,
  });

  final Transaction transaction;
  final String? accountName;

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final c = context.colors;
    final theme = Theme.of(context).textTheme;
    final transfer = t.flow == TransactionFlow.transfer;
    final subtitle = [
      channelLabel(t.channel),
      if (transfer)
        'Transfer'
      else if (t.flow == TransactionFlow.refund)
        'Refund',
      ?accountName,
    ].join(' · ');
    return InkWell(
      borderRadius: BorderRadius.circular(Radii.chip),
      onTap: () => showTransactionDetail(context, t, accountName),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.s),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: c.surfaceSoft,
              child: Icon(_iconFor(t), color: c.primary, size: 20),
            ),
            const SizedBox(width: Space.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName(t),
                    style: theme.bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(subtitle, style: theme.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: Space.s),
            SignedAmount(
              amount: Paise(t.amountPaise),
              direction: t.direction,
              muted: transfer,
            ),
          ],
        ),
      ),
    );
  }
}

/// The payee in title case, or the raw description when none was found.
String displayName(Transaction t) {
  final name = t.counterpartyName;
  if (name == null || name.isEmpty) return t.descriptionRaw ?? 'Transaction';
  if (name != name.toUpperCase()) return name;
  return name
      .toLowerCase()
      .split(' ')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');
}

IconData _iconFor(Transaction t) {
  if (t.flow == TransactionFlow.transfer) return Icons.swap_horiz_rounded;
  return switch (t.channel) {
    Channel.upi => Icons.qr_code_2_rounded,
    Channel.card => Icons.credit_card_rounded,
    Channel.atm => Icons.local_atm_rounded,
    Channel.neft ||
    Channel.imps ||
    Channel.rtgs => Icons.account_balance_outlined,
    Channel.netBanking => Icons.language_rounded,
    Channel.wallet => Icons.account_balance_wallet_outlined,
    Channel.cheque => Icons.receipt_long_outlined,
    Channel.other => Icons.circle_outlined,
  };
}

/// "See why": the raw description, what was read from it, and why the
/// transaction counts as spend, income, refund or transfer.
Future<void> showTransactionDetail(
  BuildContext context,
  Transaction t,
  String? accountName,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (context) {
    final theme = Theme.of(context).textTheme;
    final flowLabel = switch (t.flow) {
      TransactionFlow.spend => 'Spending',
      TransactionFlow.income => 'Income',
      TransactionFlow.refund => 'Refund',
      TransactionFlow.transfer => 'Transfer',
    };
    final facts = <(String, String)>[
      ('Date', formatShortDate(t.localDate)),
      if (accountName != null) ('Account', accountName),
      ('Paid by', channelLabel(t.channel)),
      if (t.vpa != null) ('UPI ID', t.vpa!),
      if (t.upiRef != null) ('UPI ref', t.upiRef!),
      if (t.bankRef != null) ('Bank ref', t.bankRef!),
      if (t.cardLast4 != null) ('Card', '••${t.cardLast4}'),
    ];
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (context, scroll) => ListView(
        controller: scroll,
        padding: const EdgeInsets.fromLTRB(
          Space.screen,
          0,
          Space.screen,
          Space.xl,
        ),
        children: [
          Text(displayName(t), style: theme.headlineMedium),
          const SizedBox(height: Space.xs),
          SignedAmount(amount: Paise(t.amountPaise), direction: t.direction),
          const SectionHeader('Why it counts this way'),
          AppCard(
            soft: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(flowLabel, style: theme.titleMedium),
                const SizedBox(height: Space.xs),
                Text(flowReasonText(t.flowReason), style: theme.bodyMedium),
              ],
            ),
          ),
          const SectionHeader('What we read'),
          for (final (k, v) in facts)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Space.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 96, child: Text(k, style: theme.bodySmall)),
                  Expanded(child: Text(v, style: theme.bodyMedium)),
                ],
              ),
            ),
          if (t.descriptionRaw != null) ...[
            const SectionHeader('From your statement'),
            SelectableText(t.descriptionRaw!, style: theme.bodySmall),
          ],
        ],
      ),
    );
  },
);
