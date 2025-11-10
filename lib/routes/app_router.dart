import 'package:go_router/go_router.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/role_selection/role_selection_screen.dart';
import '../screens/home/child_home_screen.dart';
import '../screens/parent_dashboard/parent_login_screen.dart';
import '../screens/parent_dashboard/dashboard_screen.dart';

/// Application router configuration using GoRouter
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/child-home',
        builder: (context, state) => const ChildHomeScreen(),
      ),
      GoRoute(
        path: '/parent-login',
        builder: (context, state) => const ParentLoginScreen(),
      ),
      GoRoute(
        path: '/parent-dashboard',
        builder: (context, state) => const ParentDashboardScreen(),
      ),
    ],
  );
}
