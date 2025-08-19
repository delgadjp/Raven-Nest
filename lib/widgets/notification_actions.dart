import '../constants/app_exports.dart';

class NotificationActions extends StatelessWidget {
  final VoidCallback? onMarkAllRead;
  final VoidCallback? onSettings;
  final int unreadCount;

  const NotificationActions({
    super.key,
    this.onMarkAllRead,
    this.onSettings,
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
        const SizedBox(width: 8),
        ActionButton(
          text: 'Settings',
          icon: Icons.settings,
          onPressed: onSettings,
          isFullWidth: false,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textColor: Colors.black,
        ),
      ],
    );
  }
}
