import '../../constants/app_exports.dart';

class NotificationCard extends StatelessWidget {
  final String id;
  final String type;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool read;
  final String priority;
  final String? relatedBooking;
  final String? relatedTask;
  final String? relatedItem;
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
    this.relatedBooking,
    this.relatedTask,
    this.relatedItem,
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
    final baseStyle = const TextStyle(
      color: Colors.black38,
      fontSize: 12,
    );

    // Build tag spans: prefer related tags if present; otherwise show the type once.
    final List<InlineSpan> spans = [
      TextSpan(text: _formatTime(timestamp), style: baseStyle),
    ];

    final List<InlineSpan> tagSpans = [];

    if (relatedBooking != null) {
      tagSpans.add(const TextSpan(
        text: 'Booking',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ));
    }

    if (relatedTask != null) {
      tagSpans.add(const TextSpan(
        text: 'Task',
        style: TextStyle(
          color: Colors.orange,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ));
    }

    if (relatedItem != null) {
      tagSpans.add(const TextSpan(
        text: 'Inventory',
        style: TextStyle(
          color: Colors.green,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ));
    }

    if (tagSpans.isEmpty) {
      // No related tags; show the type (capitalized) instead.
      final typeLabel = type.isEmpty
          ? type
          : '${type[0].toUpperCase()}${type.substring(1)}';
      tagSpans.add(TextSpan(text: typeLabel, style: baseStyle));
    }

    // Add a separator before tags and join multiple tags with separators.
    spans.add(const TextSpan(text: ' • ', style: TextStyle(color: Colors.black38)));
    for (int i = 0; i < tagSpans.length; i++) {
      if (i > 0) {
        spans.add(const TextSpan(text: ' • ', style: TextStyle(color: Colors.black38)));
      }
      spans.add(tagSpans[i]);
    }

    return Text.rich(
      TextSpan(children: spans),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
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
