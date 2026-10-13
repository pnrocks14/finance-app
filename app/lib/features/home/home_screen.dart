import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../lock/lock_controller.dart';

/// Home, phase 1 version: the database is open and empty, so this is a
/// friendly empty state. The donut overview arrives in phase 4.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hi there'),
        actions: [
          IconButton(
            tooltip: 'Style sheet',
            icon: const Icon(Icons.palette_outlined),
            onPressed: () => context.push('/style-sheet'),
          ),
          IconButton(
            tooltip: 'Lock now',
            icon: const Icon(Icons.lock_outline_rounded),
            onPressed: () =>
                ref.read(lockControllerProvider.notifier).lockNow(),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: db.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(Space.screen),
              child: Text(
                "Couldn't open your data on this phone. Restart the app to try again.",
                style: theme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            data: (_) => EmptyState(
              title: 'Your money, all in one place',
              message:
                  'Soon you can import a bank statement and see where every '
                  'rupee goes. For now, have a look at the style sheet.',
              actionLabel: 'Open the style sheet',
              onAction: () => context.push('/style-sheet'),
            ),
          ),
        ),
      ),
    );
  }
}
