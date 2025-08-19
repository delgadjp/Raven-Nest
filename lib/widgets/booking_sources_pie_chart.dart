import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BookingSourcesPieChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final double radius;
  final bool showLegend;

  const BookingSourcesPieChart({
    super.key,
    required this.data,
    this.radius = 80,
    this.showLegend = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 0,
              sections: data.map((source) {
                return PieChartSectionData(
                  color: source['color'] ?? Colors.blue,
                  value: (source['value'] ?? 0).toDouble(),
                  title: '${source['value'] ?? 0}%',
                  radius: radius,
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
        if (showLegend) ...[
          const SizedBox(height: 16),
          _buildLegend(),
        ],
      ],
    );
  }

  Widget _buildLegend() {
    return Wrap(
      alignment: WrapAlignment.center,
      children: data.map((source) {
        return Padding(
          padding: const EdgeInsets.only(right: 16, bottom: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: source['color'] ?? Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${source['name'] ?? ''} ${source['value'] ?? 0}%',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
