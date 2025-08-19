import 'package:flutter/material.dart';

class HousekeepingHelpers {
  static Color getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green.shade600;
      case 'in_progress':
        return Colors.blue.shade600;
      case 'pending':
        return Colors.orange.shade600;
      case 'scheduled':
        return Colors.purple.shade600;
      case 'overdue':
        return Colors.red.shade600;
      case 'available':
        return Colors.green.shade600;
      case 'busy':
        return Colors.red.shade600;
      case 'offline':
        return Colors.grey.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  static Color getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red.shade600;
      case 'medium':
        return Colors.orange.shade600;
      case 'low':
        return Colors.green.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  static IconData getTypeIcon(String type) {
    switch (type) {
      case 'checkout_cleaning':
        return Icons.check_circle;
      case 'maintenance':
        return Icons.warning_amber_rounded;
      case 'room_service':
        return Icons.room_service_outlined;
      default:
        return Icons.access_time;
    }
  }

  static String formatTaskType(String type) {
    return type.replaceAll('_', ' ');
  }

  static String formatStatus(String status) {
    return status.replaceAll('_', ' ');
  }
}
