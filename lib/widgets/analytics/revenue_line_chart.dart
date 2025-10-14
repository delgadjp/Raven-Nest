import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class RevenueLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final Color lineColor;
  final double lineWidth;
  final bool showMovingAverage;
  final int movingAverageWindow; // in points

  const RevenueLineChart({
    super.key,
    required this.data,
    this.lineColor = const Color(0xFF10B981),
    this.lineWidth = 3,
    this.showMovingAverage = true,
    this.movingAverageWindow = 7,
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
              interval: _xLabelInterval(),
              getTitlesWidget: (double value, TitleMeta meta) {
                final i = value.toInt();
                if (i >= 0 && i < data.length) {
                  // Thin labels when dataset is dense
                  if (_shouldSkipLabel(i)) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _labelForIndex(i),
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
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
            isCurved: true,
            color: lineColor,
            barWidth: lineWidth,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: data.length <= 40,
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
          if (showMovingAverage && data.length >= movingAverageWindow)
            LineChartBarData(
              spots: _movingAverageSpots(),
              isCurved: true,
              color: lineColor.withOpacity(0.35),
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
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
                  final label = _labelForIndex(index);
                  final fullDate = dataPoint['date'];
                  final header = (fullDate is String && fullDate.isNotEmpty)
                      ? '$label • ${_fullDateFromIso(fullDate)}\n'
                      : '$label\n';
                  return LineTooltipItem(
                    header,
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

  String _labelForIndex(int index) {
    if (index < 0 || index >= data.length) return '';
    final map = data[index];
    // Prefer generic 'label', fallback to 'month'
    final label = map['label'] ?? map['month'] ?? '';
    return label.toString();
  }

  double _xLabelInterval() {
    final n = data.length;
    if (n <= 12) return 1; // monthly or short series
    if (n <= 30) return 2; // show every 2nd label
    if (n <= 60) return 4;
    return 6; // very dense
  }

  bool _shouldSkipLabel(int index) {
    final n = data.length;
    if (n <= 12) return false;
    if (n <= 30) return index % 2 != 0;
    if (n <= 60) return index % 4 != 0;
    return index % 6 != 0;
  }

  List<FlSpot> _movingAverageSpots() {
  final List<double> y = data
    .map<double>((e) => (e['revenue'] ?? 0).toDouble())
    .toList(growable: false);
    final int w = movingAverageWindow;
    final List<FlSpot> spots = [];
    if (y.isEmpty || w <= 1) return spots;
    double sum = 0;
    for (int i = 0; i < y.length; i++) {
      sum += y[i];
      if (i >= w) sum -= y[i - w];
      if (i >= w - 1) {
        final avg = sum / w;
        spots.add(FlSpot(i.toDouble(), avg));
      }
    }
    return spots;
  }

  String _fullDateFromIso(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return DateFormat('yMMMd').format(dt);
    } catch (_) {
      return iso;
    }
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
