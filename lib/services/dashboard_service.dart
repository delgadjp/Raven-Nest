// Dashboard Service - Fetches dashboard data from Supabase
// This service handles all dashboard-specific database queries

import 'package:flutter/material.dart';
import 'supabase_service.dart';
import 'pricing_service.dart';

class DashboardService {
  static final DashboardService _instance = DashboardService._internal();
  factory DashboardService() => _instance;
  DashboardService._internal();

  // Supabase client reference
  static get _client => SupabaseService.client;

  // Summary Cards Data
  Future<Map<String, dynamic>> getSummaryData({DateTimeRange? range}) async {
    try {
  // Determine current context (kept for potential future use)
  // final now = DateTime.now();

      // Monthly Expenses - sum from expenses table for current month
      double monthlyExpenses = 0.0;
      if (range == null) {
        // All time: sum all expenses
        final expensesResponse = await _client
            .from('expenses')
            .select('amount');
        monthlyExpenses = (expensesResponse as List).fold<double>(
          0.0,
          (sum, item) => sum + (item['amount'] ?? 0.0),
        );
      } else {
        // Sum expenses across months overlapping the range using month/year fields
        final months = _monthsInRange(range);
        for (final m in months) {
          final expensesResponse = await _client
              .from('expenses')
              .select('amount')
              .eq('month', m['month'])
              .eq('year', m['year']);
          monthlyExpenses += (expensesResponse as List).fold<double>(
            0.0,
            (sum, item) => sum + (item['amount'] ?? 0.0),
          );
        }
      }

      // Active Bookings - count confirmed bookings this month
      dynamic bookingsResponse;
      if (range == null) {
        bookingsResponse = await _client
            .from('bookings')
            .select()
            .eq('status', 'confirmed');
      } else {
        bookingsResponse = await _client
            .from('bookings')
            .select()
            .eq('status', 'confirmed')
            .gte('check_in', _isoDate(range.start))
            .lt('check_in', _isoDate(range.end));
      }

      // Inventory Items - total count
      final inventoryResponse = await _client
          .from('inventory_items')
          .select();

      // Pending Tasks - housekeeping tasks with status 'pending'
      final tasksResponse = await _client
          .from('housekeeping_tasks')
          .select()
          .eq('status', 'pending');

      // Total Revenue - compute from bookings (fallback to pricing rules if amount missing)
    dynamic bookingsForRevenueQuery = _client
      .from('bookings')
      .select('id, check_in, check_out, status, total_amount, source_id')
      .not('status', 'eq', 'cancelled');

    if (range != null) {
    bookingsForRevenueQuery = bookingsForRevenueQuery
      .gte('check_in', _isoDate(range.start))
      .lt('check_in', _isoDate(range.end));
    }
    final bookingsForRevenue = await bookingsForRevenueQuery;

      double totalRevenue = 0.0;
      final Map<String, String> sourceNameCache = {};
      for (final booking in bookingsForRevenue) {
        final amount = booking['total_amount'];
        if (amount is num && amount > 0) {
          totalRevenue += amount.toDouble();
          continue;
        }

        try {
          final checkIn = DateTime.parse(booking['check_in']);
          final checkOut = DateTime.parse(booking['check_out']);
          String sourceName = 'Unknown';
          final sourceId = booking['source_id'];
          if (sourceId != null) {
            if (sourceNameCache.containsKey(sourceId)) {
              sourceName = sourceNameCache[sourceId]!;
            } else {
              try {
                final s = await _client
                    .from('booking_sources')
                    .select('name')
                    .eq('id', sourceId)
                    .single();
                sourceName = (s['name'] ?? 'Unknown').toString();
                sourceNameCache[sourceId] = sourceName;
              } catch (_) {}
            }
          }
          final computed = PricingService.computeTotalAmount(
            sourceName: sourceName,
            checkIn: checkIn,
            checkOut: checkOut,
          );
          if (computed != null && computed > 0) {
            totalRevenue += computed;
          }
        } catch (_) {}
      }

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
  Future<List<Map<String, dynamic>>> getMonthlyRevenueData({int? year}) async {
    try {
      final currentYear = year ?? DateTime.now().year;

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
  Future<List<Map<String, dynamic>>> getBookingSourcesData({DateTimeRange? range}) async {
    try {
      // Get booking sources with their booking counts
      final sourcesResponse = await _client
          .from('booking_sources')
          .select('id, name, color');

      final result = <Map<String, dynamic>>[];
      
      for (var source in sourcesResponse) {
        // Count bookings for each source
    dynamic bookingsQuery = _client
      .from('bookings')
      .select('id')
      .eq('source_id', source['id']);
    if (range != null) {
      bookingsQuery = bookingsQuery
        .gte('check_in', _isoDate(range.start))
        .lt('check_in', _isoDate(range.end));
    }
    final bookingsCount = await bookingsQuery;

        result.add({
          'name': source['name'],
          'value': (bookingsCount as List).length,
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
  Future<List<Map<String, dynamic>>> getRecentActivityData({int limit = 3, DateTimeRange? range}) async {
    try {
      // Build base filterable query first (PostgrestFilterBuilder) so we can apply range filters
      var notificationsQuery = _client
          .from('notifications')
          .select('''
            type,
            title,
            message,
            priority,
            created_at,
            related_booking,
            related_task,
            related_item
          ''');

      if (range != null) {
        notificationsQuery = notificationsQuery
            .gte('created_at', range.start.toIso8601String())
            .lt('created_at', range.end.toIso8601String());
      }
      // Apply ordering/limit after filters to return a transform builder finally executed
      final notificationsData = await notificationsQuery
          .order('created_at', ascending: false)
          .limit(limit);

      // For each notification, get related data if needed
      final enrichedData = <Map<String, dynamic>>[];
      
      for (var notification in notificationsData) {
        Map<String, dynamic>? bookingData;
        Map<String, dynamic>? taskData;
        Map<String, dynamic>? itemData;

        // Get related booking data if exists
        if (notification['related_booking'] != null) {
          final bookingResponse = await _client
              .from('bookings')
              .select('check_in, check_out, status, total_amount')
              .eq('id', notification['related_booking'])
              .single();
          bookingData = bookingResponse;
        }

        // Get related task data if exists
        if (notification['related_task'] != null) {
          final taskResponse = await _client
              .from('housekeeping_tasks')
              .select('room_number, task_type, status')
              .eq('id', notification['related_task'])
              .single();
          taskData = taskResponse;
        }

        // Get related item data if exists
        if (notification['related_item'] != null) {
          final itemResponse = await _client
              .from('inventory_items')
              .select('name, current_stock, min_stock')
              .eq('id', notification['related_item'])
              .single();
          itemData = itemResponse;
        }

        enrichedData.add({
          'type': notification['type'],
          'title': notification['title'],
          'message': notification['message'],
          'priority': notification['priority'],
          'created_at': notification['created_at'],
          'related_booking': notification['related_booking'],
          'related_task': notification['related_task'],
          'related_item': notification['related_item'],
          'booking_data': bookingData,
          'task_data': taskData,
          'item_data': itemData,
        });
      }

      return enrichedData;
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

  // Helper: format YYYY-MM-DD
  String _isoDate(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  // Helper: list of month/year pairs within a range (inclusive of start month, exclusive of end if same month)
  List<Map<String, int>> _monthsInRange(DateTimeRange range) {
    final List<Map<String, int>> list = [];
    var y = range.start.year;
    var m = range.start.month;
    // Use end at start of end month to make end exclusive
    final endY = range.end.year;
    final endM = range.end.month;

    while (y < endY || (y == endY && m <= endM)) {
      list.add({'year': y, 'month': m});
      if (y == endY && m == endM) break;
      m += 1;
      if (m > 12) {
        m = 1;
        y += 1;
      }
    }
    return list;
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
