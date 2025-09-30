import '/constants/app_exports.dart';

class AppRoutes {
  // Route paths
  static const String dashboard = '/';
  static const String expenses = '/expenses';
  static const String inventory = '/inventory';
  static const String calendar = '/calendar';
  static const String housekeeping = '/housekeeping';
  static const String notifications = '/notifications';
  static const String settings = '/settings';

  static final GoRouter router = GoRouter(
    initialLocation: dashboard,
    routes: [
      GoRoute(
        path: dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: expenses,
        builder: (context, state) => const ExpensesScreen(),
      ),
      GoRoute(
        path: inventory,
        builder: (context, state) => const InventoryScreen(),
      ),
      GoRoute(
        path: calendar,
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        path: housekeeping,
        builder: (context, state) => const HousekeepingScreen(),
      ),
      GoRoute(
        path: notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}