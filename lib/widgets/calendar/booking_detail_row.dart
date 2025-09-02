import 'package:flutter/material.dart';

class BookingDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const BookingDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.green.shade600 : Colors.grey.shade900,
          ),
        ),
      ],
    );
  }
}
