import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/categories/rules_screen.dart';
import '../features/categories/sort_screen.dart';
import '../features/home/home_screen.dart';
import '../features/import/import_screen.dart';
import '../features/lock/lock_controller.dart';
import '../features/lock/lock_screen.dart';
import '../features/style_sheet/style_sheet_screen.dart';
import '../features/transactions/transactions_screen.dart';
import 'splash_screen.dart';

/// Routes. While the app is locked, every route redirects to the lock
/// screens, so nothing behind the lock can render.
final routerProvider = Provider<GoRouter>((ref) {
  final lockStatus = ValueNotifier<LockStatus>(
    ref.read(lockControllerProvider),
  );
  ref
    ..listen(lockControllerProvider, (_, next) => lockStatus.value = next)
    ..onDispose(lockStatus.dispose);

  final router = GoRouter(
    initialLocation: '/',
    refreshListenable: lockStatus,
    redirect: (context, state) {
      final path = state.matchedLocation;
      return switch (lockStatus.value) {
        LockStatus.checking => path == '/splash' ? null : '/splash',
        LockStatus.needsSetup => path == '/setup' ? null : '/setup',
        LockStatus.locked => path == '/unlock' ? null : '/unlock',
        LockStatus.unlocked =>
          const {'/splash', '/setup', '/unlock'}.contains(path) ? '/' : null,
      };
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/setup', builder: (_, _) => const PinSetupScreen()),
      GoRoute(path: '/unlock', builder: (_, _) => const UnlockScreen()),
      GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
      GoRoute(path: '/import', builder: (_, _) => const ImportScreen()),
      GoRoute(
        path: '/transactions',
        builder: (_, state) => TransactionsScreen(
          key: ValueKey(state.uri.query),
          initial: TransactionsScreen.filterFrom(state.uri.queryParameters),
        ),
      ),
      GoRoute(path: '/sort', builder: (_, _) => const SortScreen()),
      GoRoute(path: '/rules', builder: (_, _) => const RulesScreen()),
      GoRoute(
        path: '/style-sheet',
        builder: (_, _) => const StyleSheetScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
