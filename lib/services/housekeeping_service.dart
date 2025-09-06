import 'supabase_service.dart';

class HousekeepingService {
  static final _supabase = SupabaseService.client;

  // Get all housekeeping tasks
  static Future<List<Map<String, dynamic>>> getAllTasks() async {
    try {
      final response = await _supabase
          .from('housekeeping_tasks')
          .select('''
            id,
            room_number,
            task_type,
            due_date,
            due_time,
            priority,
            priority_weight,
            status,
            created_at,
            assigned_staff,
            housekeeping_staff!inner(
              id,
              name,
              contact,
              email
            )
          ''')
          .order('due_date', ascending: true)
          .order('due_time', ascending: true);

      // Transform data to match expected format
      return response.map<Map<String, dynamic>>((task) {
        final dueDate = DateTime.parse(task['due_date']);
        final dueTime = task['due_time'] != null 
            ? DateTime.parse('${task['due_date']} ${task['due_time']}')
            : dueDate;
        
        return {
          'id': task['id'],
          'room': task['room_number'],
          'type': task['task_type'],
          'assignee': task['housekeeping_staff']['name'],
          'dueDate': dueTime,
          'status': task['status'] == 'done' ? 'completed' : 
                   task['status'] == 'in-progress' ? 'in_progress' : 'pending',
          'priority': task['priority'],
          'notes': '', // Add notes field if available in your schema
        };
      }).toList();
    } catch (e) {
      print('Error fetching housekeeping tasks: $e');
      return [];
    }
  }

  // Get tasks for today
  static Future<List<Map<String, dynamic>>> getTodayTasks() async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      
      final response = await _supabase
          .from('housekeeping_tasks')
          .select('''
            id,
            room_number,
            task_type,
            due_date,
            due_time,
            priority,
            priority_weight,
            status,
            created_at,
            assigned_staff,
            housekeeping_staff!inner(
              id,
              name,
              contact,
              email
            )
          ''')
          .eq('due_date', today)
          .order('due_time', ascending: true);

      // Transform data to match expected format
      return response.map<Map<String, dynamic>>((task) {
        final dueDate = DateTime.parse(task['due_date']);
        final dueTime = task['due_time'] != null 
            ? DateTime.parse('${task['due_date']} ${task['due_time']}')
            : dueDate;
        
        return {
          'id': task['id'],
          'room': task['room_number'],
          'type': task['task_type'],
          'assignee': task['housekeeping_staff']['name'],
          'dueDate': dueTime,
          'status': task['status'] == 'done' ? 'completed' : 
                   task['status'] == 'in-progress' ? 'in_progress' : 'pending',
          'priority': task['priority'],
          'notes': '', // Add notes field if available in your schema
        };
      }).toList();
    } catch (e) {
      print('Error fetching today tasks: $e');
      return [];
    }
  }

  // Get all housekeeping staff
  static Future<List<Map<String, dynamic>>> getAllStaff() async {
    try {
      final response = await _supabase
          .from('housekeeping_staff')
          .select('*')
          .order('name', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching housekeeping staff: $e');
      return [];
    }
  }

  // Get housekeeping summary statistics
  static Future<Map<String, dynamic>> getHousekeepingSummary() async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];

      // Get today's tasks count
      final todayTasksResponse = await _supabase
          .from('housekeeping_tasks')
          .select('id')
          .eq('due_date', today);

      // Get total tasks count
      final totalTasksResponse = await _supabase
          .from('housekeeping_tasks')
          .select('id');

      // Get completed tasks count
      final completedTasksResponse = await _supabase
          .from('housekeeping_tasks')
          .select('id')
          .eq('status', 'done');

      return {
        'todayTasks': todayTasksResponse.length,
        'totalTasks': totalTasksResponse.length,
        'completedTasks': completedTasksResponse.length,
      };
    } catch (e) {
      print('Error fetching housekeeping summary: $e');
      return {
        'todayTasks': 0,
        'totalTasks': 0,
        'completedTasks': 0,
      };
    }
  }

  // Get staff statistics (active tasks, completed today)
  static Future<List<Map<String, dynamic>>> getStaffStatistics() async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final staff = await getAllStaff();
      
      List<Map<String, dynamic>> staffWithStats = [];
      
      for (var staffMember in staff) {
        // Get active tasks for this staff member
        final activeTasksResponse = await _supabase
            .from('housekeeping_tasks')
            .select('id')
            .eq('assigned_staff', staffMember['id'])
            .or('status.eq.pending,status.eq.in-progress');

        // Get completed tasks today for this staff member
        final completedTodayResponse = await _supabase
            .from('housekeeping_tasks')
            .select('id')
            .eq('assigned_staff', staffMember['id'])
            .eq('status', 'done')
            .eq('due_date', today);

        // Transform to match expected format
        staffWithStats.add({
          'id': staffMember['id'],
          'name': staffMember['name'],
          'role': 'Housekeeper', // Default role since it's not in the database schema
          'phone': staffMember['contact'] ?? '',
          'email': staffMember['email'] ?? '',
          'activeTasks': activeTasksResponse.length,
          'completedToday': completedTodayResponse.length,
          'status': activeTasksResponse.isEmpty ? 'available' : 'busy',
        });
      }
      
      return staffWithStats;
    } catch (e) {
      print('Error fetching staff statistics: $e');
      return [];
    }
  }

  // Add a new housekeeping task
  static Future<bool> addTask(Map<String, dynamic> taskData) async {
    try {
      await _supabase.from('housekeeping_tasks').insert(taskData);
      return true;
    } catch (e) {
      print('Error adding task: $e');
      return false;
    }
  }

  // Update task status
  static Future<bool> updateTaskStatus(String taskId, String newStatus) async {
    try {
      // Map frontend status to database status
      String dbStatus;
      switch (newStatus) {
        case 'completed':
          dbStatus = 'done';
          break;
        case 'in_progress':
          dbStatus = 'in-progress';
          break;
        case 'pending':
        default:
          dbStatus = 'pending';
          break;
      }
      
      await _supabase
          .from('housekeeping_tasks')
          .update({'status': dbStatus})
          .eq('id', taskId);
      return true;
    } catch (e) {
      print('Error updating task status: $e');
      return false;
    }
  }

  // Update task assignment
  static Future<bool> assignTaskToStaff(String taskId, String staffId) async {
    try {
      await _supabase
          .from('housekeeping_tasks')
          .update({
            'assigned_staff': staffId,
            'status': 'pending', // Reset status when reassigning
          })
          .eq('id', taskId);
      return true;
    } catch (e) {
      print('Error assigning task to staff: $e');
      return false;
    }
  }

  // Delete a task
  static Future<bool> deleteTask(String taskId) async {
    try {
      await _supabase
          .from('housekeeping_tasks')
          .delete()
          .eq('id', taskId);
      return true;
    } catch (e) {
      print('Error deleting task: $e');
      return false;
    }
  }

  // Add new staff member
  static Future<bool> addStaff(Map<String, dynamic> staffData) async {
    try {
      await _supabase.from('housekeeping_staff').insert(staffData);
      return true;
    } catch (e) {
      print('Error adding staff: $e');
      return false;
    }
  }

  // Update staff member
  static Future<bool> updateStaff(String staffId, Map<String, dynamic> updates) async {
    try {
      await _supabase
          .from('housekeeping_staff')
          .update(updates)
          .eq('id', staffId);
      return true;
    } catch (e) {
      print('Error updating staff: $e');
      return false;
    }
  }

  // Remove staff member
  static Future<bool> removeStaff(String staffId) async {
    try {
      // Note: When we delete staff, the database should handle reassigning tasks
      // or we might want to reassign tasks to another staff member first
      await _supabase
          .from('housekeeping_staff')
          .delete()
          .eq('id', staffId);
      return true;
    } catch (e) {
      print('Error removing staff: $e');
      return false;
    }
  }

  // Get tasks assigned to a specific staff member
  static Future<List<Map<String, dynamic>>> getTasksForStaff(String staffId) async {
    try {
      final response = await _supabase
          .from('housekeeping_tasks')
          .select('''
            id,
            room_number,
            task_type,
            due_date,
            due_time,
            priority,
            priority_weight,
            status,
            created_at
          ''')
          .eq('assigned_staff', staffId)
          .order('due_date', ascending: true)
          .order('due_time', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching tasks for staff: $e');
      return [];
    }
  }

  // Helper function to calculate priority based on due date and time
  static String calculatePriority(DateTime dueDateTime) {
    final now = DateTime.now();
    final difference = dueDateTime.difference(now).inHours;
    
    if (difference <= 2) {
      return 'critical';
    } else if (difference <= 6) {
      return 'high';
    } else if (difference <= 24) {
      return 'medium';
    } else {
      return 'low';
    }
  }

  // Helper function to get priority weight for database
  static int getPriorityWeight(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical':
        return 5;
      case 'high':
        return 4;
      case 'medium':
        return 3;
      case 'low':
        return 2;
      default:
        return 1;
    }
  }

  // Update task priorities based on current time
  static Future<bool> updateTaskPriorities() async {
    try {
      final tasks = await getAllTasks();
      
      for (var task in tasks) {
        if (task['status'] != 'done') {
          final dueDate = DateTime.parse(task['due_date']);
          final dueTime = task['due_time'] != null 
              ? DateTime.parse('${task['due_date']} ${task['due_time']}')
              : dueDate;
          
          final newPriority = calculatePriority(dueTime);
          final newPriorityWeight = getPriorityWeight(newPriority);
          
          await _supabase
              .from('housekeeping_tasks')
              .update({
                'priority': newPriority,
                'priority_weight': newPriorityWeight,
              })
              .eq('id', task['id']);
        }
      }
      
      return true;
    } catch (e) {
      print('Error updating task priorities: $e');
      return false;
    }
  }
}
