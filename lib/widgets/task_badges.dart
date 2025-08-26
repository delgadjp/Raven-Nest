import '/constants/app_exports.dart';

class TaskStatusBadge extends StatelessWidget {
  final String status;
  final double fontSize;
  final EdgeInsets padding;

  const TaskStatusBadge({
    super.key,
    required this.status,
    this.fontSize = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = ScheduleUtils.getTaskStatusColor(status);
    final statusIcon = ScheduleUtils.getStatusIcon(status);
    final displayText = _getDisplayText();

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            color: statusColor,
            size: fontSize + 2,
          ),
          const SizedBox(width: 4),
          Text(
            displayText,
            style: TextStyle(
              color: statusColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getDisplayText() {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'COMPLETED';
      case 'in_progress':
        return 'IN PROGRESS';
      case 'pending':
        return 'PENDING';
      default:
        return status.replaceAll('_', ' ').toUpperCase();
    }
  }
}

class TaskPriorityBadge extends StatelessWidget {
  final String priority;
  final double fontSize;
  final EdgeInsets padding;

  const TaskPriorityBadge({
    super.key,
    required this.priority,
    this.fontSize = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    final priorityColor = ScheduleUtils.getTaskPriorityColor(priority);
    final priorityIcon = ScheduleUtils.getPriorityIcon(priority);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: priorityColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            priorityIcon,
            color: Colors.white,
            size: fontSize + 2,
          ),
          const SizedBox(width: 4),
          Text(
            priority.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class TaskTypeBadge extends StatelessWidget {
  final String type;
  final double fontSize;
  final EdgeInsets padding;

  const TaskTypeBadge({
    super.key,
    required this.type,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    final typeIcon = ScheduleUtils.getTaskTypeIcon(type);
    final displayName = ScheduleUtils.getTaskTypeDisplayName(type);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF6366F1).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            typeIcon,
            color: const Color(0xFF6366F1),
            size: fontSize + 4,
          ),
          const SizedBox(width: 6),
          Text(
            displayName,
            style: TextStyle(
              color: const Color(0xFF6366F1),
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
