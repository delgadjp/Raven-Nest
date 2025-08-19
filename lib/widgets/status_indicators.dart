import 'package:flutter/material.dart';

class ItemStatusChip extends StatelessWidget {
  final String status;

  const ItemStatusChip({
    super.key,
    required this.status,
  });

  Color _statusBgColor(String status) {
    switch (status) {
      case 'good':
        return const Color(0xFFD1FAE5); // green-100
      case 'low':
        return const Color(0xFFFEF3C7); // yellow-100
      case 'critical':
        return const Color(0xFFFEE2E2); // red-100
      default:
        return const Color(0xFFF3F4F6); // gray-100
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _statusBgColor(status),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          color: _statusTextColor(status),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  final double progress;
  final String status;
  final double height;

  const ProgressBar({
    super.key,
    required this.progress,
    required this.status,
    this.height = 6,
  });

  Color _getProgressColor(String status) {
    switch (status) {
      case 'good':
        return const Color(0xFF22C55E);
      case 'low':
        return const Color(0xFFF59E0B);
      case 'critical':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF9CA3AF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: height,
        backgroundColor: Colors.black12,
        valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor(status)),
      ),
    );
  }
}
