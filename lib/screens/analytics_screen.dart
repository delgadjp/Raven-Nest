import 'package:flutter/material.dart';
import '../widgets/navigation.dart';

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
  ];

  final List<Map<String, dynamic>> bookingSources = const [
    {'name': 'Airbnb', 'value': 45, 'color': Color(0xFFFF5A5F)},
    {'name': 'Booking.com', 'value': 35, 'color': Color(0xFF003580)},
    {'name': 'Direct', 'value': 15, 'color': Color(0xFF10B981)},
    {'name': 'Other', 'value': 5, 'color': Color(0xFF6B7280)},
  ];

  final List<Map<String, dynamic>> roomPerformance = const [
    {'room': 'Room 201', 'occupancy': 85, 'revenue': 15600},
    {'room': 'Room 305', 'occupancy': 78, 'revenue': 14200},
    {'room': 'Room 412', 'occupancy': 92, 'revenue': 16800},
    {'room': 'Studio', 'occupancy': 65, 'revenue': 9400},
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
                    _buildHeader(),
                    const SizedBox(height: 24),
                    
                    // KPI Cards
                    _buildKPICards(),
                    const SizedBox(height: 32),
                    
                    // Charts Section
                    _buildChartsSection(),
                    const SizedBox(height: 32),
                    
                    // Bottom Section
                    _buildBottomSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF4F46E5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.bar_chart,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analytics Dashboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              'Track your property performance',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKPICards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMd = constraints.maxWidth >= 900;
        final isLg = constraints.maxWidth >= 1200;
        int columns = 1;
        if (isLg) {
          columns = 4;
        } else if (isMd) {
          columns = 4; // mimic md:grid-cols-4
        }
        return GridView.count(
          crossAxisCount: columns,
          childAspectRatio: 3.2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildKPICard(
              title: 'Total Revenue',
              value: '\$42,300',
              subtitle: '+12% from last year',
              icon: Icons.attach_money,
              iconColor: const Color(0xFF10B981),
            ),
            _buildKPICard(
              title: 'Avg Occupancy',
              value: '78%',
              subtitle: '+5% from last month',
              icon: Icons.people,
              iconColor: const Color(0xFF3B82F6),
            ),
            _buildKPICard(
              title: 'Total Bookings',
              value: '168',
              subtitle: '+8% from last year',
              icon: Icons.calendar_today,
              iconColor: const Color(0xFF7C3AED),
            ),
            _buildKPIGradientCard(
              title: 'Avg Daily Rate',
              value: '\$156',
              subtitle: '-3% from last month',
            ),
          ],
        );
      },
    );
  }

  Widget _buildKPICard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white.withOpacity(0.8),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54)),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: iconColor)),
            Row(
              children: [
                Icon(icon, size: 12, color: Colors.black38),
                const SizedBox(width: 4),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.black45)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKPIGradientCard({
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF97316), Color(0xFFDC2626)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white70)),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          Row(
            children: [
              const Icon(Icons.trending_down, size: 12, color: Colors.white70),
              const SizedBox(width: 4),
              Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildRevenueChart()),
            const SizedBox(width: 16),
            Expanded(child: _buildBookingSourcesChart()),
          ],
        ),
      ],
    );
  }

  Widget _buildRevenueChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Revenue',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Revenue and booking trends over the year',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: _buildSimpleLineChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleLineChart() {
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: LineChartPainter(monthlyRevenue),
    );
  }

  Widget _buildBookingSourcesChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Sources',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Distribution of bookings by platform',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: _buildPieChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            size: const Size(120, 120),
            painter: PieChartPainter(bookingSources),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          children: bookingSources.map((source) {
            return Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: source['color'],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${source['name']} ${source['value']}%',
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Row(
      children: [
        Expanded(child: _buildRoomPerformanceChart()),
        const SizedBox(width: 16),
        Expanded(child: _buildKPIMetrics()),
      ],
    );
  }

  Widget _buildRoomPerformanceChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Room Performance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Occupancy rates by room',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: _buildBarChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: BarChartPainter(roomPerformance),
    );
  }

  Widget _buildKPIMetrics() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Key Performance Indicators',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Important metrics for your property',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              _buildMetricRow(
                'Guest Satisfaction',
                '4.8/5',
                'Based on 156 reviews',
                '+0.2 from last month',
                const Color(0xFF10B981),
                true,
              ),
              const SizedBox(height: 16),
              _buildMetricRow(
                'Response Rate',
                '94%',
                'Average response time',
                '+2% from last month',
                const Color(0xFF3B82F6),
                true,
              ),
              const SizedBox(height: 16),
              _buildMetricRow(
                'Cancellation Rate',
                '3.2%',
                'Last 30 days',
                '-0.8% from last month',
                const Color(0xFFF97316),
                true,
              ),
              const SizedBox(height: 16),
              _buildMetricRow(
                'Revenue per Room',
                '\$14,000',
                'Monthly average',
                '+\$1,200 from last month',
                const Color(0xFF7C3AED),
                true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(
    String title,
    String value,
    String subtitle,
    String change,
    Color valueColor,
    bool isPositive,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  size: 12,
                  color: isPositive ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 2),
                Text(
                  change,
                  style: TextStyle(
                    fontSize: 10,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// Custom painter for line chart
class LineChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;

  LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF10B981)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    final maxRevenue = data.map((e) => e['revenue'] as int).reduce((a, b) => a > b ? a : b);
    
    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - ((data[i]['revenue'] as int) / maxRevenue) * size.height;
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for pie chart
class PieChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;

  PieChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    double startAngle = 0;
    
    for (final item in data) {
      final paint = Paint()
        ..color = item['color']
        ..style = PaintingStyle.fill;
      
      final sweepAngle = (item['value'] / 100) * 2 * 3.14159;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for bar chart
class BarChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;

  BarChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3B82F6)
      ..style = PaintingStyle.fill;

    final barWidth = size.width / (data.length * 2);
    final maxOccupancy = data.map((e) => e['occupancy'] as int).reduce((a, b) => a > b ? a : b);
    
    for (int i = 0; i < data.length; i++) {
      final x = i * (size.width / data.length) + barWidth / 2;
      final barHeight = ((data[i]['occupancy'] as int) / maxOccupancy) * size.height;
      final y = size.height - barHeight;
      
      canvas.drawRect(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
