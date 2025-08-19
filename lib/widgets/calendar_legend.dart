import 'package:flutter/material.dart';

class CalendarLegend extends StatelessWidget {
  final List<CalendarLegendItem> items;

  const CalendarLegend({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items.map((item) => Padding(
        padding: EdgeInsets.only(right: items.last == item ? 0 : 16),
        child: _LegendItem(
          color: item.color,
          label: item.label,
          isCircle: item.isCircle,
        ),
      )).toList(),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isCircle;

  const _LegendItem({
    required this.color,
    required this.label,
    this.isCircle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isCircle ? null : BorderRadius.circular(2),
            border: label == 'Today'
                ? Border.all(color: Colors.blue.shade200)
                : null,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}

class CalendarLegendItem {
  final Color color;
  final String label;
  final bool isCircle;

  const CalendarLegendItem({
    required this.color,
    required this.label,
    this.isCircle = true,
  });
}
