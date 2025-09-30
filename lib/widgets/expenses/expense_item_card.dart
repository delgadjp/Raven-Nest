import 'package:flutter/material.dart';

class ExpenseItemCard extends StatelessWidget {
  final String name;
  final double amount;
  final bool showDeleteButton;
  final VoidCallback? onDelete;
  final Color amountColor;

  const ExpenseItemCard({
    super.key,
    required this.name,
    required this.amount,
    this.showDeleteButton = false,
    this.onDelete,
    this.amountColor = const Color(0xFF2563EB),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            "\$${amount.toStringAsFixed(0)}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: amountColor,
            ),
          ),
          if (showDeleteButton && onDelete != null) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete,
                size: 18,
                color: Color(0xFFEF4444),
              ),
              tooltip: 'Remove',
            ),
          ],
        ],
      ),
    );
  }
}
