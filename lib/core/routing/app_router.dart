import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/athkar/presentation/views/athkar_view.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../features/main_layout/presentation/views/main_layout_view.dart';
import '../../features/notifications/presentation/views/notifications_view.dart';
import '../../features/qibla/presentation/views/qibla_view.dart';
import '../../features/quran/presentation/views/quran_view.dart';
import '../../features/reciters/presentation/views/reciters_view.dart';
import '../../features/settings/presentation/views/settings_view.dart';
import '../../features/splash/presentation/views/splash_view.dart';
import 'routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.splash,
  routes: [
    GoRoute(
      path: Routes.splash,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: Routes.notifications,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const NotificationsView(),
    ),
    GoRoute(
      path: Routes.settings,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsView(),
    ),
    // Stateful Bottom Navigation Shell (5 Branches with preserved state)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainLayoutView(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: الرئيسية (Home)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.home,
              builder: (context, state) => const HomeView(),
            ),
          ],
        ),

        // Tab 1: المصحف (Quran)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.quran,
              builder: (context, state) => const QuranView(),
            ),
          ],
        ),

        // Tab 2: القبلة (Qibla)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.qibla,
              builder: (context, state) => const QiblaView(),
            ),
          ],
        ),

        // Tab 3: الأذكار (Athkar)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.athkar,
              builder: (context, state) => const AthkarView(),
            ),
          ],
        ),

        // Tab 4: القراء (Reciters)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.reciters,
              builder: (context, state) => const RecitersView(),
            ),
          ],
        ),
      ],
    ),
  ],
);
