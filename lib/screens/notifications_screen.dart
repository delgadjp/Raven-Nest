import '../constants/app_exports.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationModel> notifications = [];
  Map<String, dynamic> summaryData = {};
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNotificationsData();
  }

  Future<void> _loadNotificationsData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final results = await Future.wait([
        NotificationsService.getAllNotifications(),
        NotificationsService.getNotificationsSummary(),
      ]);

      setState(() {
        notifications = results[0] as List<NotificationModel>;
        summaryData = results[1] as Map<String, dynamic>;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load notifications: $e';
      });
    }
  }

  void markAsRead(String id) async {
    final success = await NotificationsService.markAsRead(id);
    
    if (success) {
      setState(() {
        notifications = notifications.map((notif) =>
            notif.id == id ? notif.copyWith(read: true) : notif).toList();
      });
      _loadNotificationsData(); // Reload to update summary
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to mark notification as read'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void markAllAsRead() async {
    final success = await NotificationsService.markAllAsRead();
    
    if (success) {
      _loadNotificationsData(); // Reload all data
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All notifications marked as read'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to mark all notifications as read'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void deleteNotification(String id) async {
    final success = await NotificationsService.deleteNotification(id);
    
    if (success) {
      _loadNotificationsData(); // Reload all data
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification deleted'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete notification'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  int get unreadCount => summaryData['unread'] ?? 0;
  int get todayNotificationsCount => summaryData['today'] ?? 0;
  int get highPriorityCount => summaryData['highPriority'] ?? 0;
  int get totalNotifications => summaryData['total'] ?? 0;

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
          if (isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (errorMessage != null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading notifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage!,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadNotificationsData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else
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
                            value: '$totalNotifications',
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
                              if (notifications.isEmpty)
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.notifications_none,
                                        size: 64,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No notifications yet',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'You\'ll see notifications here when they arrive',
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )
                              else
                                ...notifications.map((notification) {
                                  return NotificationCard(
                                    id: notification.id,
                                    type: notification.type,
                                    title: notification.title,
                                    message: notification.message,
                                    timestamp: notification.timestamp,
                                    read: notification.read,
                                    priority: notification.priority,
                                    relatedBooking: notification.relatedBooking,
                                    relatedTask: notification.relatedTask,
                                    relatedItem: notification.relatedItem,
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
