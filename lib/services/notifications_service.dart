import 'package:flutter/material.dart';
import 'supabase_service.dart';
import '/models/notification_model.dart';

class NotificationsService {
  static final _supabase = SupabaseService.client;

  // Get all notifications
  static Future<List<NotificationModel>> getAllNotifications() async {
    try {
      final response = await _supabase
          .from('notifications')
          .select('''
            id,
            type,
            title,
            message,
            priority,
            is_read,
            created_at,
            related_booking,
            related_task,
            related_item
          ''')
          .order('created_at', ascending: false);

      return response.map<NotificationModel>((notification) {
        return NotificationModel(
          id: notification['id'].toString().hashCode, // Convert UUID to int for compatibility
          type: notification['type'] ?? 'system',
          title: notification['title'] ?? 'Notification',
          message: notification['message'] ?? '',
          timestamp: DateTime.parse(notification['created_at']),
          read: notification['is_read'] ?? false,
          priority: notification['priority'] ?? 'medium',
          source: _getSourceFromType(notification['type']),
          icon: _getIconFromType(notification['type']),
        );
      }).toList();
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  // Get unread notifications
  static Future<List<NotificationModel>> getUnreadNotifications() async {
    try {
      final response = await _supabase
          .from('notifications')
          .select('''
            id,
            type,
            title,
            message,
            priority,
            is_read,
            created_at,
            related_booking,
            related_task,
            related_item
          ''')
          .eq('is_read', false)
          .order('created_at', ascending: false);

      return response.map<NotificationModel>((notification) {
        return NotificationModel(
          id: notification['id'].toString().hashCode,
          type: notification['type'] ?? 'system',
          title: notification['title'] ?? 'Notification',
          message: notification['message'] ?? '',
          timestamp: DateTime.parse(notification['created_at']),
          read: notification['is_read'] ?? false,
          priority: notification['priority'] ?? 'medium',
          source: _getSourceFromType(notification['type']),
          icon: _getIconFromType(notification['type']),
        );
      }).toList();
    } catch (e) {
      print('Error fetching unread notifications: $e');
      return [];
    }
  }

  // Get notifications for today
  static Future<List<NotificationModel>> getTodayNotifications() async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      
      final response = await _supabase
          .from('notifications')
          .select('''
            id,
            type,
            title,
            message,
            priority,
            is_read,
            created_at,
            related_booking,
            related_task,
            related_item
          ''')
          .gte('created_at', '${today}T00:00:00')
          .lte('created_at', '${today}T23:59:59')
          .order('created_at', ascending: false);

      return response.map<NotificationModel>((notification) {
        return NotificationModel(
          id: notification['id'].toString().hashCode,
          type: notification['type'] ?? 'system',
          title: notification['title'] ?? 'Notification',
          message: notification['message'] ?? '',
          timestamp: DateTime.parse(notification['created_at']),
          read: notification['is_read'] ?? false,
          priority: notification['priority'] ?? 'medium',
          source: _getSourceFromType(notification['type']),
          icon: _getIconFromType(notification['type']),
        );
      }).toList();
    } catch (e) {
      print('Error fetching today notifications: $e');
      return [];
    }
  }

  // Get notifications by priority
  static Future<List<NotificationModel>> getNotificationsByPriority(String priority) async {
    try {
      final response = await _supabase
          .from('notifications')
          .select('''
            id,
            type,
            title,
            message,
            priority,
            is_read,
            created_at,
            related_booking,
            related_task,
            related_item
          ''')
          .eq('priority', priority)
          .order('created_at', ascending: false);

      return response.map<NotificationModel>((notification) {
        return NotificationModel(
          id: notification['id'].toString().hashCode,
          type: notification['type'] ?? 'system',
          title: notification['title'] ?? 'Notification',
          message: notification['message'] ?? '',
          timestamp: DateTime.parse(notification['created_at']),
          read: notification['is_read'] ?? false,
          priority: notification['priority'] ?? 'medium',
          source: _getSourceFromType(notification['type']),
          icon: _getIconFromType(notification['type']),
        );
      }).toList();
    } catch (e) {
      print('Error fetching notifications by priority: $e');
      return [];
    }
  }

  // Get notifications summary statistics
  static Future<Map<String, dynamic>> getNotificationsSummary() async {
    try {
      // Get total notifications count
      final totalResponse = await _supabase
          .from('notifications')
          .select('id');

      // Get unread notifications count
      final unreadResponse = await _supabase
          .from('notifications')
          .select('id')
          .eq('is_read', false);

      // Get today's notifications count
      final today = DateTime.now().toIso8601String().split('T')[0];
      final todayResponse = await _supabase
          .from('notifications')
          .select('id')
          .gte('created_at', '${today}T00:00:00')
          .lte('created_at', '${today}T23:59:59');

      // Get high priority notifications count
      final highPriorityResponse = await _supabase
          .from('notifications')
          .select('id')
          .eq('priority', 'high');

      return {
        'total': totalResponse.length,
        'unread': unreadResponse.length,
        'today': todayResponse.length,
        'highPriority': highPriorityResponse.length,
      };
    } catch (e) {
      print('Error fetching notifications summary: $e');
      return {
        'total': 0,
        'unread': 0,
        'today': 0,
        'highPriority': 0,
      };
    }
  }

  // Mark notification as read
  static Future<bool> markAsRead(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);
      return true;
    } catch (e) {
      print('Error marking notification as read: $e');
      return false;
    }
  }

  // Mark all notifications as read
  static Future<bool> markAllAsRead() async {
    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('is_read', false);
      return true;
    } catch (e) {
      print('Error marking all notifications as read: $e');
      return false;
    }
  }

  // Delete notification
  static Future<bool> deleteNotification(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .delete()
          .eq('id', notificationId);
      return true;
    } catch (e) {
      print('Error deleting notification: $e');
      return false;
    }
  }

  // Create a new notification
  static Future<bool> createNotification(Map<String, dynamic> notificationData) async {
    try {
      await _supabase.from('notifications').insert(notificationData);
      return true;
    } catch (e) {
      print('Error creating notification: $e');
      return false;
    }
  }

  // Helper method to get source from notification type
  static String _getSourceFromType(String? type) {
    switch (type?.toLowerCase()) {
      case 'booking':
        return 'Booking System';
      case 'checkin':
        return 'System';
      case 'maintenance':
      case 'housekeeping':
        return 'Housekeeping';
      case 'inventory':
        return 'Inventory';
      case 'checkout':
        return 'System';
      case 'payment':
        return 'Payment System';
      case 'review':
        return 'Review System';
      default:
        return 'System';
    }
  }

  // Helper method to get icon from notification type
  static dynamic _getIconFromType(String? type) {
    switch (type?.toLowerCase()) {
      case 'booking':
        return Icons.calendar_today;
      case 'checkin':
        return Icons.home;
      case 'maintenance':
        return Icons.build;
      case 'housekeeping':
        return Icons.cleaning_services;
      case 'inventory':
        return Icons.warning;
      case 'checkout':
        return Icons.person;
      case 'payment':
        return Icons.attach_money;
      case 'review':
        return Icons.message;
      default:
        return Icons.notifications;
    }
  }

  // Get notifications with related data (bookings, tasks, items)
  static Future<List<Map<String, dynamic>>> getNotificationsWithRelatedData() async {
    try {
      final notifications = await _supabase
          .from('notifications')
          .select('*')
          .order('created_at', ascending: false);

      // Fetch related data separately for each notification
      List<Map<String, dynamic>> enrichedNotifications = [];
      
      for (var notification in notifications) {
        Map<String, dynamic> enriched = Map<String, dynamic>.from(notification);
        
        // Get related booking if exists
        if (notification['related_booking'] != null) {
          try {
            final booking = await _supabase
                .from('bookings')
                .select('id, check_in, check_out, status, total_amount')
                .eq('id', notification['related_booking'])
                .single();
            enriched['booking'] = booking;
          } catch (e) {
            print('Error fetching related booking: $e');
          }
        }
        
        // Get related task if exists
        if (notification['related_task'] != null) {
          try {
            final task = await _supabase
                .from('housekeeping_tasks')
                .select('id, room_number, task_type, status')
                .eq('id', notification['related_task'])
                .single();
            enriched['task'] = task;
          } catch (e) {
            print('Error fetching related task: $e');
          }
        }
        
        // Get related item if exists
        if (notification['related_item'] != null) {
          try {
            final item = await _supabase
                .from('inventory_items')
                .select('id, name, current_stock, min_stock')
                .eq('id', notification['related_item'])
                .single();
            enriched['item'] = item;
          } catch (e) {
            print('Error fetching related item: $e');
          }
        }
        
        enrichedNotifications.add(enriched);
      }

      return enrichedNotifications;
    } catch (e) {
      print('Error fetching notifications with related data: $e');
      return [];
    }
  }
}
