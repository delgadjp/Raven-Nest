import '/constants/app_exports.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  // Sample data for charts
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
                    Color(0xFFE0E7FF),
                    Color(0xFFC7D2FE),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    // KPI Cards
                    ResponsiveCardGrid(
                      children: [
                        SummaryCard(
                          title: 'Total Revenue',
                          value: '\$42,300',
                          subtitle: '+12% from last year',
                          icon: Icons.attach_money,
                          iconColor: const Color(0xFF10B981),
                        ),
                        SummaryCard(
                          title: 'Avg Occupancy',
                          value: '78%',
                          subtitle: '+5% from last month',
                          icon: Icons.people,
                          iconColor: const Color(0xFF3B82F6),
                        ),
                        SummaryCard(
                          title: 'Total Bookings',
                          value: '168',
                          subtitle: '+8% from last year',
                          icon: Icons.calendar_today,
                          iconColor: const Color(0xFF7C3AED),
                        ),
                        SummaryGradientCard(
                          title: 'Avg Daily Rate',
                          value: '\$156',
                          subtitle: '-3% from last month',
                          gradientColors: const [Color(0xFFF97316), Color(0xFFDC2626)],
                          trendingIcon: Icons.trending_down,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // Charts Section
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
