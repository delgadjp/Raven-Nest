import 'package:flutter/material.dart';
import '../general_widgets/reusable_card.dart';

class ChartContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget chart;
  final double height;
  final List<Widget>? headerActions;

  const ChartContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.chart,
    this.height = 300,
    this.headerActions,
  });

  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              if (headerActions != null && headerActions!.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...headerActions!,
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: height,
            child: chart,
          ),
        ],
      ),
    );
  }
}
