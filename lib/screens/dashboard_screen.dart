import 'package:flutter/material.dart';
import '../widgets/navigation.dart';
import '../widgets/summary_card.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/recent_activity_card.dart';

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
                              child: SummaryCard(
                                title: 'Monthly Expenses',
                                value: '\$2,450',
                                subtitle: 'Fixed + Variable costs',
                                icon: Icons.attach_money,
                                iconColor: const Color(0xFF16A34A),
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth >= 1200 
                                ? (constraints.maxWidth - 72) / 4 // 4 columns with spacing
                                : constraints.maxWidth >= 900 
                                  ? (constraints.maxWidth - 24) / 2 // 2 columns with spacing
                                  : constraints.maxWidth, // 1 column
                              child: SummaryCard(
                                title: 'Active Bookings',
                                value: '18',
                                subtitle: 'This month',
                                icon: Icons.calendar_today,
                                iconColor: const Color(0xFF2563EB),
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth >= 1200 
                                ? (constraints.maxWidth - 72) / 4 // 4 columns with spacing
                                : constraints.maxWidth >= 900 
                                  ? (constraints.maxWidth - 24) / 2 // 2 columns with spacing
                                  : constraints.maxWidth, // 1 column
                              child: SummaryCard(
                                title: 'Inventory Items',
                                value: '45',
                                subtitle: 'Supplies & washables',
                                icon: Icons.inventory,
                                iconColor: const Color(0xFF7C3AED),
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth >= 1200 
                                ? (constraints.maxWidth - 72) / 4 // 4 columns with spacing
                                : constraints.maxWidth >= 900 
                                  ? (constraints.maxWidth - 24) / 2 // 2 columns with spacing
                                  : constraints.maxWidth, // 1 column
                              child: SummaryCard(
                                title: 'Pending Tasks',
                                value: '3',
                                subtitle: 'Housekeeping items',
                                icon: Icons.check_circle,
                                iconColor: const Color(0xFFEA580C),
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
                            QuickActionCard(
                              title: 'View Analytics',
                              icon: Icons.bar_chart,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF3B82F6), Color(0xFF7C3AED)],
                              ),
                              route: '/analytics',
                            ),
                            QuickActionCard(
                              title: 'Housekeeping',
                              icon: Icons.people_alt_rounded,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF0D9488)],
                              ),
                              route: '/housekeeping',
                            ),
                            QuickActionCard(
                              title: 'Notifications',
                              icon: Icons.notifications,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFEF4444), Color(0xFFEC4899)],
                              ),
                              route: '/notifications',
                            ),
                            // QuickActionCard(
                            //   title: 'Guest Logs',
                            //   icon: Icons.description,
                            //   gradient: const LinearGradient(
                            //     colors: [Color(0xFF6366F1), Color(0xFF3B82F6)],
                            //   ),
                            //   route: '/guest-logs',
                            // ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // Recent Activity
                    RecentActivityCard(
                      activities: const [
                        ActivityData(
                          dotColor: Color(0xFF3B82F6),
                          backgroundColor: Color(0xFFEFF6FF),
                          borderColor: Color(0xFFBFDBFE),
                          title: 'New booking confirmed',
                          subtitle: 'Room 201 • Check-in: Tomorrow',
                          timeAgo: '2h ago',
                        ),
                        ActivityData(
                          dotColor: Color(0xFF10B981),
                          backgroundColor: Color(0xFFECFDF5),
                          borderColor: Color(0xFFA7F3D0),
                          title: 'Cleaning completed',
                          subtitle: 'Room 305 • Ready for next guest',
                          timeAgo: '4h ago',
                        ),
                        ActivityData(
                          dotColor: Color(0xFFF59E0B),
                          backgroundColor: Color(0xFFFFF7ED),
                          borderColor: Color(0xFFFCD34D),
                          title: 'Low inventory alert',
                          subtitle: 'Towels need restocking',
                          timeAgo: '6h ago',
                        ),
                      ],
                      viewAllRoute: '/notifications',
                    ),
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
}
