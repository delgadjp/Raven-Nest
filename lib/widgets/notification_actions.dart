import '../constants/app_exports.dart';

class NotificationActions extends StatelessWidget {
  final VoidCallback? onMarkAllRead;
  final int unreadCount;

  const NotificationActions({
    super.key,
    this.onMarkAllRead,
    this.unreadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ActionButton(
          text: 'Mark All Read',
          onPressed: unreadCount > 0 ? onMarkAllRead : null,
          isFullWidth: false,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ],
    );
  }
}
