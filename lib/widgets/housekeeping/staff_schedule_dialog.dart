import '../../constants/app_exports.dart';

class StaffScheduleDialog extends StatefulWidget {
  final Map<String, dynamic> staffMember;
  final List<Map<String, dynamic>> staffTasks;
  final Future<bool> Function(String taskId) onMarkDone;

  const StaffScheduleDialog({
    super.key,
    required this.staffMember,
    required this.staffTasks,
    required this.onMarkDone,
  });

  @override
  State<StaffScheduleDialog> createState() => _StaffScheduleDialogState();
}

class _StaffScheduleDialogState extends State<StaffScheduleDialog> {
  // Track updating tasks to disable buttons while request in-flight
  final Set<String> _updating = {};

  bool _isCompleted(String? status) {
    final s = (status ?? '').toLowerCase();
    return s == 'completed' || s == 'done';
  }

  Future<bool> _confirmMarkDone(BuildContext context) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mark task as complete?'),
        content: const Text('This will mark the task as completed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Mark complete'),
          ),
        ],
      ),
    );
    return res == true;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    // Sort tasks by due date using utility
    final sortedTasks = ScheduleUtils.sortTasksByDateTime(widget.staffTasks);

    // Group tasks by date using utility
    final tasksByDate = ScheduleUtils.groupTasksByDate(sortedTasks);
    
    // Calculate dynamic height based on task count
    final taskCount = widget.staffTasks.length;
    final dateCount = tasksByDate.keys.length;
    
    // Estimate heights
    final headerHeight = isSmallScreen ? 80.0 : 90.0;
    final dividerHeight = 1.0;
    final emptyStateHeight = isSmallScreen ? 200.0 : 250.0;
    final taskCardHeight = isSmallScreen ? 90.0 : 110.0;
    final dateHeaderHeight = isSmallScreen ? 40.0 : 50.0;
    final paddingHeight = isSmallScreen ? 32.0 : 44.0; // ListView padding
    final spacingHeight = dateCount > 1 ? (dateCount - 1) * (isSmallScreen ? 16.0 : 20.0) : 0.0;
    
    double contentHeight;
    if (widget.staffTasks.isEmpty) {
      contentHeight = headerHeight + dividerHeight + emptyStateHeight;
    } else {
      contentHeight = headerHeight + dividerHeight + paddingHeight + 
                     (dateCount * dateHeaderHeight) + 
                     (taskCount * taskCardHeight) + 
                     spacingHeight;
    }
    
    // Set min and max constraints
    final minHeight = isSmallScreen ? 300.0 : 400.0;
    final maxHeight = screenSize.height * (isSmallScreen ? 0.85 : 0.8);
    
    final dialogHeight = contentHeight.clamp(minHeight, maxHeight);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 40,
        vertical: isSmallScreen ? 24 : 60,
      ),
      child: Container(
        width: isSmallScreen ? double.maxFinite : 600,
        height: dialogHeight,
        constraints: BoxConstraints(
          minHeight: minHeight,
          maxHeight: maxHeight,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            _buildHeader(context, isSmallScreen),
            
            // Divider
            Divider(
              height: 1,
              color: Colors.grey.withOpacity(0.2),
            ),
            
            // Schedule Content
            Expanded(
              child: widget.staffTasks.isEmpty
                  ? _buildEmptyState(isSmallScreen)
                  : _buildScheduleContent(tasksByDate, isSmallScreen),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.person_outline,
              color: const Color(0xFF6366F1),
              size: isSmallScreen ? 20 : 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.staffMember['name'],
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.staffMember['role'],
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            color: Colors.grey[600],
            iconSize: isSmallScreen ? 20 : 24,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note_outlined,
              size: isSmallScreen ? 48 : 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            Text(
              'No Tasks',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: isSmallScreen ? 4 : 8),
            Text(
              'No tasks assigned yet',
              style: TextStyle(
                fontSize: isSmallScreen ? 13 : 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleContent(Map<String, List<Map<String, dynamic>>> tasksByDate, bool isSmallScreen) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 20,
        vertical: isSmallScreen ? 8 : 12,
      ),
      itemCount: tasksByDate.keys.length,
      itemBuilder: (context, index) {
        final dateKey = tasksByDate.keys.elementAt(index);
        final tasks = tasksByDate[dateKey]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index > 0) SizedBox(height: isSmallScreen ? 16 : 20),
            _buildDateHeader(dateKey, isSmallScreen),
            SizedBox(height: isSmallScreen ? 8 : 12),
            ...tasks.map((task) => _buildTaskCard(task, isSmallScreen)),
          ],
        );
      },
    );
  }

  Widget _buildDateHeader(String dateKey, bool isSmallScreen) {
    final now = DateTime.now();
    final isToday = dateKey == ScheduleUtils.formatDate(now);
    final isTomorrow = dateKey == ScheduleUtils.formatDate(now.add(const Duration(days: 1)));
    
    String displayText = dateKey;
    Color backgroundColor = Colors.grey.withOpacity(0.08);
    Color textColor = Colors.grey[700]!;
    IconData icon = Icons.calendar_today_outlined;
    
    if (isToday) {
      displayText = isSmallScreen ? 'Today' : 'Today';
      backgroundColor = const Color(0xFF6366F1).withOpacity(0.1);
      textColor = const Color(0xFF6366F1);
      icon = Icons.today_outlined;
    } else if (isTomorrow) {
      displayText = isSmallScreen ? 'Tomorrow' : 'Tomorrow';
      backgroundColor = Colors.orange.withOpacity(0.1);
      textColor = Colors.orange[700]!;
      icon = Icons.event_outlined;
    }
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8 : 12,
        vertical: isSmallScreen ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isSmallScreen ? 14 : 16,
            color: textColor,
          ),
          SizedBox(width: isSmallScreen ? 6 : 8),
          Text(
            displayText,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task, bool isSmallScreen) {
    final priorityColor = ScheduleUtils.getTaskPriorityColor(task['priority']);
    final taskId = (task['id'] ?? task['task_id'] ?? task['uuid'] ?? '').toString();
    final completed = _isCompleted(task['status']?.toString());
    final isUpdating = _updating.contains(taskId);
    
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.02),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Compact header
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 6 : 8,
                  vertical: isSmallScreen ? 2 : 4,
                ),
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  task['room'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 10 : 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: isSmallScreen ? 6 : 8),
              TaskStatusBadge(
                status: task['status'],
                fontSize: isSmallScreen ? 8 : 9,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 4 : 6,
                  vertical: 2,
                ),
              ),
              const Spacer(),
              if (!completed && taskId.isNotEmpty) ...[
                SizedBox(width: isSmallScreen ? 6 : 8),
                Tooltip(
                  message: 'Mark as complete',
                  child: Ink(
                    decoration: ShapeDecoration(
                      color: const Color(0xFF22C55E).withOpacity(0.12),
                      shape: CircleBorder(
                        side: BorderSide(color: const Color(0xFF16A34A).withOpacity(0.2)),
                      ),
                    ),
                    child: IconButton(
                      iconSize: isSmallScreen ? 22 : 24,
                      color: const Color(0xFF16A34A),
                      onPressed: isUpdating
                          ? null
                          : () async {
                              final confirm = await _confirmMarkDone(context);
                              if (!confirm) return;
                              setState(() => _updating.add(taskId));
                              final prevStatus = task['status'];
                              final ok = await widget.onMarkDone(taskId);
                              if (!mounted) return;
                              if (ok) {
                                setState(() {
                                  task['status'] = 'completed';
                                  _updating.remove(taskId);
                                });
                                // Show UNDO snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Task marked complete'),
                                    action: SnackBarAction(
                                      label: 'UNDO',
                                      onPressed: () async {
                                        // Revert status
                                        try {
                                          await HousekeepingService.updateTaskStatus(taskId, (prevStatus ?? 'pending').toString());
                                          if (!mounted) return;
                                          setState(() {
                                            task['status'] = prevStatus ?? 'pending';
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Reverted completion')),
                                          );
                                        } catch (_) {}
                                      },
                                    ),
                                  ),
                                );
                              } else {
                                setState(() => _updating.remove(taskId));
                              }
                            },
                      icon: isUpdating
                          ? SizedBox(
                              width: isSmallScreen ? 16 : 18,
                              height: isSmallScreen ? 16 : 18,
                              child: const CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check),
                    ),
                  ),
                ),
              ],
            ],
          ),
          
          SizedBox(height: isSmallScreen ? 6 : 8),
          
          // Task type
          Row(
            children: [
              TaskTypeBadge(
                type: task['type'],
                fontSize: isSmallScreen ? 9 : 10,
              ),
              SizedBox(width: isSmallScreen ? 6 : 8),
              TaskPriorityBadge(
                priority: task['priority'],
                fontSize: isSmallScreen ? 8 : 9,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 4 : 6,
                  vertical: 2,
                ),
              ),
            ],
          ),
          
          if (task['notes'] != null && task['notes'].toString().isNotEmpty) ...[
            SizedBox(height: isSmallScreen ? 6 : 8),
            Text(
              task['notes'].toString(),
              style: TextStyle(
                fontSize: isSmallScreen ? 11 : 12,
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }


}
