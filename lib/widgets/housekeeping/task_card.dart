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
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: HousekeepingHelpers.getPriorityColor(task['priority']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  HousekeepingHelpers.getTypeIcon(task['type']),
                  size: 18,
                  color: HousekeepingHelpers.getPriorityColor(task['priority']),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${task['room']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      HousekeepingHelpers.formatTaskType(task['type']),
                      style: TextStyle(
                        fontSize: 12, 
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  StatusChip(
                    text: task['priority'],
                    color: HousekeepingHelpers.getPriorityColor(task['priority']),
                  ),
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
                  mainAxisSpacing: 4,
                  childAspectRatio: 5.5,
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
            const SizedBox(height: 8),
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                task['notes'],
                style: const TextStyle(
                  fontSize: 14, 
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
          ],

          // Action Buttons
          const SizedBox(height: 16),
          Row(
            children: [
              if (task['status'] == 'pending')
                Expanded(
                  child: ElevatedButton(
                    onPressed: onStatusUpdate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Start Task'),
                  ),
                ),
              if (task['status'] == 'in_progress')
                Expanded(
                  child: ElevatedButton(
                    onPressed: onStatusUpdate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Mark Complete'),
                  ),
                ),
              if (task['status'] == 'scheduled')
                Expanded(
                  child: OutlinedButton(
                    onPressed: onViewDetails,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    child: const Text('View Details'),
                  ),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: HousekeepingHelpers.getPriorityColor(task['priority']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  HousekeepingHelpers.getTypeIcon(task['type']),
                  size: 16,
                  color: HousekeepingHelpers.getPriorityColor(task['priority']),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Room ${task['room']} - ${HousekeepingHelpers.formatTaskType(task['type'])}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
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
