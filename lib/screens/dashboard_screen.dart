import '../constants/app_exports.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Analytics data for charts
  final List<Map<String, dynamic>> monthlyRevenue = const [
    {'month': 'Jan', 'revenue': 2400, 'bookings': 8},
    {'month': 'Feb', 'revenue': 2800, 'bookings': 10},
    {'month': 'Mar', 'revenue': 3200, 'bookings': 12},
    {'month': 'Apr', 'revenue': 2900, 'bookings': 11},
    {'month': 'May', 'revenue': 3500, 'bookings': 14},
    {'month': 'Jun', 'revenue': 4200, 'bookings': 16},
    {'month': 'Jul', 'revenue': 4800, 'bookings': 18},
    {'month': 'Aug', 'revenue': 4600, 'bookings': 17},
    {'month': 'Sep', 'revenue': 3800, 'bookings': 15},
    {'month': 'Oct', 'revenue': 3400, 'bookings': 13},
    {'month': 'Nov', 'revenue': 3100, 'bookings': 12},
    {'month': 'Dec', 'revenue': 3600, 'bookings': 14},
  ];

  final List<Map<String, dynamic>> bookingSources = const [
    {'name': 'Airbnb', 'value': 45, 'color': Color(0xFFFF5A5F)},
    {'name': 'Booking.com', 'value': 35, 'color': Color(0xFF003580)},
    {'name': 'Direct', 'value': 15, 'color': Color(0xFF10B981)},
    {'name': 'Other', 'value': 5, 'color': Color(0xFF6B7280)},
  ];

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
                        // Quick Stats Cards
                        Row(
                          children: [
                            Expanded(
                              child: SummaryCard(
                                title: 'Monthly Expenses',
                                value: '\$2,450',
                                subtitle: 'Fixed + Variable costs',
                                icon: Icons.attach_money,
                                iconColor: const Color(0xFF16A34A),
                                onTap: () => context.go('/expenses'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SummaryCard(
                                title: 'Active Bookings',
                                value: '18',
                                subtitle: 'This month',
                                icon: Icons.calendar_today,
                                iconColor: const Color(0xFF2563EB),
                                onTap: () => context.go('/calendar'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: SummaryCard(
                                title: 'Inventory Items',
                                value: '45',
                                subtitle: 'Supplies & washables',
                                icon: Icons.inventory,
                                iconColor: const Color(0xFF7C3AED),
                                onTap: () => context.go('/inventory'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SummaryCard(
                                title: 'Pending Tasks',
                                value: '3',
                                subtitle: 'Housekeeping items',
                                icon: Icons.check_circle,
                                iconColor: const Color(0xFFEA580C),
                                onTap: () => context.go('/housekeeping'),
                              ),
                            ),
                          ],
                        ),  
                        const SizedBox(height: 10),

                        // Analytics KPI Cards
                        Row(
                          children: [
                            Expanded(
                              child: SummaryCard(
                                title: 'Total Revenue',
                                value: '\$42,300',
                                subtitle: '+12% from last year',
                                icon: Icons.attach_money,
                                iconColor: const Color(0xFF10B981),
                                onTap: () => context.go('/'), // Navigate to dashboard (analytics view)
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SummaryCard(
                                title: 'Unread Notifications',
                                value: '7',
                                subtitle: 'Require attention',
                                icon: Icons.notifications,
                                iconColor: const Color(0xFFEF4444),
                                onTap: () => context.go('/notifications'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Analytics Charts Section
                        ResponsiveChartsLayout(
                          charts: [
                            ChartContainer(
                              title: 'Monthly Revenue',
                              subtitle: 'Revenue and booking trends over the year',
                              chart: RevenueLineChart(data: monthlyRevenue),
                            ),
                            ChartContainer(
                              title: 'Booking Sources',
                              subtitle: 'Distribution of bookings by platform',
                              chart: BookingSourcesPieChart(data: bookingSources),
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
