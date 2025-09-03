import 'dart:async';
import '../constants/app_exports.dart';

class HousekeepingScreen extends StatefulWidget {
  const HousekeepingScreen({super.key});
  @override
  State<HousekeepingScreen> createState() => _HousekeepingScreenState();
}

class _HousekeepingScreenState extends State<HousekeepingScreen> {
  int _currentTab = 0;
  late Timer _priorityUpdateTimer;

  final List<Map<String, dynamic>> tasks = [
    {'id': 1,'room': '201','type': 'checkout_cleaning','assignee': 'Maria Santos','dueDate': DateTime(2025,8,19,14,0),'status': 'completed','checkoutTime': '11:00 AM','checkinTime': '3:00 PM','notes': 'Deep clean bathroom, replace towels'},
    {'id': 2,'room': '305','type': 'maintenance','assignee': 'John Smith','dueDate': DateTime(2025,8,20,10,0),'status': 'in_progress','notes': 'Fix leaky faucet in kitchen'},
    {'id': 3,'room': '412','type': 'room_service','assignee': 'Lisa Chen','dueDate': DateTime(2025,8,20,15,30),'status': 'pending','notes': 'Guest requested extra towels and coffee pods'},
  ];

  @override
  void initState() {
    super.initState();
    // Update existing tasks with calculated priorities
    for (var task in tasks) {
      task['priority'] = _calculatePriority(task['dueDate'] as DateTime);
    }
    
    // Set up periodic priority updates (every 30 minutes)
    _priorityUpdateTimer = Timer.periodic(const Duration(minutes: 30), (timer) {
      _updateAllTaskPriorities();
    });
  }

  @override
  void dispose() {
    _priorityUpdateTimer.cancel();
    super.dispose();
  }

  final List<Map<String, dynamic>> staff = [
    {'id': 1,'name': 'Maria Santos','role': 'Head Housekeeper','phone': '(555) 123-4567','email': 'maria@email.com','activeTasks': 3,'completedToday': 2,'status': 'available'},
    {'id': 2,'name': 'John Smith','role': 'Maintenance','phone': '(555) 234-5678','email': 'john@email.com','activeTasks': 1,'completedToday': 1,'status': 'busy'},
    {'id': 3,'name': 'Lisa Chen','role': 'Housekeeper','phone': '(555) 345-6789','email': 'lisa@email.com','activeTasks': 2,'completedToday': 0,'status': 'available'},
  ];

  List<Map<String, dynamic>> get todayTasks { 
    final t = DateTime.now(); 
    return tasks.where((task) { 
      final d = task['dueDate'] as DateTime; 
      return d.year == t.year && d.month == t.month && d.day == t.day; 
    }).toList(); 
  }
  
  List<Map<String, dynamic>> get upcomingTasks { 
    final now = DateTime.now(); 
    return tasks.where((task) => (task['dueDate'] as DateTime).isAfter(now)).toList(); 
  }
  
  int get completedTasks => tasks.where((t) => t['status'] == 'completed').length;

  void updateTaskStatus(int id, String newStatus) {
    setState(() {
      final i = tasks.indexWhere((t) => t['id'] == id);
      if (i != -1) {
        final task = tasks[i];
        final oldStatus = task['status'];
        task['status'] = newStatus;
        
        // Update priority for non-completed tasks
        if (newStatus != 'completed') {
          task['priority'] = _calculatePriority(task['dueDate'] as DateTime);
        }
        
        // Update staff statistics when task status changes
        _updateStaffStatistics(task['assignee'], oldStatus, newStatus);
      }
    });
  }

  void _updateStaffStatistics(String assigneeName, String oldStatus, String newStatus) {
    final staffIndex = staff.indexWhere((s) => s['name'] == assigneeName);
    if (staffIndex == -1) return;
    
    // Update active tasks count
    if (oldStatus == 'pending' && newStatus == 'in_progress') {
      // Task started - no change in active count (still active)
    } else if ((oldStatus == 'pending' || oldStatus == 'in_progress') && newStatus == 'completed') {
      // Task completed - decrease active count, increase completed count
      staff[staffIndex]['activeTasks'] = (staff[staffIndex]['activeTasks'] as int) - 1;
      staff[staffIndex]['completedToday'] = (staff[staffIndex]['completedToday'] as int) + 1;
    }
    
    // Update staff status based on active tasks
    if (staff[staffIndex]['activeTasks'] == 0) {
      staff[staffIndex]['status'] = 'available';
    } else {
      staff[staffIndex]['status'] = 'busy';
    }
  }

  // Calculate priority based on due date
  String _calculatePriority(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inHours;
    
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

  // Update all task priorities based on current time
  void _updateAllTaskPriorities() {
    setState(() {
      for (var task in tasks) {
        if (task['status'] != 'completed') {
          task['priority'] = _calculatePriority(task['dueDate'] as DateTime);
        }
      }
    });
  }

  void addTask(String room, String type, String assignee, DateTime dueDate, String? checkoutTime, String? checkinTime, String? notes) {
    setState(() {
      final newId = tasks.isNotEmpty ? tasks.map((t) => t['id'] as int).reduce((a, b) => a > b ? a : b) + 1 : 1;
      final priority = _calculatePriority(dueDate);
      
      tasks.add({
        'id': newId,
        'room': room,
        'type': type,
        'assignee': assignee,
        'dueDate': dueDate,
        'status': 'pending',
        'priority': priority,
        'checkoutTime': checkoutTime,
        'checkinTime': checkinTime,
        'notes': notes,
      });
      
      // Update staff active tasks count
      final staffIndex = staff.indexWhere((s) => s['name'] == assignee);
      if (staffIndex != -1) {
        staff[staffIndex]['activeTasks'] = (staff[staffIndex]['activeTasks'] as int) + 1;
        staff[staffIndex]['status'] = 'busy';
      }
    });
  }

  void assignTaskToStaff(int taskId, String staffName) {
    setState(() {
      final taskIndex = tasks.indexWhere((t) => t['id'] == taskId);
      if (taskIndex != -1) {
        final oldAssignee = tasks[taskIndex]['assignee'];
        
        // Update task assignment
        tasks[taskIndex]['assignee'] = staffName;
        tasks[taskIndex]['status'] = 'pending'; // Reset status when reassigning
        tasks[taskIndex]['priority'] = _calculatePriority(tasks[taskIndex]['dueDate'] as DateTime); // Update priority
        
        // Update old assignee statistics (decrease active tasks)
        final oldStaffIndex = staff.indexWhere((s) => s['name'] == oldAssignee);
        if (oldStaffIndex != -1) {
          staff[oldStaffIndex]['activeTasks'] = (staff[oldStaffIndex]['activeTasks'] as int) - 1;
          if (staff[oldStaffIndex]['activeTasks'] == 0) {
            staff[oldStaffIndex]['status'] = 'available';
          }
        }
        
        // Update new assignee statistics (increase active tasks)
        final newStaffIndex = staff.indexWhere((s) => s['name'] == staffName);
        if (newStaffIndex != -1) {
          staff[newStaffIndex]['activeTasks'] = (staff[newStaffIndex]['activeTasks'] as int) + 1;
          staff[newStaffIndex]['status'] = 'busy';
        }
      }
    });
  }

  void addStaff(String name, String role, String phone, String email) {
    setState(() {
      final newId = staff.isNotEmpty ? staff.map((s) => s['id'] as int).reduce((a, b) => a > b ? a : b) + 1 : 1;
      staff.add({
        'id': newId,
        'name': name,
        'role': role,
        'phone': phone,
        'email': email,
        'activeTasks': 0,
        'completedToday': 0,
        'status': 'available',
      });
    });
  }

  void removeStaff(int staffId) {
    setState(() {
      final staffIndex = staff.indexWhere((s) => s['id'] == staffId);
      if (staffIndex == -1) return;
      
      final staffMember = staff[staffIndex];
      final staffName = staffMember['name'];
      
      // Reassign all tasks assigned to this staff member to 'Unassigned'
      for (var task in tasks) {
        if (task['assignee'] == staffName) {
          task['assignee'] = 'Unassigned';
          task['status'] = 'pending'; // Reset status for reassignment
        }
      }
      
      // Remove staff member from the list
      staff.removeAt(staffIndex);
    });
  }

  void viewStaffSchedule(Map<String, dynamic> staffMember) {
    // Get all tasks assigned to this staff member
    final staffTasks = tasks.where((task) => task['assignee'] == staffMember['name']).toList();
    
    // Show the new enhanced schedule dialog
    showDialog(
      context: context,
      builder: (context) => StaffScheduleDialog(
        staffMember: staffMember,
        staffTasks: staffTasks,
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return GradientBackground(
      colors: const [
        Color(0xFFF8FAFC),
        Color(0xFFE0F2F1),
        Color(0xFFB2DFDB),
      ],
      child: Column(children:[
        const NavigationWidget(),
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveCardGrid(
                  children: [
                    SummaryCard(
                      title: "Today's Tasks",
                      value: todayTasks.length.toString(),
                      subtitle: 'scheduled today',
                      icon: Icons.today,
                      iconColor: Colors.indigo,
                    ),
                    SummaryCard(
                      title: 'Upcoming',
                      value: upcomingTasks.length.toString(),
                      subtitle: 'next few days',
                      icon: Icons.upcoming,
                      iconColor: Colors.deepPurple,
                    ),
                    SummaryGradientCard(
                      title: 'Completed',
                      value: completedTasks.toString(),
                      subtitle: 'total done',
                      gradientColors: const [Color(0xFF22C55E), Color(0xFF16A34A)],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TabNavigation(
                  tabs: const ['Tasks & Schedule', 'Staff Management'],
                  currentTab: _currentTab,
                  onTabChanged: (index) => setState(() => _currentTab = index),
                ),
                const SizedBox(height: 12),
            if(_currentTab==0) 
              TasksTab(
                tasks: tasks,
                todayTasks: todayTasks,
                upcomingTasks: upcomingTasks,
                staff: staff,
                updateTaskStatus: updateTaskStatus,
                addTask: addTask,
              ) 
            else 
              StaffTab(
                staff: staff,
                addStaff: addStaff,
                removeStaff: removeStaff,
                viewStaffSchedule: viewStaffSchedule,
              ),
          ])),
        ),
      ]),
    );
  }
}
