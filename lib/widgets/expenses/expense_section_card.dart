import 'package:flutter/material.dart';

class ExpenseSectionCard extends StatelessWidget {
  final String title;
  final String description;
  final Color dotColor;
  final List<Widget> children;
  final Widget? actionButton;
  final String totalLabel;
  final String totalAmount;
  final Color totalAmountColor;

  const ExpenseSectionCard({
    super.key,
    required this.title,
    required this.description,
    required this.dotColor,
    required this.children,
    this.actionButton,
    required this.totalLabel,
    required this.totalAmount,
    required this.totalAmountColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: dotColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
            if (actionButton != null) ...[
              const SizedBox(height: 12),
              actionButton!,
            ],
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  totalLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const Spacer(),
                Text(
                  totalAmount,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: totalAmountColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
