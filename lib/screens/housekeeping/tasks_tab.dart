import '/constants/app_exports.dart';

class TasksTab extends StatelessWidget {
  final List<Map<String,dynamic>> tasks;
  final List<Map<String,dynamic>> todayTasks;
  final List<Map<String,dynamic>> upcomingTasks;
  final void Function(int,String) updateTaskStatus;
  
  const TasksTab({
    super.key,
    required this.tasks,
    required this.todayTasks,
    required this.upcomingTasks,
    required this.updateTaskStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _todaySection(context),
        const SizedBox(height: 14),
        _upcomingSection(context),
      ],
    );
  }

  Widget _todaySection(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.85),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Tasks",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Tasks scheduled for today',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Task'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: todayTasks.map((task) => TaskCard(
                task: task,
                isDetailed: true,
                onStatusUpdate: () => _handleStatusUpdate(task),
                onViewDetails: () => _handleViewDetails(task),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _upcomingSection(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.85),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upcoming Tasks',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2),
                Text(
                  'Tasks scheduled for the next few days',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: upcomingTasks.take(3).map((task) => TaskCard(
                task: task,
                isDetailed: false,
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _handleStatusUpdate(Map<String, dynamic> task) {
    final int taskId = task['id'] as int;
    final String currentStatus = task['status'] as String;
    
    String newStatus;
    if (currentStatus == 'pending') {
      newStatus = 'in_progress';
    } else if (currentStatus == 'in_progress') {
      newStatus = 'completed';
    } else {
      return; // No status update needed
    }
    
    updateTaskStatus(taskId, newStatus);
  }

  void _handleViewDetails(Map<String, dynamic> task) {
    // Handle view details action
    print('View details for task: ${task['id']}');
  }
}
