// Dashboard Service - Fetches dashboard data from Supabase
// This service handles all dashboard-specific database queries

import 'package:flutter/material.dart';
import 'supabase_service.dart';

class DashboardService {
  static final DashboardService _instance = DashboardService._internal();
  factory DashboardService() => _instance;
  DashboardService._internal();

  // Supabase client reference
  static get _client => SupabaseService.client;

  // Summary Cards Data
  Future<Map<String, dynamic>> getSummaryData() async {
    try {
      // Get current month and year
      final now = DateTime.now();
      final currentMonth = now.month;
      final currentYear = now.year;

      // Monthly Expenses - sum from expenses table for current month
      final expensesResponse = await _client
          .from('expenses')
          .select('amount')
          .eq('month', currentMonth)
          .eq('year', currentYear);

      final monthlyExpenses = (expensesResponse as List).fold<double>(
        0.0,
        (sum, item) => sum + (item['amount'] ?? 0.0),
      );

      // Active Bookings - count confirmed bookings this month
      final bookingsResponse = await _client
          .from('bookings')
          .select()
          .eq('status', 'confirmed')
          .gte('check_in', '${currentYear}-${currentMonth.toString().padLeft(2, '0')}-01')
          .lt('check_in', '${currentYear}-${(currentMonth + 1).toString().padLeft(2, '0')}-01');

      // Inventory Items - total count
      final inventoryResponse = await _client
          .from('inventory_items')
          .select();

      // Pending Tasks - housekeeping tasks with status 'pending'
      final tasksResponse = await _client
          .from('housekeeping_tasks')
          .select()
          .eq('status', 'pending');

      // Total Revenue - from revenue table for current year
      final revenueResponse = await _client
          .from('revenue')
          .select('net_income')
          .eq('year', currentYear);

      final totalRevenue = (revenueResponse as List).fold<double>(
        0.0,
        (sum, item) => sum + (item['net_income'] ?? 0.0),
      );

      // Unread Notifications
      final notificationsResponse = await _client
          .from('notifications')
          .select()
          .eq('is_read', false);

      return {
        'monthlyExpenses': monthlyExpenses,
        'activeBookings': (bookingsResponse as List).length,
        'inventoryItems': (inventoryResponse as List).length,
        'pendingTasks': (tasksResponse as List).length,
        'totalRevenue': totalRevenue,
        'unreadNotifications': (notificationsResponse as List).length,
      };
    } catch (e) {
      throw Exception('Failed to fetch summary data: $e');
    }
  }

  // Monthly Revenue Chart Data
  Future<List<Map<String, dynamic>>> getMonthlyRevenueData() async {
    try {
      final currentYear = DateTime.now().year;

      // Get revenue data grouped by month
      final revenueData = await _client
          .from('revenue')
          .select('month, net_income, booking_id')
          .eq('year', currentYear)
          .order('month');

      // Group by month and calculate totals
      final monthlyData = <int, Map<String, dynamic>>{};
      
      for (var item in revenueData) {
        final month = item['month'] as int;
        if (!monthlyData.containsKey(month)) {
          monthlyData[month] = {
            'month': _getMonthName(month),
            'revenue': 0.0,
            'bookings': <String>{}, // Use Set to count unique bookings
          };
        }
        
        monthlyData[month]!['revenue'] += (item['net_income'] ?? 0.0);
        if (item['booking_id'] != null) {
          (monthlyData[month]!['bookings'] as Set<String>).add(item['booking_id']);
        }
      }

      // Convert to final format
      final result = <Map<String, dynamic>>[];
      for (int month = 1; month <= 12; month++) {
        final data = monthlyData[month];
        result.add({
          'month': _getMonthName(month),
          'revenue': data?['revenue'] ?? 0.0,
          'bookings': data != null ? (data['bookings'] as Set).length : 0,
        });
      }

      return result;
    } catch (e) {
      throw Exception('Failed to fetch monthly revenue data: $e');
    }
  }

  // Booking Sources Pie Chart Data
  Future<List<Map<String, dynamic>>> getBookingSourcesData() async {
    try {
      final sourcesData = await _client
          .from('booking_sources')
          .select('''
            id,
            name,
            color,
            bookings!inner(id)
          ''');

      final result = <Map<String, dynamic>>[];
      
      for (var source in sourcesData) {
        final bookings = source['bookings'] as List;
        result.add({
          'name': source['name'],
          'value': bookings.length,
          'color': _parseColor(source['color']),
        });
      }

      // Sort by value (highest first)
      result.sort((a, b) => (b['value'] as int).compareTo(a['value'] as int));

      return result;
    } catch (e) {
      throw Exception('Failed to fetch booking sources data: $e');
    }
  }

  // Recent Activity Data (from notifications)
  Future<List<Map<String, dynamic>>> getRecentActivityData({int limit = 3}) async {
    try {
      final notificationsData = await _client
          .from('notifications')
          .select('''
            type,
            title,
            message,
            priority,
            created_at,
            related_booking,
            related_task,
            related_item,
            bookings(check_in, check_out),
            housekeeping_tasks(room_number, task_type),
            inventory_items(name)
          ''')
          .order('created_at', ascending: false)
          .limit(limit);

      return notificationsData.map<Map<String, dynamic>>((item) {
        return {
          'type': item['type'],
          'title': item['title'],
          'message': item['message'],
          'priority': item['priority'],
          'created_at': item['created_at'],
          'related_booking': item['related_booking'],
          'related_task': item['related_task'],
          'related_item': item['related_item'],
          'booking_data': item['bookings'],
          'task_data': item['housekeeping_tasks'],
          'item_data': item['inventory_items'],
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch recent activity data: $e');
    }
  }

  // Helper method to get month name from number
  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  // Helper method to parse color from hex string
  Color _parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) {
      return Colors.grey;
    }
    
    try {
      // Remove # if present
      final cleanColor = colorString.replaceAll('#', '');
      // Add FF for alpha if not present
      final fullColor = cleanColor.length == 6 ? 'FF$cleanColor' : cleanColor;
      return Color(int.parse(fullColor, radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  // Helper method to get activity colors and icons based on type
  Map<String, dynamic> getActivityStyle(String type) {
    switch (type.toLowerCase()) {
      case 'booking':
        return {
          'dotColor': const Color(0xFF3B82F6),
          'backgroundColor': const Color(0xFFEFF6FF),
          'borderColor': const Color(0xFFBFDBFE),
        };
      case 'housekeeping':
      case 'maintenance':
        return {
          'dotColor': const Color(0xFF10B981),
          'backgroundColor': const Color(0xFFECFDF5),
          'borderColor': const Color(0xFFA7F3D0),
        };
      case 'inventory':
        return {
          'dotColor': const Color(0xFFF59E0B),
          'backgroundColor': const Color(0xFFFFF7ED),
          'borderColor': const Color(0xFFFCD34D),
        };
      default:
        return {
          'dotColor': const Color(0xFF6B7280),
          'backgroundColor': const Color(0xFFF9FAFB),
          'borderColor': const Color(0xFFE5E7EB),
        };
    }
  }

  // Helper method to format time ago
  String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }
}
