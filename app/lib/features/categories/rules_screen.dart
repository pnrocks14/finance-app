import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/data_providers.dart';
import 'category_visuals.dart';

/// The rules you made by changing a category with "Always for …" on.
/// Deleting one puts its transactions back to the built-in guess.
class RulesScreen extends ConsumerWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rules = ref.watch(categoryRulesProvider);
    final categories = {
      for (final c in ref.watch(categoriesProvider).value ?? const <Category>[])
        c.id: c,
    };
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Your rules')),
      body: rules.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text("Couldn't load your rules.")),
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: EmptyState(
                title: 'No rules yet',
                message:
                    'Change a transaction\'s category with "Always for" on, '
                    'and the rule shows up here.',
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(Space.screen),
            children: [
              for (final r in list)
                Padding(
                  padding: const EdgeInsets.only(bottom: Space.s),
                  child: AppCard(
                    soft: true,
                    padding: const EdgeInsets.fromLTRB(
                      Space.l,
                      Space.s,
                      Space.xs,
                      Space.s,
                    ),
                    child: Row(
                      children: [
                        if (categories[r.categoryId] case final c?)
                          CategoryBadge(c, radius: 18),
                        const SizedBox(width: Space.m),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ruleLabel(r), style: theme.bodyLarge),
                              Text(
                                '${categories[r.categoryId]?.name ?? 'Unknown'}'
                                ' · used ${r.hitCount} '
                                '${r.hitCount == 1 ? 'time' : 'times'}',
                                style: theme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Delete rule',
                          icon: const Icon(Icons.delete_outline_rounded),
                          onPressed: () async {
                            final service = await ref.read(
                              categoryServiceProvider.future,
                            );
                            await service.deleteRule(r.id);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// "Paid to swiggy", "From ravi@ybl", "Mentions rent".
String ruleLabel(CategoryRule r) {
  final dir = r.match['direction'];
  final verb = dir == 'credit' ? 'From' : (dir == 'debit' ? 'Paid to' : 'With');
  return switch (r.type) {
    RuleType.merchantKey => '$verb ${'${r.match['key']}'.replaceAll('_', ' ')}',
    RuleType.vpa => '$verb ${r.match['vpa']}',
    RuleType.keyword => 'Mentions "${r.match['contains']}"',
    RuleType.regex => 'Matches ${r.match['pattern']}',
    RuleType.pattern => 'Pattern rule',
  };
}
