import '/constants/app_exports.dart';

class TaskCard extends StatelessWidget {
  final Map<String, dynamic> task;
  final bool isDetailed;
  final VoidCallback? onStatusUpdate;
  final VoidCallback? onViewDetails;

  const TaskCard({
    super.key,
    required this.task,
    this.isDetailed = true,
    this.onStatusUpdate,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    if (isDetailed) {
      return _detailedTaskCard(context);
    } else {
      return _compactTaskCard(context);
    }
  }

  Widget _detailedTaskCard(BuildContext context) {
    final due = task['dueDate'] as DateTime;
    final dueTime = TimeOfDay.fromDateTime(due).format(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    HousekeepingHelpers.getTypeIcon(task['type']),
                    size: 18,
                    color: HousekeepingHelpers.getPriorityColor(task['priority']),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Room ${task['room']}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        HousekeepingHelpers.formatTaskType(task['type']),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  StatusChip(
                    text: task['priority'],
                    color: HousekeepingHelpers.getPriorityColor(task['priority']),
                  ),
                  const SizedBox(width: 6),
                  StatusChip(
                    text: HousekeepingHelpers.formatStatus(task['status']),
                    color: HousekeepingHelpers.getStatusColor(task['status']),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Info Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final isMd = constraints.maxWidth >= 768;
              return GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMd ? 3 : 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 4,
                ),
                children: [
                  InfoRow(
                    label: 'Assigned to', 
                    value: task['assignee'],
                    valueColor: const Color(0xFF059669),
                    valueFontWeight: FontWeight.w600,
                  ),
                  InfoRow(label: 'Due Time', value: dueTime),
                  if (task['checkoutTime'] != null)
                    InfoRow(
                      label: 'Checkout/Checkin',
                      value: '${task['checkoutTime']} → ${task['checkinTime']}',
                    ),
                ],
              );
            },
          ),

          // Notes Section
          if (task['notes'] != null) ...[
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Notes',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                task['notes'],
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
          ],

          // Action Buttons
          const SizedBox(height: 12),
          Row(
            children: [
              if (task['status'] == 'pending')
                ElevatedButton(
                  onPressed: onStatusUpdate,
                  child: const Text('Start Task'),
                ),
              if (task['status'] == 'in_progress')
                ElevatedButton(
                  onPressed: onStatusUpdate,
                  child: const Text('Mark Complete'),
                ),
              if (task['status'] == 'scheduled')
                OutlinedButton(
                  onPressed: onViewDetails,
                  child: const Text('View Details'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _compactTaskCard(BuildContext context) {
    final due = task['dueDate'] as DateTime;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                HousekeepingHelpers.getTypeIcon(task['type']),
                size: 18,
                color: HousekeepingHelpers.getPriorityColor(task['priority']),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Room ${task['room']} - ${HousekeepingHelpers.formatTaskType(task['type'])}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 12,
                        color: Color(0xFF059669),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task['assignee'],
                        style: const TextStyle(
                          fontSize: 12, 
                          color: Color(0xFF059669),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${due.month}/${due.day}/${due.year}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              StatusChip(
                text: HousekeepingHelpers.formatStatus(task['status']),
                color: HousekeepingHelpers.getStatusColor(task['status']),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
