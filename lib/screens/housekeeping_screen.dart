import 'package:flutter/material.dart';
import '../widgets/navigation.dart';
import '../constants/app_constants.dart';
import '../widgets/summary_card.dart';

class HousekeepingScreen extends StatefulWidget {
  const HousekeepingScreen({super.key});

  @override
  State<HousekeepingScreen> createState() => _HousekeepingScreenState();
}

class _HousekeepingScreenState extends State<HousekeepingScreen> {
  final List<Map<String, dynamic>> tasks = [
    {
      'id': 1,
      'room': '201',
      'type': 'checkout_cleaning',
      'assignee': 'Maria Santos',
      'dueDate': DateTime(2024, 12, 15, 14, 0),
      'status': 'completed',
      'priority': 'high',
      'checkoutTime': '11:00 AM',
      'checkinTime': '3:00 PM',
      'notes': 'Deep clean bathroom, replace towels'
    },
    {
      'id': 2,
      'room': '305',
      'type': 'maintenance',
      'assignee': 'John Smith',
      'dueDate': DateTime(2024, 12, 16, 10, 0),
      'status': 'in_progress',
      'priority': 'medium',
      'notes': 'Fix leaky faucet in kitchen'
    },
    {
      'id': 3,
      'room': '412',
      'type': 'room_service',
      'assignee': 'Lisa Chen',
      'dueDate': DateTime(2024, 12, 16, 15, 30),
      'status': 'pending',
      'priority': 'low',
      'notes': 'Guest requested extra towels and coffee pods'
    },
    {
      'id': 4,
      'room': 'Studio',
      'type': 'checkout_cleaning',
      'assignee': 'Maria Santos',
      'dueDate': DateTime(2024, 12, 17, 11, 0),
      'status': 'scheduled',
      'priority': 'high',
      'checkoutTime': '10:00 AM',
      'checkinTime': '4:00 PM',
      'notes': 'Standard turnover cleaning'
    }
  ];

  final List<Map<String, dynamic>> staff = [
    {
      'id': 1,
      'name': 'Maria Santos',
      'role': 'Head Housekeeper',
      'phone': '(555) 123-4567',
      'email': 'maria@email.com',
      'activeTasks': 3,
      'completedToday': 2,
      'rating': 4.9,
      'status': 'available'
    },
    {
      'id': 2,
      'name': 'John Smith',
      'role': 'Maintenance',
      'phone': '(555) 234-5678',
      'email': 'john@email.com',
      'activeTasks': 1,
      'completedToday': 1,
      'rating': 4.7,
      'status': 'busy'
    },
    {
      'id': 3,
      'name': 'Lisa Chen',
      'role': 'Housekeeper',
      'phone': '(555) 345-6789',
      'email': 'lisa@email.com',
      'activeTasks': 2,
      'completedToday': 0,
      'rating': 4.8,
      'status': 'available'
    }
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'scheduled':
        return Colors.purple;
      case 'overdue':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData getTypeIcon(String type) {
    switch (type) {
      case 'checkout_cleaning':
        return Icons.check_circle;
      case 'maintenance':
        return Icons.warning;
      case 'room_service':
        return Icons.room_service;
      default:
        return Icons.access_time;
    }
  }

  Color getStaffStatusColor(String status) {
    switch (status) {
      case 'available':
        return Colors.green;
      case 'busy':
        return Colors.red;
      case 'offline':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  void updateTaskStatus(int taskId, String newStatus) {
    setState(() {
      final taskIndex = tasks.indexWhere((task) => task['id'] == taskId);
      if (taskIndex != -1) {
        tasks[taskIndex]['status'] = newStatus;
      }
    });
  }

  List<Map<String, dynamic>> get todayTasks {
    final today = DateTime.now();
    return tasks.where((task) {
      final taskDate = task['dueDate'] as DateTime;
      return taskDate.day == today.day &&
          taskDate.month == today.month &&
          taskDate.year == today.year;
    }).toList();
  }

  List<Map<String, dynamic>> get upcomingTasks {
    final today = DateTime.now();
    return tasks.where((task) {
      final taskDate = task['dueDate'] as DateTime;
      return taskDate.isAfter(today);
    }).toList();
  }

  int get completedTasks => tasks.where((task) => task['status'] == 'completed').length;
  int get pendingTasks => tasks.where((task) => task['status'] != 'completed').length;
  int get availableStaff => staff.where((member) => member['status'] == 'available').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const NavigationWidget(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF8FAFC),
                    Color(0xFFE0F2F1),
                    Color(0xFFB2DFDB),
                  ],
                ),
              ),
              child: DefaultTabController(
                length: 2,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    // Header
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.people,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Housekeeping Management',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Manage cleaning schedules and staff',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Summary Cards
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isMd = constraints.maxWidth >= 900;
                        final isLg = constraints.maxWidth >= 1200;
                        int columns = 1;
                        if (isLg) {
                          columns = 4;
                        } else if (isMd) {
                          columns = 4;
                        }
                        return GridView.count(
                          crossAxisCount: columns,
                          childAspectRatio: 3.2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          children: [
                            SummaryCard(
                              title: "Today's Tasks",
                              value: todayTasks.length.toString(),
                              subtitle: 'Due today',
                              icon: Icons.access_time,
                              iconColor: AppColors.primaryBlue,
                            ),
                            SummaryCard(
                              title: 'Completed',
                              value: completedTasks.toString(),
                              subtitle: 'This week',
                              icon: Icons.check_circle,
                              iconColor: AppColors.successGreen,
                            ),
                            SummaryCard(
                              title: 'Pending',
                              value: pendingTasks.toString(),
                              subtitle: 'Need attention',
                              icon: Icons.warning,
                              iconColor: AppColors.warningYellow,
                            ),
                            SummaryGradientCard(
                              title: 'Available Staff',
                              value: availableStaff.toString(),
                              subtitle: 'Ready to work',
                              gradientColors: const [Color(0xFF14B8A6), Color(0xFF0891B2)],
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Tabs
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      height: 44,
                      width: double.infinity,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: TabBar(
                        isScrollable: false,
                        dividerColor: Colors.transparent,
                        labelColor: const Color(0xFF0F172A),
                        unselectedLabelColor: const Color(0xFF64748B),
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorPadding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                        tabs: const [
                          Tab(
                            child: Text(
                              'Tasks & Schedule',
                              style: TextStyle(fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Staff Management',
                              style: TextStyle(fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                      _tabContent(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }  Widget _tabContent() {
    return SizedBox(
      height: 1200, // Enough height to render content within SingleChildScrollView
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(), // Prevent horizontal scrolling
        children: [
          _buildTasksTab(),
          _buildStaffTab(),
        ],
      ),
    );
  }

  Widget _buildTasksTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Today's Tasks
          _buildTodayTasksCard(),
          const SizedBox(height: 24),
          // Upcoming Tasks
          _buildUpcomingTasksCard(),
        ],
      ),
    );
  }

  Widget _buildTodayTasksCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Tasks scheduled for today',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Task'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...todayTasks.map((task) => _buildTaskItem(task)),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingTasksCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upcoming Tasks',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Tasks scheduled for the next few days',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...upcomingTasks.take(3).map((task) => _buildUpcomingTaskItem(task)),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(Map<String, dynamic> task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                getTypeIcon(task['type']),
                size: 16,
                color: getPriorityColor(task['priority']),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Room ${task['room']} - ${task['type'].toString().replaceAll('_', ' ').toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: getPriorityColor(task['priority']).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  task['priority'].toString().toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    color: getPriorityColor(task['priority']),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: getStatusColor(task['status']).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  task['status'].toString().replaceAll('_', ' ').toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    color: getStatusColor(task['status']),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Assignee',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      task['assignee'],
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Due Time',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '${(task['dueDate'] as DateTime).hour.toString().padLeft(2, '0')}:${(task['dueDate'] as DateTime).minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              if (task['checkoutTime'] != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Checkout/Checkin',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        '${task['checkoutTime']} / ${task['checkinTime']}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (task['notes'] != null) ...[
            const SizedBox(height: 12),
            const Text(
              'Notes',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                task['notes'],
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (task['status'] == 'pending')
                ElevatedButton(
                  onPressed: () => updateTaskStatus(task['id'], 'in_progress'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  child: const Text('Start', style: TextStyle(fontSize: 12)),
                ),
              if (task['status'] == 'in_progress') ...[
                ElevatedButton(
                  onPressed: () => updateTaskStatus(task['id'], 'completed'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  child: const Text('Complete', style: TextStyle(fontSize: 12)),
                ),
              ],
              if (task['status'] == 'scheduled')
                ElevatedButton(
                  onPressed: () => updateTaskStatus(task['id'], 'pending'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  child: const Text('Ready', style: TextStyle(fontSize: 12)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingTaskItem(Map<String, dynamic> task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            getTypeIcon(task['type']),
            size: 16,
            color: getPriorityColor(task['priority']),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Room ${task['room']} - ${task['type'].toString().replaceAll('_', ' ')}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  task['assignee'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(task['dueDate'] as DateTime).day}/${(task['dueDate'] as DateTime).month}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: getStatusColor(task['status']).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  task['status'].toString().replaceAll('_', ' ').toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    color: getStatusColor(task['status']),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStaffTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Staff Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Manage your housekeeping team',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 1024 ? 3 : 
                             MediaQuery.of(context).size.width > 768 ? 2 : 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: staff.length,
            itemBuilder: (context, index) => _buildStaffCard(staff[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffCard(Map<String, dynamic> member) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        member['role'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: getStaffStatusColor(member['status']).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    member['status'].toString().toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      color: getStaffStatusColor(member['status']),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Contact',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  member['phone'],
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  member['email'],
                  style: const TextStyle(fontSize: 14, color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Active Tasks',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        member['activeTasks'].toString(),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Completed Today',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        member['completedToday'].toString(),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rating',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      member['rating'].toString(),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text('View Schedule', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text('Assign Task', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
