import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/lock/lock_controller.dart';
import 'providers.dart';
import 'router.dart';

class FinanceApp extends ConsumerStatefulWidget {
  const FinanceApp({super.key});

  @override
  ConsumerState<FinanceApp> createState() => _FinanceAppState();
}

class _FinanceAppState extends ConsumerState<FinanceApp> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // Re-lock after a minute in the background.
    _lifecycle = AppLifecycleListener(
      onHide: () => ref.read(lockControllerProvider.notifier).onBackgrounded(),
      onShow: () => ref.read(lockControllerProvider.notifier).onResumed(),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Finance',
      debugShowCheckedModeBanner: false,
      theme: FinanceTheme.light(),
      darkTheme: FinanceTheme.dark(),
      themeMode: ref.watch(themeModeProvider),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
