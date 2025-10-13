import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class RevenueLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final Color lineColor;
  final double lineWidth;

  const RevenueLineChart({
    super.key,
    required this.data,
    this.lineColor = const Color(0xFF10B981),
    this.lineWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    // Use Philippine Peso formatting to match the rest of the dashboard
    final NumberFormat pesoFormat = NumberFormat.currency(
      locale: 'en_PH',
      symbol: '₱',
      decimalDigits: 0,
    );
    final NumberFormat compactPesoFormat = NumberFormat.compactCurrency(
      locale: 'en_PH',
      symbol: '₱',
      decimalDigits: 0,
    );

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: _getYAxisInterval(),
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
                if (value.toInt() >= 0 && value.toInt() < data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      data[value.toInt()]['month'] ?? '',
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
              interval: _getYAxisInterval(),
              getTitlesWidget: (double value, TitleMeta meta) {
                // Only show titles for values that are multiples of the interval and within our range
                if (value >= _getMinValue() && value <= _getMaxValue()) {
                  return Text(
                    compactPesoFormat.format(value),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                    ),
                  );
                }
                return Container();
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
        maxX: (data.length - 1).toDouble(),
        minY: _getMinValue(),
        maxY: _getMaxValue(),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((entry) {
              return FlSpot(
                entry.key.toDouble(),
                (entry.value['revenue'] ?? 0).toDouble(),
              );
            }).toList(),
            isCurved: false,
            color: lineColor,
            barWidth: lineWidth,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: lineColor,
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
                if (index >= 0 && index < data.length) {
                  final dataPoint = data[index];
                  return LineTooltipItem(
                    '${dataPoint['month'] ?? ''}\n',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    children: [
                      TextSpan(
                        text: 'Revenue: ${pesoFormat.format((dataPoint['revenue'] ?? 0) as num)}\n',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      if (dataPoint['bookings'] != null)
                        TextSpan(
                          text: 'Bookings: ${dataPoint['bookings']}',
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

  double _getYAxisInterval() {
    final range = _getMaxValue() - _getMinValue();
    if (range <= 2000) return 500;
    if (range <= 5000) return 1000;
    if (range <= 10000) return 2000;
    return 5000;
  }

  double _getMinValue() {
    if (data.isEmpty) return 0;
    final minRevenue = data
        .map((e) => (e['revenue'] ?? 0).toDouble())
        .reduce((a, b) => a < b ? a : b);
    
    // Round down to nearest 1000
    return (minRevenue / 1000).floor() * 1000.0;
  }

  double _getMaxValue() {
    if (data.isEmpty) return 5000;
    final maxRevenue = data
        .map((e) => (e['revenue'] ?? 0).toDouble())
        .reduce((a, b) => a > b ? a : b);
    
    // Round up to nearest 1000 and add some padding
    return ((maxRevenue / 1000).ceil() + 1) * 1000.0;
  }
}
