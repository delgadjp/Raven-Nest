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
  
  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> staff = [];
  Map<String, dynamic> summaryData = {};
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadHousekeepingData();
    
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

  Future<void> _loadHousekeepingData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final results = await Future.wait([
        HousekeepingService.getAllTasks(),
        HousekeepingService.getStaffStatistics(),
        HousekeepingService.getHousekeepingSummary(),
      ]);

      setState(() {
        tasks = results[0] as List<Map<String, dynamic>>;
        staff = results[1] as List<Map<String, dynamic>>;
        summaryData = results[2] as Map<String, dynamic>;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load housekeeping data: $e';
      });
    }
  }

  List<Map<String, dynamic>> get todayTasks { 
    final today = DateTime.now();
    return tasks.where((task) { 
      final dueDate = task['dueDate'] as DateTime;
      return dueDate.year == today.year && 
             dueDate.month == today.month && 
             dueDate.day == today.day; 
    }).toList(); 
  }
  
  int get completedTasks => summaryData['completedTasks'] ?? 0;
  int get totalTasks => summaryData['totalTasks'] ?? 0;
  int get todayTasksCount => summaryData['todayTasks'] ?? 0;

  void updateTaskStatus(String taskId, String newStatus) async {
    final success = await HousekeepingService.updateTaskStatus(taskId, newStatus);
    
    if (success) {
      _loadHousekeepingData(); // Reload data to get updated statistics
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task status updated to $newStatus'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update task status'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Update all task priorities based on current time
  void _updateAllTaskPriorities() async {
    await HousekeepingService.updateTaskPriorities();
    _loadHousekeepingData(); // Reload to get updated priorities
  }

  void addTask(String room, String type, String assignedStaffId, DateTime dueDate, String? checkoutDate, String? checkinDate, String? notes) async {
    final priority = HousekeepingService.calculatePriority(dueDate);
    final priorityWeight = HousekeepingService.getPriorityWeight(priority);
    
    final taskData = {
      'room_number': room,
      'task_type': type,
      'assigned_staff': assignedStaffId,
      'due_date': dueDate.toIso8601String().split('T')[0],
      'checkout_date': checkoutDate,
      'checkin_date': checkinDate,
      'priority': priority,
      'priority_weight': priorityWeight,
      'status': 'pending',
      'notes': notes,
    };

    final success = await HousekeepingService.addTask(taskData);
    
    if (success) {
      _loadHousekeepingData(); // Reload data
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add task'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void assignTaskToStaff(String taskId, String staffId) async {
    final success = await HousekeepingService.assignTaskToStaff(taskId, staffId);
    
    if (success) {
      _loadHousekeepingData(); // Reload data
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task reassigned successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to reassign task'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void addStaff(String name, String role, String phone, String email) async {
    final staffData = {
      'name': name,
      // Note: 'role' is not stored in database schema, only used for UI display
      'contact': phone,
      'email': email,
    };

    final success = await HousekeepingService.addStaff(staffData);
    
    if (success) {
      _loadHousekeepingData(); // Reload data
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Staff member added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add staff member'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void removeStaff(String staffId) async {
    final success = await HousekeepingService.removeStaff(staffId);
    
    if (success) {
      _loadHousekeepingData(); // Reload data
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Staff member removed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to remove staff member'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void viewStaffSchedule(Map<String, dynamic> staffMember) async {
    try {
      // Get all tasks assigned to this staff member
      final staffTasks = await HousekeepingService.getTasksForStaff(staffMember['id']);
      
      if (mounted) {
        // Show the enhanced schedule dialog
        showDialog(
          context: context,
          builder: (context) => StaffScheduleDialog(
            staffMember: staffMember,
            staffTasks: staffTasks,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load staff schedule: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
        if (isLoading)
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else if (errorMessage != null)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading housekeeping data',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage!,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadHousekeepingData,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveCardGrid(
                    children: [
                      SummaryCard(
                        title: "Today's Tasks",
                        value: todayTasksCount.toString(),
                        subtitle: 'scheduled today',
                        icon: Icons.today,
                        iconColor: Colors.indigo,
                      ),
                      SummaryCard(
                        title: 'Total Tasks',
                        value: totalTasks.toString(),
                        subtitle: 'all tasks',
                        icon: Icons.assignment,
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
                  staff: staff,
                  updateTaskStatus: (int id, String status) => updateTaskStatus(id.toString(), status),
                  addTask: (String room, String type, String assignee, DateTime dueDate, String? checkoutTime, String? checkinTime, String? notes) {
                    // Find staff ID from name
                    final staffMember = staff.firstWhere(
                      (s) => s['name'] == assignee,
                      orElse: () => {'id': ''},
                    );
                    addTask(room, type, staffMember['id'], dueDate, checkoutTime, checkinTime, notes);
                  },
                ) 
              else 
                StaffTab(
                  staff: staff,
                  addStaff: addStaff,
                  removeStaff: (int staffId) => removeStaff(staffId.toString()),
                  viewStaffSchedule: viewStaffSchedule,
                ),
            ])),
          ),
      ]),
    );
  }
}
