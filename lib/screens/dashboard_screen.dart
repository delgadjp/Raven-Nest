import 'package:flutter/material.dart';
import 'dart:ui' as ui show ImageFilter;
import 'package:go_router/go_router.dart';
import '../widgets/navigation.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const NavigationWidget(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF8FAFC),
                    Color(0xFFDDEAFF),
                    Color(0xFFE0E7FF),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    // Header
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.home,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Condo Manager',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Your complete property management solution',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Stats Cards
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Wrap(
                          spacing: 24,
                          runSpacing: 24,
                          children: [
                            SizedBox(
                              width: constraints.maxWidth >= 1200 
                                ? (constraints.maxWidth - 72) / 4 // 4 columns with spacing
                                : constraints.maxWidth >= 900 
                                  ? (constraints.maxWidth - 24) / 2 // 2 columns with spacing
                                  : constraints.maxWidth, // 1 column
                              child: _buildStatsCard(
                                'Monthly Expenses',
                                '\$2,450',
                                'Fixed + Variable costs',
                                Icons.attach_money,
                                const Color(0xFF16A34A),
                                '/expenses',
                                context,
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth >= 1200 
                                ? (constraints.maxWidth - 72) / 4 // 4 columns with spacing
                                : constraints.maxWidth >= 900 
                                  ? (constraints.maxWidth - 24) / 2 // 2 columns with spacing
                                  : constraints.maxWidth, // 1 column
                              child: _buildStatsCard(
                                'Active Bookings',
                                '18',
                                'This month',
                                Icons.calendar_today,
                                const Color(0xFF2563EB),
                                '/calendar',
                                context,
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth >= 1200 
                                ? (constraints.maxWidth - 72) / 4 // 4 columns with spacing
                                : constraints.maxWidth >= 900 
                                  ? (constraints.maxWidth - 24) / 2 // 2 columns with spacing
                                  : constraints.maxWidth, // 1 column
                              child: _buildStatsCard(
                                'Inventory Items',
                                '45',
                                'Supplies & washables',
                                Icons.inventory,
                                const Color(0xFF7C3AED),
                                '/inventory',
                                context,
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth >= 1200 
                                ? (constraints.maxWidth - 72) / 4 // 4 columns with spacing
                                : constraints.maxWidth >= 900 
                                  ? (constraints.maxWidth - 24) / 2 // 2 columns with spacing
                                  : constraints.maxWidth, // 1 column
                              child: _buildStatsCard(
                                'Pending Tasks',
                                '3',
                                'Housekeeping items',
                                Icons.check_circle,
                                const Color(0xFFEA580C),
                                '/housekeeping',
                                context,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    // Quick Actions
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 0),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = 1;
                        if (constraints.maxWidth > 1024) {
                          crossAxisCount = 4;
                        } else if (constraints.maxWidth > 768) {
                          crossAxisCount = 2;
                        }
                        
                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 4,
                          children: [
                            _buildQuickActionCard(
                              'View Analytics',
                              Icons.bar_chart,
                              const LinearGradient(
                                colors: [Color(0xFF3B82F6), Color(0xFF7C3AED)],
                              ),
                              '/analytics',
                              context,
                            ),
                            _buildQuickActionCard(
                              'Housekeeping',
                              Icons.people_alt_rounded,
                              const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF0D9488)],
                              ),
                              '/housekeeping',
                              context,
                            ),
                            _buildQuickActionCard(
                              'Notifications',
                              Icons.notifications,
                              const LinearGradient(
                                colors: [Color(0xFFEF4444), Color(0xFFEC4899)],
                              ),
                              '/notifications',
                              context,
                            ),
                            _buildQuickActionCard(
                              'Guest Logs',
                              Icons.description,
                              const LinearGradient(
                                colors: [Color(0xFF6366F1), Color(0xFF3B82F6)],
                              ),
                              '/guest-logs',
                              context,
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // Recent Activity
                    _buildRecentActivityCard(context),
                  ],
                ),
              ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(
    String title,
    String value,
    String description,
    IconData icon,
    Color iconColor,
    String route,
    BuildContext context,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.go(route),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    Icon(
                      icon,
                      size: 18,
                      color: iconColor,
                    ),
                  ],
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Gradient gradient,
    String route,
    BuildContext context,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.go(route),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.trending_up,
                  color: Colors.white70,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.notifications, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Recent Activity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  children: const [
                    _ActivityItem(
                      dotColor: Color(0xFF3B82F6),
                      backgroundColor: Color(0xFFEFF6FF),
                      borderColor: Color(0xFFBFDBFE),
                      title: 'New booking confirmed',
                      subtitle: 'Room 201 • Check-in: Tomorrow',
                      timeAgo: '2h ago',
                    ),
                    SizedBox(height: 8),
                    _ActivityItem(
                      dotColor: Color(0xFF10B981),
                      backgroundColor: Color(0xFFECFDF5),
                      borderColor: Color(0xFFA7F3D0),
                      title: 'Cleaning completed',
                      subtitle: 'Room 305 • Ready for next guest',
                      timeAgo: '4h ago',
                    ),
                    SizedBox(height: 8),
                    _ActivityItem(
                      dotColor: Color(0xFFF59E0B),
                      backgroundColor: Color(0xFFFFF7ED),
                      borderColor: Color(0xFFFCD34D),
                      title: 'Low inventory alert',
                      subtitle: 'Towels need restocking',
                      timeAgo: '6h ago',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.go('/notifications'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                      foregroundColor: Colors.black87,
                    ).copyWith(
                      overlayColor: MaterialStateProperty.resolveWith(
                        (states) {
                          if (states.contains(MaterialState.hovered) ||
                              states.contains(MaterialState.pressed) ||
                              states.contains(MaterialState.focused)) {
                            return Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.08);
                          }
                          return null;
                        },
                      ),
                    ),
                    child: const Text(
                      'View All Notifications',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final Color dotColor;
  final Color backgroundColor;
  final Color borderColor;
  final String title;
  final String subtitle;
  final String timeAgo;

  const _ActivityItem({
    required this.dotColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            timeAgo,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
