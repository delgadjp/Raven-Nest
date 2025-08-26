import '../constants/app_exports.dart';

class NotificationListHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onMarkAllRead;
  final int unreadCount;

  const NotificationListHeader({
    super.key,
    this.title = 'Recent Notifications',
    this.subtitle = 'All your property notifications',
    this.onMarkAllRead,
    this.unreadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        NotificationActions(
          onMarkAllRead: onMarkAllRead,
          unreadCount: unreadCount,
        ),
      ],
    );
  }
}
