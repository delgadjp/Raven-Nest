import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/dashboard_screen.dart';
import 'screens/expenses_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/housekeeping_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/settings_screen.dart';
// import 'screens/guest_logs_screen.dart';

void main() {
  runApp(CondoManagerApp());
}

class CondoManagerApp extends StatelessWidget {
  CondoManagerApp({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/expenses',
        builder: (context, state) => const ExpensesScreen(),
      ),
      GoRoute(
        path: '/inventory',
        builder: (context, state) => const InventoryScreen(),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        path: '/analytics',
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: '/housekeeping',
        builder: (context, state) => const HousekeepingScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      // GoRoute(
      //   path: '/guest-logs',
      //   builder: (context, state) => const GuestLogsScreen(),
      // ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Condo Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.transparent,
      ),
      routerConfig: _router,
    );
  }
}
