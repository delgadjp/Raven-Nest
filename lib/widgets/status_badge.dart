import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final EdgeInsets padding;

  const StatusBadge({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.fontSize = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}

class BookingStatusHelper {
  static Color getSourceColor(String source) {
    switch (source) {
      case 'Airbnb':
        return Colors.red.shade100;
      case 'Booking.com':
        return Colors.blue.shade100;
      case 'Direct':
        return Colors.green.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  static Color getSourceTextColor(String source) {
    switch (source) {
      case 'Airbnb':
        return Colors.red.shade800;
      case 'Booking.com':
        return Colors.blue.shade800;
      case 'Direct':
        return Colors.green.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  static Color getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green.shade100;
      case 'pending':
        return Colors.yellow.shade100;
      case 'cancelled':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  static Color getStatusTextColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green.shade800;
      case 'pending':
        return Colors.yellow.shade800;
      case 'cancelled':
        return Colors.red.shade800;
      default:
        return Colors.grey.shade800;
    }
  }
}
