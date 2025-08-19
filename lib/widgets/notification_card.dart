import '../constants/app_exports.dart';
import 'notification_icon.dart';
import 'priority_badge.dart';

class NotificationCard extends StatelessWidget {
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
  final VoidCallback? onMarkAsRead;
  final VoidCallback? onDelete;

  const NotificationCard({
    super.key,
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
    this.onMarkAsRead,
    this.onDelete,
  });

  String _formatTime(DateTime timestamp) {
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: read
              ? Colors.grey.shade50.withValues(alpha: 0.5)
              : Colors.blue.shade50.withValues(alpha: 0.5),
          border: Border.all(
            color: read
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
                NotificationIcon(
                  icon: icon,
                  type: type,
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
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (!read)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          const SizedBox(width: 8),
                          PriorityBadge(priority: priority),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
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
                  child: _buildMetadata(),
                ),
                _buildActions(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadata() {
    return Row(
      children: [
        Text(
          _formatTime(timestamp),
          style: const TextStyle(
            color: Colors.black38,
            fontSize: 12,
          ),
        ),
        const Text(' • ', style: TextStyle(color: Colors.black38)),
        Text(
          source,
          style: const TextStyle(
            color: Colors.black38,
            fontSize: 12,
          ),
        ),
        if (amount != null) ...[
          const Text(' • ', style: TextStyle(color: Colors.black38)),
          Text(
            '\$${amount!.toInt()}',
            style: const TextStyle(
              color: Colors.green,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        if (rating != null) ...[
          const Text(' • ', style: TextStyle(color: Colors.black38)),
          Text(
            '$rating stars',
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!read && onMarkAsRead != null)
          IconButton(
            onPressed: onMarkAsRead,
            icon: const Icon(Icons.mark_email_read),
            iconSize: 20,
            tooltip: 'Mark as read',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
        if (onDelete != null)
          IconButton(
            onPressed: onDelete,
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
    );
  }
}
