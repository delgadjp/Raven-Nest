import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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
              child: _buildKPICard(
                title: 'Total Revenue',
                value: '\$42,300',
                subtitle: '+12% from last year',
                icon: Icons.attach_money,
                iconColor: const Color(0xFF10B981),
              ),
            ),
            SizedBox(
              width: constraints.maxWidth >= 1200 
                ? (constraints.maxWidth - 72) / 4 // 4 columns with spacing
                : constraints.maxWidth >= 900 
                  ? (constraints.maxWidth - 24) / 2 // 2 columns with spacing
                  : constraints.maxWidth, // 1 column
              child: _buildKPICard(
                title: 'Avg Occupancy',
                value: '78%',
                subtitle: '+5% from last month',
                icon: Icons.people,
                iconColor: const Color(0xFF3B82F6),
              ),
            ),
            SizedBox(
              width: constraints.maxWidth >= 1200 
                ? (constraints.maxWidth - 72) / 4 // 4 columns with spacing
                : constraints.maxWidth >= 900 
                  ? (constraints.maxWidth - 24) / 2 // 2 columns with spacing
                  : constraints.maxWidth, // 1 column
              child: _buildKPICard(
                title: 'Total Bookings',
                value: '168',
                subtitle: '+8% from last year',
                icon: Icons.calendar_today,
                iconColor: const Color(0xFF7C3AED),
              ),
            ),
            SizedBox(
              width: constraints.maxWidth >= 1200 
                ? (constraints.maxWidth - 72) / 4 // 4 columns with spacing
                : constraints.maxWidth >= 900 
                  ? (constraints.maxWidth - 24) / 2 // 2 columns with spacing
                  : constraints.maxWidth, // 1 column
              child: _buildKPIGradientCard(
                title: 'Avg Daily Rate',
                value: '\$156',
                subtitle: '-3% from last month',
              ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use column layout on smaller screens (like React's grid-cols-1 lg:grid-cols-2)
        if (constraints.maxWidth < 1024) {
          return Column(
            children: [
              _buildRevenueChart(),
              const SizedBox(height: 32),
              _buildBookingSourcesChart(),
            ],
          );
        }
        // Use row layout on larger screens
        return Row(
          children: [
            Expanded(child: _buildRevenueChart()),
            const SizedBox(width: 32),
            Expanded(child: _buildBookingSourcesChart()),
          ],
        );
      },
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
            height: 300,
            child: _buildSimpleLineChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 1000,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
              dashArray: [3, 3],
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
              dashArray: [3, 3],
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value.toInt() >= 0 && value.toInt() < monthlyRevenue.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      monthlyRevenue[value.toInt()]['month'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1000,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  '\$${(value / 1000).toStringAsFixed(1)}k',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                  ),
                );
              },
              reservedSize: 42,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            left: BorderSide(color: Colors.grey.withOpacity(0.6)),
            bottom: BorderSide(color: Colors.grey.withOpacity(0.6)),
          ),
        ),
        minX: 0,
        maxX: (monthlyRevenue.length - 1).toDouble(),
        minY: 2000,
        maxY: 5000,
        lineBarsData: [
          LineChartBarData(
            spots: monthlyRevenue.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value['revenue'].toDouble());
            }).toList(),
            isCurved: false,
            color: const Color(0xFF10B981),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: const Color(0xFF10B981),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.black87,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                final index = flSpot.x.toInt();
                if (index >= 0 && index < monthlyRevenue.length) {
                  final data = monthlyRevenue[index];
                  return LineTooltipItem(
                    '${data['month']}\n',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    children: [
                      TextSpan(
                        text: 'Revenue: \$${data['revenue']}\n',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextSpan(
                        text: 'Bookings: ${data['bookings']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  );
                }
                return null;
              }).toList();
            },
          ),
          touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
            // Handle touch events if needed
          },
          handleBuiltInTouches: true,
        ),
      ),
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
            height: 300,
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
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 0,
              sections: bookingSources.map((source) {
                return PieChartSectionData(
                  color: source['color'],
                  value: source['value'].toDouble(),
                  title: '${source['value']}%',
                  radius: 80,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  badgeWidget: null,
                );
              }).toList(),
              pieTouchData: PieTouchData(
                enabled: true,
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  // Handle pie chart touch events
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
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
                  const SizedBox(width: 6),
                  Text(
                    '${source['name']} ${source['value']}%',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
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
    return Column(
      children: [
        _buildRoomPerformanceChart(),
        const SizedBox(height: 32),
        _buildKPIMetrics(),
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
            height: 220,
            child: _buildBarChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.black87,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final data = roomPerformance[group.x.toInt()];
              return BarTooltipItem(
                '${data['room']}\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                children: [
                  TextSpan(
                    text: 'Occupancy: ${data['occupancy']}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value.toInt() >= 0 && value.toInt() < roomPerformance.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      roomPerformance[value.toInt()]['room'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return Container();
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 25,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  '${value.toInt()}%',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            left: BorderSide(color: Colors.grey.withOpacity(0.6)),
            bottom: BorderSide(color: Colors.grey.withOpacity(0.6)),
          ),
        ),
        barGroups: roomPerformance.asMap().entries.map((entry) {
          final index = entry.key;
          final room = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: room['occupancy'].toDouble(),
                color: const Color(0xFF3B82F6),
                width: 20,
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ],
          );
        }).toList(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
              dashArray: [3, 3],
            );
          },
        ),
      ),
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
