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
    return InteractiveLineChart(data: monthlyRevenue);
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
    // Chart margins
    const double leftMargin = 50;
    const double rightMargin = 20;
    const double topMargin = 20;
    const double bottomMargin = 40;
    
    final chartWidth = size.width - leftMargin - rightMargin;
    final chartHeight = size.height - topMargin - bottomMargin;
    
    // Calculate data bounds
    final maxRevenue = data.map((e) => e['revenue'] as int).reduce((a, b) => a > b ? a : b);
    final minRevenue = data.map((e) => e['revenue'] as int).reduce((a, b) => a < b ? a : b);
    final revenueRange = maxRevenue - minRevenue;
    
    // Draw grid lines (dashed)
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    // Horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final y = topMargin + (i * chartHeight / 4);
      _drawDashedLine(canvas, Offset(leftMargin, y), Offset(leftMargin + chartWidth, y), gridPaint);
    }
    
    // Vertical grid lines
    for (int i = 0; i < data.length; i++) {
      final x = leftMargin + (i * chartWidth / (data.length - 1));
      _drawDashedLine(canvas, Offset(x, topMargin), Offset(x, topMargin + chartHeight), gridPaint);
    }
    
    // Draw axes
    final axisPaint = Paint()
      ..color = Colors.grey.withOpacity(0.6)
      ..strokeWidth = 1;
    
    // Y-axis
    canvas.drawLine(
      Offset(leftMargin, topMargin),
      Offset(leftMargin, topMargin + chartHeight),
      axisPaint,
    );
    
    // X-axis
    canvas.drawLine(
      Offset(leftMargin, topMargin + chartHeight),
      Offset(leftMargin + chartWidth, topMargin + chartHeight),
      axisPaint,
    );
    
    // Draw Y-axis labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    for (int i = 0; i <= 4; i++) {
      final value = maxRevenue - (i * revenueRange / 4);
      final y = topMargin + (i * chartHeight / 4);
      
      textPainter.text = TextSpan(
        text: '\$${(value / 1000).toStringAsFixed(1)}k',
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 11,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(leftMargin - textPainter.width - 8, y - textPainter.height / 2));
    }
    
    // Draw X-axis labels
    for (int i = 0; i < data.length; i++) {
      final x = leftMargin + (i * chartWidth / (data.length - 1));
      final month = data[i]['month'] as String;
      
      textPainter.text = TextSpan(
        text: month,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 11,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, topMargin + chartHeight + 8));
    }
    
    // Draw the line path
    final linePaint = Paint()
      ..color = const Color(0xFF10B981)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final points = <Offset>[];
    
    for (int i = 0; i < data.length; i++) {
      final x = leftMargin + (i * chartWidth / (data.length - 1));
      final normalizedValue = ((data[i]['revenue'] as int) - minRevenue) / revenueRange;
      final y = topMargin + chartHeight - (normalizedValue * chartHeight);
      
      points.add(Offset(x, y));
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);
    
    // Draw data points
    final pointPaint = Paint()
      ..color = const Color(0xFF10B981)
      ..style = PaintingStyle.fill;
    
    final pointBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    for (final point in points) {
      // Draw white border
      canvas.drawCircle(point, 6, pointBorderPaint);
      // Draw colored point
      canvas.drawCircle(point, 4, pointPaint);
    }
  }
  
  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 3.0;
    const dashSpace = 3.0;
    
    final distance = (end - start).distance;
    final normalizedDistance = distance / (dashWidth + dashSpace);
    
    for (int i = 0; i < normalizedDistance.floor(); i++) {
      final startPos = start + (end - start) * (i * (dashWidth + dashSpace)) / distance;
      final endPos = start + (end - start) * (i * (dashWidth + dashSpace) + dashWidth) / distance;
      canvas.drawLine(startPos, endPos, paint);
    }
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

// Interactive Line Chart Widget
class InteractiveLineChart extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const InteractiveLineChart({super.key, required this.data});

  @override
  State<InteractiveLineChart> createState() => _InteractiveLineChartState();
}

class _InteractiveLineChartState extends State<InteractiveLineChart> {
  int? hoveredIndex;
  Offset? hoverPosition;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onPanUpdate: (details) {
            _handleHover(details.localPosition);
          },
          onPanEnd: (_) {
            setState(() {
              hoveredIndex = null;
              hoverPosition = null;
            });
          },
          onTapDown: (details) {
            _handleHover(details.localPosition);
          },
          child: CustomPaint(
            size: const Size(double.infinity, 300),
            painter: InteractiveLineChartPainter(
              widget.data,
              hoveredIndex: hoveredIndex,
            ),
          ),
        ),
        if (hoveredIndex != null && hoverPosition != null)
          Positioned(
            left: hoverPosition!.dx - 60,
            top: hoverPosition!.dy - 80,
            child: _buildTooltip(),
          ),
      ],
    );
  }

  void _handleHover(Offset position) {
    const double leftMargin = 50;
    const double rightMargin = 20;
    
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final chartWidth = renderBox.size.width - leftMargin - rightMargin;
    final dataPointWidth = chartWidth / (widget.data.length - 1);
    
    if (position.dx >= leftMargin && position.dx <= renderBox.size.width - rightMargin) {
      final relativeX = position.dx - leftMargin;
      final index = (relativeX / dataPointWidth).round();
      
      if (index >= 0 && index < widget.data.length) {
        setState(() {
          hoveredIndex = index;
          hoverPosition = position;
        });
      }
    }
  }

  Widget _buildTooltip() {
    if (hoveredIndex == null) return const SizedBox.shrink();
    
    final data = widget.data[hoveredIndex!];
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['month'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Revenue: \$${data['revenue']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF3B82F6),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Bookings: ${data['bookings']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Enhanced Interactive Line Chart Painter
class InteractiveLineChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final int? hoveredIndex;

  InteractiveLineChartPainter(this.data, {this.hoveredIndex});

  @override
  void paint(Canvas canvas, Size size) {
    // Chart margins
    const double leftMargin = 50;
    const double rightMargin = 20;
    const double topMargin = 20;
    const double bottomMargin = 40;
    
    final chartWidth = size.width - leftMargin - rightMargin;
    final chartHeight = size.height - topMargin - bottomMargin;
    
    // Calculate data bounds
    final maxRevenue = data.map((e) => e['revenue'] as int).reduce((a, b) => a > b ? a : b);
    final minRevenue = data.map((e) => e['revenue'] as int).reduce((a, b) => a < b ? a : b);
    final revenueRange = maxRevenue - minRevenue;
    
    // Draw grid lines (dashed)
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    // Horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final y = topMargin + (i * chartHeight / 4);
      _drawDashedLine(canvas, Offset(leftMargin, y), Offset(leftMargin + chartWidth, y), gridPaint);
    }
    
    // Vertical grid lines
    for (int i = 0; i < data.length; i++) {
      final x = leftMargin + (i * chartWidth / (data.length - 1));
      _drawDashedLine(canvas, Offset(x, topMargin), Offset(x, topMargin + chartHeight), gridPaint);
    }
    
    // Draw axes
    final axisPaint = Paint()
      ..color = Colors.grey.withOpacity(0.6)
      ..strokeWidth = 1;
    
    // Y-axis
    canvas.drawLine(
      Offset(leftMargin, topMargin),
      Offset(leftMargin, topMargin + chartHeight),
      axisPaint,
    );
    
    // X-axis
    canvas.drawLine(
      Offset(leftMargin, topMargin + chartHeight),
      Offset(leftMargin + chartWidth, topMargin + chartHeight),
      axisPaint,
    );
    
    // Draw Y-axis labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    for (int i = 0; i <= 4; i++) {
      final value = maxRevenue - (i * revenueRange / 4);
      final y = topMargin + (i * chartHeight / 4);
      
      textPainter.text = TextSpan(
        text: '\$${(value / 1000).toStringAsFixed(1)}k',
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 11,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(leftMargin - textPainter.width - 8, y - textPainter.height / 2));
    }
    
    // Draw X-axis labels
    for (int i = 0; i < data.length; i++) {
      final x = leftMargin + (i * chartWidth / (data.length - 1));
      final month = data[i]['month'] as String;
      
      textPainter.text = TextSpan(
        text: month,
        style: TextStyle(
          color: hoveredIndex == i ? const Color(0xFF10B981) : Colors.grey,
          fontSize: 11,
          fontWeight: hoveredIndex == i ? FontWeight.bold : FontWeight.normal,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, topMargin + chartHeight + 8));
    }
    
    // Draw the line path
    final linePaint = Paint()
      ..color = const Color(0xFF10B981)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final points = <Offset>[];
    
    for (int i = 0; i < data.length; i++) {
      final x = leftMargin + (i * chartWidth / (data.length - 1));
      final normalizedValue = ((data[i]['revenue'] as int) - minRevenue) / revenueRange;
      final y = topMargin + chartHeight - (normalizedValue * chartHeight);
      
      points.add(Offset(x, y));
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);
    
    // Draw hover line if hovering
    if (hoveredIndex != null) {
      final hoverX = leftMargin + (hoveredIndex! * chartWidth / (data.length - 1));
      final hoverLinePaint = Paint()
        ..color = const Color(0xFF10B981).withOpacity(0.3)
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;
      
      canvas.drawLine(
        Offset(hoverX, topMargin),
        Offset(hoverX, topMargin + chartHeight),
        hoverLinePaint,
      );
    }
    
    // Draw data points
    final pointPaint = Paint()
      ..color = const Color(0xFF10B981)
      ..style = PaintingStyle.fill;
    
    final pointBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      final isHovered = hoveredIndex == i;
      final pointRadius = isHovered ? 7.0 : 4.0;
      final borderRadius = isHovered ? 9.0 : 6.0;
      
      // Draw white border
      canvas.drawCircle(point, borderRadius, pointBorderPaint);
      // Draw colored point
      canvas.drawCircle(point, pointRadius, pointPaint);
      
      // Draw hover effect
      if (isHovered) {
        final hoverPaint = Paint()
          ..color = const Color(0xFF10B981).withOpacity(0.2)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(point, 12, hoverPaint);
      }
    }
  }
  
  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 3.0;
    const dashSpace = 3.0;
    
    final distance = (end - start).distance;
    final normalizedDistance = distance / (dashWidth + dashSpace);
    
    for (int i = 0; i < normalizedDistance.floor(); i++) {
      final startPos = start + (end - start) * (i * (dashWidth + dashSpace)) / distance;
      final endPos = start + (end - start) * (i * (dashWidth + dashSpace) + dashWidth) / distance;
      canvas.drawLine(startPos, endPos, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is InteractiveLineChartPainter) {
      return hoveredIndex != oldDelegate.hoveredIndex;
    }
    return true;
  }
}
