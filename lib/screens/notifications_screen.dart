import '../constants/app_exports.dart';

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

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      colors: const [
        Color(0xFFF8FAFC), // slate-50
        Color(0xFFFEF2F2), // red-50
        Color(0xFFFDF2F8), // pink-50
      ],
      child: Column(
        children: [
          const NavigationWidget(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Cards
                    ResponsiveCardGrid(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        SummaryCard(
                          title: 'Total Notifications',
                          value: '${notifications.length}',
                          subtitle: 'All notifications',
                          icon: Icons.notifications,
                          iconColor: Colors.blue.shade600,
                        ),
                        SummaryCard(
                          title: 'Unread',
                          value: '$unreadCount',
                          subtitle: 'Need attention',
                          icon: Icons.warning,
                          iconColor: Colors.red.shade600,
                        ),
                        SummaryCard(
                          title: 'Today',
                          value: '$todayNotificationsCount',
                          subtitle: 'Recent activity',
                          icon: Icons.calendar_today,
                          iconColor: Colors.green.shade600,
                        ),
                        SummaryGradientCard(
                          title: 'High Priority',
                          value: '$highPriorityCount',
                          subtitle: 'Urgent items',
                          gradientColors: [Colors.red.shade500, Colors.pink.shade600],
                        ),
                      ],
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
                            NotificationListHeader(
                              onMarkAllRead: markAllAsRead,
                              unreadCount: unreadCount,
                            ),
                            const SizedBox(height: 16),

                            // Notifications List
                            ...notifications.map((notification) {
                              return NotificationCard(
                                id: notification.id,
                                type: notification.type,
                                title: notification.title,
                                message: notification.message,
                                timestamp: notification.timestamp,
                                read: notification.read,
                                priority: notification.priority,
                                source: notification.source,
                                amount: notification.amount,
                                rating: notification.rating,
                                icon: notification.icon,
                                onMarkAsRead: () => markAsRead(notification.id),
                                onDelete: () => deleteNotification(notification.id),
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
    );
  }
}
