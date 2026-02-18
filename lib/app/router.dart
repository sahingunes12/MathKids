import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../core/debug_log.dart';
import '../features/dashboard/home_screen.dart';
import '../features/learning/ui/quiz_screen.dart';
import '../features/gamification/ui/shop_screen.dart';
import '../features/parent_area/ui/stats_screen.dart';
import '../features/gamification/ui/profile_selection_screen.dart';
import '../features/gamification/ui/add_profile_screen.dart';
import '../features/gamification/providers/profile_service.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(RouterRef ref) {
  final activeId = ref.watch(activeProfileIdProvider);
  // #region agent log
  debugLog('router.dart:router', 'router built', {'activeId': activeId}, hypothesisId: 'H1');
  // #endregion

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      debugPrint('Router: Redirecting for ${state.matchedLocation} (activeId: $activeId)');

      final isGoingToProfile = state.matchedLocation == '/profile-selection' ||
                             state.matchedLocation == '/add-profile';

      if (activeId == null && !isGoingToProfile) {
        // #region agent log
        debugLog('router.dart:redirect', 'redirect to profile-selection', {'matchedLocation': state.matchedLocation}, hypothesisId: 'H3');
        // #endregion
        debugPrint('Router: No active profile, redirecting to /profile-selection');
        return '/profile-selection';
      }
      // #region agent log
      debugLog('router.dart:redirect', 'no redirect', {'matchedLocation': state.matchedLocation, 'activeId': activeId}, hypothesisId: 'H3');
      // #endregion
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'quiz/:moduleId',
            builder: (context, state) => QuizScreen(
              moduleId: state.pathParameters['moduleId']!,
            ),
          ),
          GoRoute(
            path: 'shop',
            builder: (context, state) => const ShopScreen(),
          ),
          GoRoute(
            path: 'stats',
            builder: (context, state) => const StatsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/profile-selection',
        builder: (context, state) => const ProfileSelectionScreen(),
      ),
      GoRoute(
        path: '/add-profile',
        builder: (context, state) => const AddProfileScreen(),
      ),
    ],
  );
}
