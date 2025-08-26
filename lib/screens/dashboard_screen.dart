import '/constants/app_exports.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Column(
        children: [
          const NavigationWidget(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats Cards
                        ResponsiveCardGrid(
                          children: [
                            SummaryCard(
                              title: 'Monthly Expenses',
                              value: '\$2,450',
                              subtitle: 'Fixed + Variable costs',
                              icon: Icons.attach_money,
                              iconColor: const Color(0xFF16A34A),
                            ),
                            SummaryCard(
                              title: 'Active Bookings',
                              value: '18',
                              subtitle: 'This month',
                              icon: Icons.calendar_today,
                              iconColor: const Color(0xFF2563EB),
                            ),
                            SummaryCard(
                              title: 'Inventory Items',
                              value: '45',
                              subtitle: 'Supplies & washables',
                              icon: Icons.inventory,
                              iconColor: const Color(0xFF7C3AED),
                            ),
                            SummaryCard(
                              title: 'Pending Tasks',
                              value: '3',
                              subtitle: 'Housekeeping items',
                              icon: Icons.check_circle,
                              iconColor: const Color(0xFFEA580C),
                            ),
                          ],
                        ),  
                        const SizedBox(height: 32),
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
        ],
      ),
    );
  }
}
