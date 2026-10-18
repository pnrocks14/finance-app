import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/data_providers.dart';
import '../../common/format.dart';
import '../../common/widgets.dart';
import '../categories/category_picker.dart';
import '../categories/category_visuals.dart';

/// Every transaction, newest first, grouped by day, with filters for the
/// month, account, category, money in or out, and a search. Tap one to see
/// where it came from, why it counts the way it does, and to change its
/// category.
class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({
    super.key,
    this.initial = const TransactionFilter(),
    this.title = 'Transactions',
  });

  /// The filter to open with, e.g. from a tap on the home donut.
  final TransactionFilter initial;
  final String title;

  /// Reads `month=2026-10`, `from=2026-10-01`, `to=2026-10-07`,
  /// `category=<id>`, `account=<id>`, `needs=1`, `direction=debit|credit`
  /// and `q=<text>` from a route.
  static TransactionFilter filterFrom(Map<String, String> q) {
    LocalDate? month;
    final m = RegExp(r'^(\d{4})-(\d{2})$').firstMatch(q['month'] ?? '');
    if (m != null) {
      month = LocalDate(int.parse(m[1]!), int.parse(m[2]!), 1);
    }
    LocalDate? day(String? s) {
      if (s == null) return null;
      try {
        return LocalDate.parse(s);
      } on FormatException {
        return null;
      }
    }

    return TransactionFilter(
      month: month,
      from: day(q['from']),
      to: day(q['to']),
      accountId: q['account'],
      categoryId: q['category'],
      needsCategory: q['needs'] == '1',
      direction: switch (q['direction']) {
        'debit' => Direction.debit,
        'credit' => Direction.credit,
        _ => null,
      },
      search: q['q'],
    );
  }

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

/// Stands for "Pick dates…" in the month sheet.
final _customDates = LocalDate(1, 1, 1);

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  late var _filter = widget.initial;
  late final _search = TextEditingController(text: widget.initial.search);

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _set(TransactionFilter f) => setState(() => _filter = f);

  /// A sheet listing [options]; returns the picked value wrapped, so "Any"
  /// (null) can be told apart from a dismissed sheet.
  Future<(T?,)?> _pick<T>(
    String title,
    List<(T?, String)> options,
    T? now,
  ) => showModalBottomSheet<(T?,)>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scroll) => ListView(
        controller: scroll,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.screen),
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          for (final (value, label) in options)
            ListTile(
              title: Text(label),
              trailing: value == now ? const Icon(Icons.check_rounded) : null,
              onTap: () => Navigator.of(context).pop((value,)),
            ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final txs = ref.watch(filteredTransactionsProvider(_filter));
    final accounts = ref.watch(accountsProvider).value ?? const [];
    final names = {for (final a in accounts) a.id: a.displayName};
    final categoryList =
        ref.watch(categoriesProvider).value ?? const <Category>[];
    final categories = {for (final c in categoryList) c.id: c};
    final months = ref.watch(monthsProvider).value ?? const <LocalDate>[];
    final theme = Theme.of(context).textTheme;
    final f = _filter;

    final chips = <Widget>[
      _FilterChip(
        label: f.from != null || f.to != null
            ? (f.from == f.to
                  ? formatShortDate(f.from!)
                  : formatPeriod(f.from ?? f.to!, f.to ?? f.from!))
            : f.month == null
            ? 'All months'
            : formatMonth(f.month!),
        active: f.month != null || f.from != null || f.to != null,
        onTap: () async {
          final r = await _pick<LocalDate>('Dates', [
            (null, 'All months'),
            (_customDates, 'Pick dates…'),
            for (final m in months) (m, formatMonth(m)),
          ], f.from != null || f.to != null ? _customDates : f.month);
          if (r == null || !context.mounted) return;
          if (r.$1 != _customDates) {
            _set(
              f.copyWith(month: () => r.$1, from: () => null, to: () => null),
            );
            return;
          }
          final today = DateTime.now();
          final start = f.from ?? f.month;
          final range = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2000),
            lastDate: DateTime(today.year + 1, 12, 31),
            initialDateRange: start == null
                ? null
                : DateTimeRange(
                    start: DateTime(start.year, start.month, start.day),
                    end: switch (f.to) {
                      final t? => DateTime(t.year, t.month, t.day),
                      null => DateTime(
                        start.year,
                        start.month,
                        f.month == null ? start.day : start.daysInMonth,
                      ),
                    },
                  ),
          );
          if (range == null) return;
          LocalDate day(DateTime d) => LocalDate(d.year, d.month, d.day);
          _set(
            _filter.copyWith(
              month: () => null,
              from: () => day(range.start),
              to: () => day(range.end),
            ),
          );
        },
      ),
      _FilterChip(
        label: switch (f.direction) {
          null => 'In and out',
          Direction.debit => 'Money out',
          Direction.credit => 'Money in',
        },
        active: f.direction != null,
        onTap: () async {
          final r = await _pick<Direction>('Money', [
            (null, 'In and out'),
            (Direction.debit, 'Money out'),
            (Direction.credit, 'Money in'),
          ], f.direction);
          if (r != null) _set(f.copyWith(direction: () => r.$1));
        },
      ),
      _FilterChip(
        label: categories[f.categoryId]?.name ?? 'Any category',
        active: f.categoryId != null,
        onTap: () async {
          final r = await _pick<String>('Category', [
            (null, 'Any category'),
            for (final c in categoryList) (c.id, c.name),
          ], f.categoryId);
          if (r != null) {
            _set(f.copyWith(categoryId: () => r.$1, needsCategory: false));
          }
        },
      ),
      if (accounts.length > 1)
        _FilterChip(
          label: names[f.accountId] ?? 'All accounts',
          active: f.accountId != null,
          onTap: () async {
            final r = await _pick<String>('Account', [
              (null, 'All accounts'),
              for (final a in accounts) (a.id, a.displayName),
            ], f.accountId);
            if (r != null) _set(f.copyWith(accountId: () => r.$1));
          },
        ),
      FilterChip(
        label: const Text('Needs a category'),
        selected: f.needsCategory,
        onSelected: (v) => _set(
          f.copyWith(needsCategory: v, categoryId: v ? () => null : null),
        ),
      ),
      _FilterChip(
        label: switch (f.sort) {
          TransactionSort.newest => 'Newest first',
          TransactionSort.oldest => 'Oldest first',
          TransactionSort.largest => 'Highest amount',
          TransactionSort.smallest => 'Lowest amount',
        },
        active: f.sort != TransactionSort.newest,
        onTap: () async {
          final r = await _pick<TransactionSort>('Sort by', [
            (TransactionSort.newest, 'Newest first'),
            (TransactionSort.oldest, 'Oldest first'),
            (TransactionSort.largest, 'Highest amount'),
            (TransactionSort.smallest, 'Lowest amount'),
          ], f.sort);
          if (r?.$1 case final sort?) _set(f.copyWith(sort: sort));
        },
      ),
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'add-${widget.title}',
        tooltip: 'Add a transaction',
        onPressed: () => context.push('/add'),
        child: const Icon(Icons.add_rounded),
      ),
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: 'Your rules',
            icon: const Icon(Icons.rule_rounded),
            onPressed: () => context.push('/rules'),
          ),
          IconButton(
            tooltip: 'Import a statement',
            icon: const Icon(Icons.upload_file_rounded),
            onPressed: () => context.push('/import'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.screen,
              0,
              Space.screen,
              Space.s,
            ),
            child: TextField(
              controller: _search,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search payee, UPI ID or note',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear search',
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _search.clear();
                          _set(f.copyWith(search: () => null));
                        },
                      ),
              ),
              onChanged: (v) =>
                  _set(_filter.copyWith(search: () => v.isEmpty ? null : v)),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: Space.screen),
              itemCount: chips.length,
              separatorBuilder: (_, _) => const SizedBox(width: Space.s),
              itemBuilder: (_, i) => Center(child: chips[i]),
            ),
          ),
          Expanded(
            child: txs.when(
              skipLoadingOnReload: true,
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) =>
                  const Center(child: Text("Couldn't load your transactions.")),
              data: (list) {
                if (list.isEmpty && f.isEmpty) {
                  return Center(
                    child: EmptyState(
                      title: 'No transactions yet',
                      message:
                          'Import a bank statement and they will show up here.',
                      actionLabel: 'Import a statement',
                      onAction: () => context.push('/import'),
                    ),
                  );
                }
                if (list.isEmpty) {
                  return Center(
                    child: EmptyState(
                      title: 'Nothing matches',
                      message: 'Try another month or clear the filters.',
                      actionLabel: 'Clear filters',
                      onAction: () {
                        _search.clear();
                        _set(TransactionFilter(sort: f.sort));
                      },
                    ),
                  );
                }
                var out = 0;
                var inn = 0;
                for (final t in list) {
                  if (t.flow == TransactionFlow.transfer) continue;
                  t.direction == Direction.debit
                      ? out += t.amountPaise
                      : inn += t.amountPaise;
                }
                final items = <Object>[
                  '${list.length} ${list.length == 1 ? 'transaction' : 'transactions'}'
                      ' · ${formatInr(Paise(out), paise: PaiseDisplay.never)} out'
                      ' · ${formatInr(Paise(inn), paise: PaiseDisplay.never)} in',
                ];
                // Day headers only make sense in date order.
                final byDate =
                    f.sort == TransactionSort.newest ||
                    f.sort == TransactionSort.oldest;
                LocalDate? day;
                for (final t in list) {
                  if (byDate && t.localDate != day) {
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
                    final String line => Padding(
                      padding: const EdgeInsets.only(top: Space.s),
                      child: Text(line, style: theme.bodySmall),
                    ),
                    final LocalDate d => Padding(
                      padding: const EdgeInsets.only(
                        top: Space.l,
                        bottom: Space.xs,
                      ),
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
                      category: categories[t.categoryId],
                      showDate: !byDate,
                    ),
                    _ => const SizedBox.shrink(),
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// A chip that opens a choice sheet; filled when its filter is set.
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InputChip(
    label: Text(label),
    selected: active,
    showCheckmark: false,
    avatar: const Icon(Icons.arrow_drop_down_rounded),
    onPressed: onTap,
  );
}

/// One row of the list: category, payee, channel and account, signed
/// amount.
class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.transaction,
    this.accountName,
    this.category,
    this.showDate = false,
  });

  final Transaction transaction;
  final String? accountName;
  final Category? category;

  /// Adds the date to the second line, for lists not grouped by day.
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final c = context.colors;
    final theme = Theme.of(context).textTheme;
    final transfer = t.flow == TransactionFlow.transfer;
    final byHand =
        t.flowReason == FlowReason.user && t.channel == Channel.other;
    final subtitle = [
      if (showDate) formatShortDate(t.localDate),
      category?.name ?? 'Needs a category',
      byHand ? 'Added by you' : channelLabel(t.channel),
      ?accountName,
    ].join(' · ');
    return InkWell(
      borderRadius: BorderRadius.circular(Radii.chip),
      onTap: () => showTransactionDetail(context, t.id, accountName),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.s),
        child: Row(
          children: [
            if (category case final cat?)
              CategoryBadge(cat)
            else
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

/// "See why": the category and why, what was read from the statement, and
/// why the transaction counts as spend, income, refund or transfer. Tap
/// "Change" to pick another category.
Future<void> showTransactionDetail(
  BuildContext context,
  String transactionId,
  String? accountName,
) => showModalBottomSheet<void>(
  context: context,
  useRootNavigator: true,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) =>
      _TransactionDetail(id: transactionId, accountName: accountName),
);

class _TransactionDetail extends ConsumerWidget {
  const _TransactionDetail({required this.id, this.accountName});

  final String id;
  final String? accountName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(transactionProvider(id)).value;
    if (t == null) return const SizedBox(height: 200);
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final category = categories.where((c) => c.id == t.categoryId).firstOrNull;
    final rules = ref.watch(categoryRulesProvider).value ?? const [];
    final theme = Theme.of(context).textTheme;
    final flowLabel = switch (t.flow) {
      TransactionFlow.spend => 'Spending',
      TransactionFlow.income => 'Income',
      TransactionFlow.refund => 'Refund',
      TransactionFlow.transfer => 'Transfer',
    };
    final facts = <(String, String)>[
      ('Date', formatShortDate(t.localDate)),
      if (accountName != null) ('Account', accountName!),
      if (t.flowReason != FlowReason.user || t.channel != Channel.other)
        ('Paid by', channelLabel(t.channel)),
      if (t.vpa != null) ('UPI ID', t.vpa!),
      if (t.upiRef != null) ('UPI ref', t.upiRef!),
      if (t.bankRef != null) ('Bank ref', t.bankRef!),
      if (t.cardLast4 != null) ('Card', '••${t.cardLast4}'),
    ];
    final input = categorizeInputOf(t);
    final canRemember = ruleForCorrection(input) != null;
    final manual = ref.watch(isManualProvider(t.id)).value ?? false;

    Future<void> remove() async {
      final ok = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Remove this entry?'),
          content: Text(
            t.flow == TransactionFlow.transfer
                ? 'Both sides of the transfer go.'
                : 'It comes off your totals and balances.',
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
      final entries = await ref.read(manualEntriesProvider.future);
      await entries.delete(t.id);
      if (context.mounted) Navigator.of(context).pop();
    }

    Future<void> change() async {
      final choice = await showCategoryPicker(
        context,
        categories: categories,
        direction: t.direction,
        currentId: t.categoryId,
        payee: canRemember ? displayName(t) : null,
      );
      if (choice == null) return;
      final service = await ref.read(categoryServiceProvider.future);
      final others = await service.setCategory(
        t.id,
        choice.categoryId,
        always: choice.always,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            others == 0
                ? 'Category changed.'
                : 'Category changed, and $others more from '
                      '${displayName(t)} updated too.',
          ),
        ),
      );
    }

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
          SectionHeader(
            'Category',
            action: TextButton(onPressed: change, child: const Text('Change')),
          ),
          AppCard(
            soft: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (category != null) ...[
                  CategoryBadge(category),
                  const SizedBox(width: Space.m),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category?.name ?? 'Needs a category',
                        style: theme.titleMedium,
                      ),
                      const SizedBox(height: Space.xs),
                      Text(categoryWhy(t, rules), style: theme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
          SectionHeader(manual ? 'Details' : 'What we read'),
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
          if (t.notes != null) ...[
            const SectionHeader('Note'),
            Text(t.notes!, style: theme.bodyMedium),
          ],
          if (t.descriptionRaw != null) ...[
            const SectionHeader('From your statement'),
            SelectableText(t.descriptionRaw!, style: theme.bodySmall),
          ],
          if (manual) ...[
            const SizedBox(height: Space.xl),
            PillButton(
              label: 'Remove this entry',
              kind: PillButtonKind.secondary,
              icon: Icons.delete_outline_rounded,
              expand: true,
              onPressed: remove,
            ),
          ],
        ],
      ),
    );
  }
}

/// Why [t] has its category, worked out on the device from your rules and
/// the built-in dictionary.
String categoryWhy(Transaction t, List<CategoryRule> rules) {
  if (t.categorizedBy == CategorizationMethod.manual) return 'You picked this.';
  final d = Categorizer([
    for (final r in rules)
      if (r.enabled)
        CategoryRuleSpec(
          id: r.id,
          type: r.type,
          match: r.match,
          categoryId: r.categoryId,
          priority: r.priority,
        ),
  ]).categorize(categorizeInputOf(t));
  if (d == null || d.categoryId != t.categoryId) {
    return "Nothing we know matched this payee. Pick a category and we'll "
        'remember it.';
  }
  final guess = d.confidence < categoryReviewBelow
      ? ' This is a guess, so check it.'
      : '';
  return '${d.explain()}$guess';
}
