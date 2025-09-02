import 'package:flutter/material.dart';
import 'status_indicators.dart';
import 'restock_alert.dart';

class InventoryItemCard extends StatelessWidget {
  final String name;
  final int quantity;
  final int minQuantity;
  final String unit;
  final String status;
  final VoidCallback onDelete;

  const InventoryItemCard({
    super.key,
    required this.name,
    required this.quantity,
    required this.minQuantity,
    required this.unit,
    required this.status,
    required this.onDelete,
  });

  IconData _statusIcon(String status) {
    switch (status) {
      case 'good':
        return Icons.check_circle;
      case 'low':
        return Icons.warning_amber_rounded;
      case 'critical':
        return Icons.warning_amber_rounded;
      default:
        return Icons.inventory_2;
    }
  }

  Color _statusTextColor(String status) {
    switch (status) {
      case 'good':
        return const Color(0xFF065F46); // green-800
      case 'low':
        return const Color(0xFF92400E); // yellow-800
      case 'critical':
        return const Color(0xFF991B1B); // red-800
      default:
        return const Color(0xFF1F2937); // gray-800
    }
  }

  double _progress(int quantity, int minQuantity) {
    if (minQuantity <= 0) return 1.0;
    final v = quantity / minQuantity;
    return v.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white.withOpacity(0.8),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  _statusIcon(status),
                  size: 16,
                  color: _statusTextColor(status),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  padding: EdgeInsets.zero,
                  tooltip: 'Delete',
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Stock Level',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                ItemStatusChip(status: status),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current: $quantity $unit',
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
                Text(
                  'Min: $minQuantity $unit',
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ProgressBar(
              progress: _progress(quantity, minQuantity),
              status: status,
            ),
            const SizedBox(height: 8),
            RestockAlert(
              currentQuantity: quantity,
              minQuantity: minQuantity,
              unit: unit,
            ),
          ],
        ),
      ),
    );
  }
}
