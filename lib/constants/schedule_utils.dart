import 'package:flutter/material.dart';

class ScheduleUtils {
  static Color getTaskPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return const Color(0xFFEF4444);
      case 'medium':
        return const Color(0xFFF59E0B);
      case 'low':
        return const Color(0xFF10B981);
      default:
        return Colors.grey;
    }
  }

  static Color getTaskStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF10B981);
      case 'in_progress':
        return const Color(0xFF3B82F6);
      case 'pending':
        return const Color(0xFFF59E0B);
      default:
        return Colors.grey;
    }
  }

  static String formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  static String formatTime(DateTime date) {
    final hour = date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  static String formatDateTime(DateTime date) {
    return '${formatDate(date)} at ${formatTime(date)}';
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day;
  }

  static String getRelativeDateString(DateTime date) {
    if (isToday(date)) {
      return 'Today';
    } else if (isTomorrow(date)) {
      return 'Tomorrow';
    }
    return formatDate(date);
  }

  static IconData getTaskTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'checkout_cleaning':
        return Icons.cleaning_services;
      case 'maintenance':
        return Icons.build;
      case 'room_service':
        return Icons.room_service;
      case 'checkin_preparation':
        return Icons.bed;
      case 'inspection':
        return Icons.search;
      default:
        return Icons.task;
    }
  }

  static String getTaskTypeDisplayName(String type) {
    switch (type.toLowerCase()) {
      case 'checkout_cleaning':
        return 'Checkout Cleaning';
      case 'maintenance':
        return 'Maintenance';
      case 'room_service':
        return 'Room Service';
      case 'checkin_preparation':
        return 'Check-in Preparation';
      case 'inspection':
        return 'Inspection';
      default:
        return type.replaceAll('_', ' ').toUpperCase();
    }
  }

  static IconData getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Icons.priority_high;
      case 'medium':
        return Icons.remove;
      case 'low':
        return Icons.keyboard_arrow_down;
      default:
        return Icons.help_outline;
    }
  }

  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'in_progress':
        return Icons.refresh;
      case 'pending':
        return Icons.pending;
      default:
        return Icons.help_outline;
    }
  }

  static List<Map<String, dynamic>> sortTasksByDateTime(List<Map<String, dynamic>> tasks) {
    final sortedTasks = List<Map<String, dynamic>>.from(tasks);
    sortedTasks.sort((a, b) => (a['dueDate'] as DateTime).compareTo(b['dueDate'] as DateTime));
    return sortedTasks;
  }

  static Map<String, List<Map<String, dynamic>>> groupTasksByDate(List<Map<String, dynamic>> tasks) {
    final tasksByDate = <String, List<Map<String, dynamic>>>{};
    
    for (var task in tasks) {
      final date = formatDate(task['dueDate'] as DateTime);
      if (!tasksByDate.containsKey(date)) {
        tasksByDate[date] = [];
      }
      tasksByDate[date]!.add(task);
    }
    
    return tasksByDate;
  }

  static int getTaskCountByStatus(List<Map<String, dynamic>> tasks, String status) {
    return tasks.where((task) => task['status'] == status).length;
  }

  static int getTaskCountByPriority(List<Map<String, dynamic>> tasks, String priority) {
    return tasks.where((task) => task['priority'] == priority).length;
  }

  static List<Map<String, dynamic>> filterTasksByStatus(List<Map<String, dynamic>> tasks, String status) {
    return tasks.where((task) => task['status'] == status).toList();
  }

  static List<Map<String, dynamic>> filterTasksByPriority(List<Map<String, dynamic>> tasks, String priority) {
    return tasks.where((task) => task['priority'] == priority).toList();
  }

  static List<Map<String, dynamic>> getTasksForDate(List<Map<String, dynamic>> tasks, DateTime date) {
    return tasks.where((task) {
      final taskDate = task['dueDate'] as DateTime;
      return taskDate.year == date.year && 
             taskDate.month == date.month && 
             taskDate.day == date.day;
    }).toList();
  }

  static List<Map<String, dynamic>> getTodaysTasks(List<Map<String, dynamic>> tasks) {
    return getTasksForDate(tasks, DateTime.now());
  }

  static List<Map<String, dynamic>> getUpcomingTasks(List<Map<String, dynamic>> tasks) {
    final now = DateTime.now();
    return tasks.where((task) => (task['dueDate'] as DateTime).isAfter(now)).toList();
  }

  static List<Map<String, dynamic>> getOverdueTasks(List<Map<String, dynamic>> tasks) {
    final now = DateTime.now();
    return tasks.where((task) {
      final dueDate = task['dueDate'] as DateTime;
      return dueDate.isBefore(now) && task['status'] != 'completed';
    }).toList();
  }
}
