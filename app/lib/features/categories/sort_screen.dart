import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/data_providers.dart';
import '../../common/format.dart';
import '../../common/widgets.dart';
import '../transactions/transactions_screen.dart';
import 'category_picker.dart';
import 'category_visuals.dart';

/// The labelling queue: transactions with no category, or only a guess, one
/// at a time. Pick a category and the next one comes up; with "Always for"
/// on, the payee's other transactions are sorted too.
class SortScreen extends ConsumerStatefulWidget {
  const SortScreen({super.key});

  @override
  ConsumerState<SortScreen> createState() => _SortScreenState();
}

class _SortScreenState extends ConsumerState<SortScreen> {
  final _skipped = <String>{};
  var _always = true;
  var _busy = false;

  Future<void> _pick(Transaction t, String categoryId, bool canRemember) async {
    setState(() => _busy = true);
    final service = await ref.read(categoryServiceProvider.future);
    final others = await service.setCategory(
      t.id,
      categoryId,
      always: canRemember && _always,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (others > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$others more from ${displayName(t)} sorted too.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final queue = ref.watch(
      filteredTransactionsProvider(
        const TransactionFilter(needsCategory: true),
      ),
    );
    final categories =
        ref.watch(categoriesProvider).value ?? const <Category>[];
    final byId = {for (final c in categories) c.id: c};
    final accounts = {
      for (final a in ref.watch(accountsProvider).value ?? const <Account>[])
        a.id: a.displayName,
    };
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Sort transactions')),
      body: queue.when(
        skipLoadingOnReload: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) =>
            const Center(child: Text("Couldn't load your transactions.")),
        data: (list) {
          final left = list.where((t) => !_skipped.contains(t.id)).toList();
          if (left.isEmpty) {
            return Center(
              child: EmptyState(
                title: list.isEmpty ? 'All sorted' : 'Only skipped ones left',
                message: list.isEmpty
                    ? 'Every transaction has a category.'
                    : 'Come back to the ${list.length} you skipped any time.',
                actionLabel: list.isEmpty ? null : 'Show them again',
                onAction: list.isEmpty ? null : () => setState(_skipped.clear),
              ),
            );
          }
          final t = left.first;
          final canRemember = ruleForCorrection(categorizeInputOf(t)) != null;
          final guess = byId[t.categoryId];
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              Space.screen,
              Space.s,
              Space.screen,
              Space.xxxl,
            ),
            children: [
              Text('${left.length} to go', style: theme.bodySmall),
              const SizedBox(height: Space.s),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(displayName(t), style: theme.headlineSmall),
                    const SizedBox(height: Space.xs),
                    SignedAmount(
                      amount: Paise(t.amountPaise),
                      direction: t.direction,
                    ),
                    const SizedBox(height: Space.xs),
                    Text(
                      [
                        formatShortDate(t.localDate),
                        channelLabel(t.channel),
                        ?accounts[t.accountId],
                      ].join(' · '),
                      style: theme.bodySmall,
                    ),
                    if (t.descriptionRaw != null) ...[
                      const SizedBox(height: Space.s),
                      Text(
                        t.descriptionRaw!,
                        style: theme.bodySmall,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (guess != null) ...[
                      const SizedBox(height: Space.m),
                      Row(
                        children: [
                          CategoryBadge(guess, radius: 14),
                          const SizedBox(width: Space.s),
                          Expanded(
                            child: Text(
                              'Our guess: ${guess.name}',
                              style: theme.bodyMedium,
                            ),
                          ),
                          TextButton(
                            onPressed: _busy
                                ? null
                                : () => _pick(t, guess.id, canRemember),
                            child: const Text("That's right"),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (canRemember)
                AlwaysForSwitch(
                  payee: displayName(t),
                  value: _always,
                  onChanged: (v) => setState(() => _always = v),
                ),
              CategoryGroups(
                categories: categories,
                direction: t.direction,
                onPick: (id) {
                  if (!_busy) _pick(t, id, canRemember);
                },
              ),
              const SizedBox(height: Space.l),
              PillButton(
                label: 'Skip for now',
                kind: PillButtonKind.quiet,
                expand: true,
                onPressed: () => setState(() => _skipped.add(t.id)),
              ),
            ],
          );
        },
      ),
    );
  }
}
