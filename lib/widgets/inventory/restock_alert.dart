import 'package:flutter/material.dart';

class RestockAlert extends StatelessWidget {
  final int currentQuantity;
  final int minQuantity;
  final String unit;

  const RestockAlert({
    super.key,
    required this.currentQuantity,
    required this.minQuantity,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    if (currentQuantity > minQuantity) return const SizedBox.shrink();
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '⚠️ Need to restock: ${minQuantity - currentQuantity} more $unit',
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF9A3412),
        ),
      ),
    );
  }
}
