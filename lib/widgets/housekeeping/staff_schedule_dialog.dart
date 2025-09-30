import '../../constants/app_exports.dart';

class StaffScheduleDialog extends StatelessWidget {
  final Map<String, dynamic> staffMember;
  final List<Map<String, dynamic>> staffTasks;

  const StaffScheduleDialog({
    super.key,
    required this.staffMember,
    required this.staffTasks,
  });

  @override
  Widget build(BuildContext context) {
    // Sort tasks by due date using utility
    final sortedTasks = ScheduleUtils.sortTasksByDateTime(staffTasks);

    // Group tasks by date using utility
    final tasksByDate = ScheduleUtils.groupTasksByDate(sortedTasks);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 20),
            
            // Schedule Content
            Expanded(
              child: staffTasks.isEmpty
                  ? _buildEmptyState()
                  : _buildScheduleContent(tasksByDate),
            ),
            
            const SizedBox(height: 20),
            
            // Actions
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.schedule,
            color: Color(0xFF6366F1),
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${staffMember['name']}\'s Schedule',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                staffMember['role'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Tasks Assigned',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This staff member currently has no assigned tasks.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleContent(Map<String, List<Map<String, dynamic>>> tasksByDate) {
    return ListView.builder(
      itemCount: tasksByDate.keys.length,
      itemBuilder: (context, index) {
        final dateKey = tasksByDate.keys.elementAt(index);
        final tasks = tasksByDate[dateKey]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index > 0) const SizedBox(height: 20),
            _buildDateHeader(dateKey),
            const SizedBox(height: 12),
            ...tasks.map((task) => _buildTaskCard(task)),
          ],
        );
      },
    );
  }

  Widget _buildDateHeader(String dateKey) {
    final now = DateTime.now();
    final isToday = dateKey == ScheduleUtils.formatDate(now);
    final isTomorrow = dateKey == ScheduleUtils.formatDate(now.add(const Duration(days: 1)));
    
    String displayText = dateKey;
    Color backgroundColor = Colors.grey.withOpacity(0.1);
    Color textColor = Colors.grey[600]!;
    
    if (isToday) {
      displayText = 'Today • $dateKey';
      backgroundColor = Colors.blue.withOpacity(0.1);
      textColor = Colors.blue;
    } else if (isTomorrow) {
      displayText = 'Tomorrow • $dateKey';
      backgroundColor = Colors.orange.withOpacity(0.1);
      textColor = Colors.orange;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today,
            size: 16,
            color: textColor,
          ),
          const SizedBox(width: 8),
          Text(
            displayText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    final dueDate = task['dueDate'] as DateTime;
    final priorityColor = ScheduleUtils.getTaskPriorityColor(task['priority']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: priorityColor.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with badges
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Room ${task['room']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TaskPriorityBadge(
                priority: task['priority'],
                fontSize: 9,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              ),
              const Spacer(),
              TaskStatusBadge(
                status: task['status'],
                fontSize: 9,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Task type badge
          TaskTypeBadge(
            type: task['type'],
            fontSize: 11,
          ),
          const SizedBox(height: 8),
          
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                ScheduleUtils.formatTime(dueDate),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (task['notes'] != null && task['notes'].toString().isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.note,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      task['notes'].toString(),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(
                color: Colors.grey.withOpacity(0.3),
              ),
              foregroundColor: Colors.grey.shade700,
            ),
            icon: const Icon(Icons.close, size: 18),
            label: const Text(
              'Close',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}
