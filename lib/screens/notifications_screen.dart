import 'package:flutter/material.dart';
import '../widgets/navigation.dart';
import '../widgets/summary_card.dart';

class NotificationModel {
  final int id;
  final String type;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool read;
  final String priority;
  final String source;
  final double? amount;
  final int? rating;
  final IconData icon;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.read,
    required this.priority,
    required this.source,
    this.amount,
    this.rating,
    required this.icon,
  });

  NotificationModel copyWith({
    bool? read,
  }) {
    return NotificationModel(
      id: id,
      type: type,
      title: title,
      message: message,
      timestamp: timestamp,
      read: read ?? this.read,
      priority: priority,
      source: source,
      amount: amount,
      rating: rating,
      icon: icon,
    );
  }
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationModel> notifications = [
    NotificationModel(
      id: 1,
      type: 'booking',
      title: 'New Booking Confirmed',
      message: 'Sarah Johnson has booked Room 305 for Dec 20-25, 2024',
      timestamp: DateTime(2024, 12, 14, 9, 30),
      read: false,
      priority: 'high',
      source: 'Airbnb',
      amount: 750,
      icon: Icons.calendar_today,
    ),
    NotificationModel(
      id: 2,
      type: 'checkin',
      title: 'Guest Check-in Tomorrow',
      message: 'John Smith is scheduled to check into Room 201 at 3:00 PM',
      timestamp: DateTime(2024, 12, 14, 8, 15),
      read: false,
      priority: 'medium',
      source: 'System',
      icon: Icons.home,
    ),
    NotificationModel(
      id: 3,
      type: 'maintenance',
      title: 'Maintenance Request Completed',
      message: 'Leaky faucet in Room 305 has been fixed by John Smith',
      timestamp: DateTime(2024, 12, 13, 16, 45),
      read: true,
      priority: 'low',
      source: 'Housekeeping',
      icon: Icons.check_circle,
    ),
    NotificationModel(
      id: 4,
      type: 'inventory',
      title: 'Low Inventory Alert',
      message: 'Vacuum bags are running low (1 remaining). Minimum threshold: 3',
      timestamp: DateTime(2024, 12, 13, 14, 20),
      read: false,
      priority: 'high',
      source: 'Inventory',
      icon: Icons.warning,
    ),
    NotificationModel(
      id: 5,
      type: 'checkout',
      title: 'Guest Checkout Completed',
      message: 'Anna Wilson has checked out of Studio. Room ready for cleaning',
      timestamp: DateTime(2024, 12, 13, 11, 30),
      read: true,
      priority: 'medium',
      source: 'System',
      icon: Icons.person,
    ),
    NotificationModel(
      id: 6,
      type: 'payment',
      title: 'Payment Received',
      message: 'Payment of \$450 received from Mike Davis for booking #1234',
      timestamp: DateTime(2024, 12, 12, 10, 15),
      read: true,
      priority: 'medium',
      source: 'Booking.com',
      amount: 450,
      icon: Icons.attach_money,
    ),
    NotificationModel(
      id: 7,
      type: 'review',
      title: 'New Guest Review',
      message: 'Emma Wilson left a 5-star review for Studio apartment',
      timestamp: DateTime(2024, 12, 12, 9, 0),
      read: false,
      priority: 'low',
      source: 'Airbnb',
      rating: 5,
      icon: Icons.message,
    ),
    NotificationModel(
      id: 8,
      type: 'booking',
      title: 'Booking Cancelled',
      message: 'Robert Johnson cancelled booking for Room 412 (Dec 18-20)',
      timestamp: DateTime(2024, 12, 11, 15, 30),
      read: true,
      priority: 'medium',
      source: 'Direct',
      icon: Icons.calendar_today,
    ),
  ];

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red.shade100;
      case 'medium':
        return Colors.yellow.shade100;
      case 'low':
        return Colors.green.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color getPriorityTextColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red.shade800;
      case 'medium':
        return Colors.yellow.shade800;
      case 'low':
        return Colors.green.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  Color getTypeBackgroundColor(String type) {
    switch (type) {
      case 'booking':
        return Colors.blue.shade50;
      case 'checkin':
        return Colors.green.shade50;
      case 'checkout':
        return Colors.orange.shade50;
      case 'maintenance':
        return Colors.purple.shade50;
      case 'inventory':
        return Colors.red.shade50;
      case 'payment':
        return Colors.green.shade50;
      case 'review':
        return Colors.indigo.shade50;
      default:
        return Colors.grey.shade50;
    }
  }

  Color getTypeIconColor(String type) {
    switch (type) {
      case 'booking':
        return Colors.blue.shade600;
      case 'checkin':
        return Colors.green.shade600;
      case 'checkout':
        return Colors.orange.shade600;
      case 'maintenance':
        return Colors.purple.shade600;
      case 'inventory':
        return Colors.red.shade600;
      case 'payment':
        return Colors.green.shade600;
      case 'review':
        return Colors.indigo.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  void markAsRead(int id) {
    setState(() {
      notifications = notifications.map((notif) =>
          notif.id == id ? notif.copyWith(read: true) : notif).toList();
    });
  }

  void markAllAsRead() {
    setState(() {
      notifications = notifications.map((notif) => notif.copyWith(read: true)).toList();
    });
  }

  void deleteNotification(int id) {
    setState(() {
      notifications = notifications.where((notif) => notif.id != id).toList();
    });
  }

  int get unreadCount => notifications.where((notif) => !notif.read).length;

  int get todayNotificationsCount {
    final today = DateTime.now();
    return notifications.where((notif) {
      return notif.timestamp.year == today.year &&
          notif.timestamp.month == today.month &&
          notif.timestamp.day == today.day;
    }).length;
  }

  int get highPriorityCount => notifications.where((n) => n.priority == 'high').length;

  String formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    
    if (diff.inDays > 0) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8FAFC), // slate-50
              Color(0xFFFEF2F2), // red-50
              Color(0xFFFDF2F8), // pink-50
            ],
          ),
        ),
        child: Column(
          children: [
            const NavigationWidget(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade600,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notifications',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Stay updated with your property activities',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Summary Cards
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final maxW = constraints.maxWidth;
                        int cols = 1;
                        if (maxW >= 1200) {
                          cols = 4;
                        } else if (maxW >= 920) {
                          cols = 3;
                        } else if (maxW >= 600) {
                          cols = 2;
                        }
                        const gap = 16.0;
                        final itemW = (maxW - (cols - 1) * gap) / cols;
                        return Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: [
                            SizedBox(
                              width: itemW,
                              child: SummaryCard(
                                title: 'Total Notifications',
                                value: '${notifications.length}',
                                subtitle: 'All notifications',
                                icon: Icons.notifications,
                                iconColor: Colors.blue.shade600,
                              ),
                            ),
                            SizedBox(
                              width: itemW,
                              child: SummaryCard(
                                title: 'Unread',
                                value: '$unreadCount',
                                subtitle: 'Need attention',
                                icon: Icons.warning,
                                iconColor: Colors.red.shade600,
                              ),
                            ),
                            SizedBox(
                              width: itemW,
                              child: SummaryCard(
                                title: 'Today',
                                value: '$todayNotificationsCount',
                                subtitle: 'Recent activity',
                                icon: Icons.calendar_today,
                                iconColor: Colors.green.shade600,
                              ),
                            ),
                            SizedBox(
                              width: itemW,
                              child: SummaryGradientCard(
                                title: 'High Priority',
                                value: '$highPriorityCount',
                                subtitle: 'Urgent items',
                                gradientColors: [Colors.red.shade500, Colors.pink.shade600],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 32),

                    // Notifications List Header
                    Card(
                      elevation: 0,
                      color: Colors.white.withValues(alpha: 0.8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Recent Notifications',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'All your property notifications',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: markAllAsRead,
                                      label: const Text(
                                        'Mark All Read',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        side: const BorderSide(color: Colors.black),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    OutlinedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.settings, size: 18, color: Colors.black),
                                      label: const Text(
                                        'Settings',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        side: const BorderSide(color: Colors.black),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Notifications List
                            ...notifications.map((notification) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: notification.read
                                        ? Colors.grey.shade50.withValues(alpha: 0.5)
                                        : Colors.blue.shade50.withValues(alpha: 0.5),
                                    border: Border.all(
                                      color: notification.read
                                          ? Colors.grey.shade100
                                          : Colors.blue.shade200,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: getTypeBackgroundColor(notification.type),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Icon(
                                              notification.icon,
                                              color: getTypeIconColor(notification.type),
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        notification.title,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    if (!notification.read)
                                                      Container(
                                                        width: 8,
                                                        height: 8,
                                                        decoration: const BoxDecoration(
                                                          color: Colors.blue,
                                                          shape: BoxShape.circle,
                                                        ),
                                                      ),
                                                    const SizedBox(width: 8),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(
                                                          horizontal: 8, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: getPriorityColor(notification.priority),
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      child: Text(
                                                        notification.priority,
                                                        style: TextStyle(
                                                          color: getPriorityTextColor(notification.priority),
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  notification.message,
                                                  style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  formatTime(notification.timestamp),
                                                  style: const TextStyle(
                                                    color: Colors.black38,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const Text(' • ', style: TextStyle(color: Colors.black38)),
                                                Text(
                                                  notification.source,
                                                  style: const TextStyle(
                                                    color: Colors.black38,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                if (notification.amount != null) ...[
                                                  const Text(' • ', style: TextStyle(color: Colors.black38)),
                                                  Text(
                                                    '\$${notification.amount!.toInt()}',
                                                    style: const TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                                if (notification.rating != null) ...[
                                                  const Text(' • ', style: TextStyle(color: Colors.black38)),
                                                  Text(
                                                    '${notification.rating} stars',
                                                    style: const TextStyle(
                                                      color: Colors.amber,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (!notification.read)
                                                IconButton(
                                                  onPressed: () => markAsRead(notification.id),
                                                  icon: const Icon(Icons.mark_email_read),
                                                  iconSize: 20,
                                                  tooltip: 'Mark as read',
                                                  padding: EdgeInsets.zero,
                                                  constraints: const BoxConstraints(
                                                    minWidth: 32,
                                                    minHeight: 32,
                                                  ),
                                                ),
                                              IconButton(
                                                onPressed: () => deleteNotification(notification.id),
                                                icon: const Icon(Icons.delete_outline),
                                                iconSize: 20,
                                                color: Colors.red.shade600,
                                                tooltip: 'Delete notification',
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(
                                                  minWidth: 32,
                                                  minHeight: 32,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
