import 'package:finance_core/finance_core.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';

/// A living style sheet: every token and component from finance_ui_kit with
/// sample data, in light and dark. This is the screen to approve the design
/// system on before real screens are built.
class StyleSheetScreen extends ConsumerWidget {
  const StyleSheetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final theme = Theme.of(context).textTheme;
    final mode = ref.watch(themeModeProvider);

    final slices = [
      DonutSlice(
        label: 'Rent',
        amount: Paise.rupees(18000),
        color: c.chartToken('chart1'),
      ),
      DonutSlice(
        label: 'Food delivery',
        amount: Paise.rupees(6200),
        color: c.chartToken('chart2'),
      ),
      DonutSlice(
        label: 'Groceries',
        amount: Paise.rupees(4800),
        color: c.chartToken('chart3'),
      ),
      DonutSlice(
        label: 'Travel',
        amount: Paise.rupees(2900),
        color: c.chartToken('chart4'),
      ),
      DonutSlice(
        label: 'Subscriptions',
        amount: Paise.rupees(1450),
        color: c.chartToken('chart5'),
      ),
      DonutSlice(
        label: 'Shopping',
        amount: Paise.rupees(3600),
        color: c.chartToken('chart6'),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Style sheet')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Space.screen,
          0,
          Space.screen,
          Space.xxxl,
        ),
        children: [
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                value: ThemeMode.light,
                label: Text('Light'),
                icon: Icon(Icons.light_mode_outlined),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text('Dark'),
                icon: Icon(Icons.dark_mode_outlined),
              ),
              ButtonSegment(value: ThemeMode.system, label: Text('System')),
            ],
            selected: {mode},
            onSelectionChanged: (s) =>
                ref.read(themeModeProvider.notifier).set(s.first),
          ),

          const SectionHeader('Home, at a glance'),
          AppCard(
            child: Column(
              children: [
                CategoryDonut(slices: slices, centerLabel: 'spent in October'),
                const SizedBox(height: Space.l),
                DonutLegend(slices: slices),
              ],
            ),
          ),

          const SectionHeader('Budgets'),
          AppCard(
            child: Column(
              children: [
                BudgetBar(
                  label: 'Food delivery',
                  spent: Paise.rupees(6900),
                  limit: Paise.rupees(10000),
                ),
                const SizedBox(height: Space.l),
                BudgetBar(
                  label: 'Shopping',
                  spent: Paise.rupees(4300),
                  limit: Paise.rupees(5000),
                ),
                const SizedBox(height: Space.l),
                BudgetBar(
                  label: 'Entertainment',
                  spent: Paise.rupees(3450),
                  limit: Paise.rupees(3000),
                ),
              ],
            ),
          ),

          const SectionHeader('Goals'),
          Row(
            children: [
              Expanded(
                child: _GoalTile(
                  name: 'Emergency fund',
                  progress: 0.62,
                  color: c.good,
                ),
              ),
              const SizedBox(width: Space.m),
              Expanded(
                child: _GoalTile(
                  name: 'Goa trip',
                  progress: 0.28,
                  color: c.primary,
                ),
              ),
            ],
          ),

          const SectionHeader('Buttons and chips'),
          Wrap(
            spacing: Space.s,
            runSpacing: Space.s,
            children: [
              PillButton(label: 'Approve', onPressed: () {}),
              PillButton(
                label: 'See why',
                kind: PillButtonKind.secondary,
                icon: Icons.insights_rounded,
                onPressed: () {},
              ),
              PillButton(
                label: 'Not now',
                kind: PillButtonKind.quiet,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: Space.m),
          Wrap(
            spacing: Space.s,
            runSpacing: Space.s,
            children: [
              CategoryChip(
                label: 'Food delivery',
                color: c.chartToken('chart2'),
                selected: true,
                onTap: () {},
              ),
              CategoryChip(
                label: 'Groceries',
                color: c.chartToken('chart3'),
                onTap: () {},
              ),
              CategoryChip(
                label: 'Travel',
                color: c.chartToken('chart4'),
                icon: Icons.train_rounded,
                onTap: () {},
              ),
            ],
          ),

          const SectionHeader('Type'),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MoneyText(Paise.rupees(123456), style: theme.displayLarge),
                Text(
                  'Display 32 · the big monthly number',
                  style: theme.bodySmall,
                ),
                const SizedBox(height: Space.m),
                Text('Title 24 · screen titles', style: theme.headlineMedium),
                Text('Heading 18 · sections', style: theme.titleLarge),
                Text(
                  'Body 16 · ₹3,100 left for food this month',
                  style: theme.bodyLarge,
                ),
                Text('Secondary 14 · supporting text', style: theme.bodyMedium),
                Text(
                  'Caption 12 · labels and footnotes',
                  style: theme.bodySmall,
                ),
              ],
            ),
          ),

          const SectionHeader('Amounts'),
          AppCard(
            soft: true,
            child: Column(
              children: [
                for (final p in const [
                  Paise(45000),
                  Paise(45050),
                  Paise(12345600),
                  Paise(-89900),
                ])
                  _AmountRow(amount: p),
              ],
            ),
          ),

          const SectionHeader('Colour tokens'),
          Wrap(
            spacing: Space.s,
            runSpacing: Space.s,
            children: [
              _Swatch('bg', c.bg),
              _Swatch('surface', c.surface),
              _Swatch('surfaceSoft', c.surfaceSoft),
              _Swatch('textPrimary', c.textPrimary),
              _Swatch('textSecondary', c.textSecondary),
              _Swatch('primary', c.primary),
              _Swatch('accent', c.accent),
              _Swatch('good', c.good),
              _Swatch('caution', c.caution),
              _Swatch('over', c.over),
              for (var i = 0; i < c.chart.length; i++)
                _Swatch('chart${i + 1}', c.chart[i]),
            ],
          ),

          const SectionHeader('Empty state'),
          const AppCard(
            child: EmptyState(
              title: 'No transactions yet',
              message: 'Import a statement and they will show up here.',
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  const _GoalTile({
    required this.name,
    required this.progress,
    required this.color,
  });

  final String name;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return AppCard(
      child: Column(
        children: [
          ProgressRing(
            progress: progress,
            color: color,
            size: 104,
            semanticLabel: name,
            child: Text(
              '${(progress * 100).round()}%',
              style: theme.titleLarge,
            ),
          ),
          const SizedBox(height: Space.m),
          Text(name, style: theme.titleMedium, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({required this.amount});

  final Paise amount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.xs),
      child: Row(
        children: [
          Expanded(child: MoneyText(amount, style: theme.titleMedium)),
          MoneyText(amount, compact: true, style: theme.bodyMedium),
        ],
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.name, this.color);

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox(
      width: 96,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(Radii.chip),
              border: Border.all(color: c.outline),
            ),
          ),
          const SizedBox(height: Space.xs),
          Text(name, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
