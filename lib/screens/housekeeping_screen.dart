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
  // Data matching the React version
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

  // Helpers for colors and icons
  Color getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green.shade600;
      case 'in_progress':
        return Colors.blue.shade600;
      case 'pending':
        return Colors.orange.shade600;
      case 'scheduled':
        return Colors.purple.shade600;
      case 'overdue':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red.shade600;
      case 'medium':
        return Colors.orange.shade600;
      case 'low':
        return Colors.green.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  IconData getTypeIcon(String type) {
    switch (type) {
      case 'checkout_cleaning':
        return Icons.check_circle;
      case 'maintenance':
        return Icons.warning_amber_rounded;
      case 'room_service':
        return Icons.people_alt;
      default:
        return Icons.access_time;
    }
  }

  Color getStaffStatusColor(String status) {
    switch (status) {
      case 'available':
        return Colors.green.shade600;
      case 'busy':
        return Colors.red.shade600;
      case 'offline':
        return Colors.grey.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  void updateTaskStatus(int taskId, String newStatus) {
    setState(() {
      final idx = tasks.indexWhere((t) => t['id'] == taskId);
      if (idx != -1) tasks[idx]['status'] = newStatus;
    });
  }

  List<Map<String, dynamic>> get todayTasks {
    final today = DateTime.now();
    return tasks.where((task) {
      final d = task['dueDate'] as DateTime;
      return d.year == today.year && d.month == today.month && d.day == today.day;
    }).toList();
  }

  List<Map<String, dynamic>> get upcomingTasks {
    final now = DateTime.now();
    return tasks.where((task) => (task['dueDate'] as DateTime).isAfter(now)).toList();
  }

  int get completedTasks => tasks.where((t) => t['status'] == 'completed').length;
  int get pendingTasks => tasks.where((t) => t['status'] != 'completed').length;
  int get availableStaff => staff.where((m) => m['status'] == 'available').length;

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
                              child: const Icon(Icons.people, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Housekeeping Management',
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                Text(
                                  'Manage cleaning schedules and staff',
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Summary Cards
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Wrap(
                            spacing: 24,
                            runSpacing: 24,
                            children: [
                              SizedBox(
                                width: constraints.maxWidth >= 1200 
                                  ? (constraints.maxWidth - 72) / 4 // 4 columns with spacing
                                  : constraints.maxWidth >= 900 
                                    ? (constraints.maxWidth - 24) / 2 // 2 columns with spacing
                                    : constraints.maxWidth, // 1 column
                                child: SummaryCard(
                                  title: "Today's Tasks",
                                  value: todayTasks.length.toString(),
                                  subtitle: 'Due today',
                                  icon: Icons.access_time,
                                  iconColor: AppColors.primaryBlue,
                                ),
                              ),
                              SizedBox(
                                width: constraints.maxWidth >= 1200 
                                  ? (constraints.maxWidth - 72) / 4 // 4 columns with spacing
                                  : constraints.maxWidth >= 900 
                                    ? (constraints.maxWidth - 24) / 2 // 2 columns with spacing
                                    : constraints.maxWidth, // 1 column
                                child: SummaryCard(
                                  title: 'Completed',
                                  value: completedTasks.toString(),
                                  subtitle: 'This week',
                                  icon: Icons.check_circle,
                                  iconColor: AppColors.successGreen,
                                ),
                              ),
                              SizedBox(
                                width: constraints.maxWidth >= 1200 
                                  ? (constraints.maxWidth - 72) / 4 // 4 columns with spacing
                                  : constraints.maxWidth >= 900 
                                    ? (constraints.maxWidth - 24) / 2 // 2 columns with spacing
                                    : constraints.maxWidth, // 1 column
                                child: SummaryCard(
                                  title: 'Pending',
                                  value: pendingTasks.toString(),
                                  subtitle: 'Need attention',
                                  icon: Icons.warning_amber_rounded,
                                  iconColor: AppColors.warningYellow,
                                ),
                              ),
                              SizedBox(
                                width: constraints.maxWidth >= 1200 
                                  ? (constraints.maxWidth - 72) / 4 // 4 columns with spacing
                                  : constraints.maxWidth >= 900 
                                    ? (constraints.maxWidth - 24) / 2 // 2 columns with spacing
                                    : constraints.maxWidth, // 1 column
                                child: SummaryGradientCard(
                                  title: 'Available Staff',
                                  value: availableStaff.toString(),
                                  subtitle: 'Ready to work',
                                ),
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
                        ),                        child: TabBar(
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
  }

  Widget _tabContent() {
    return SizedBox(
      height: 1200,
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildTasksTab(),
          _buildStaffTab(),
        ],
      ),
    );
  }

  // Matches React: Today's Tasks + Upcoming Tasks
  Widget _buildTasksTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTodayTasksCard(),
          const SizedBox(height: 24),
          _buildUpcomingTasksCard(),
        ],
      ),
    );
  }

  Widget _buildTodayTasksCard() {
    return Card(
      color: Colors.white.withOpacity(0.8),
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
                    Text("Today's Tasks", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text('Tasks scheduled for today', style: TextStyle(color: Colors.grey)),
                  ],
                ),                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Task'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(children: todayTasks.map((t) => _buildTaskItem(t)).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(Map<String, dynamic> task) {
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(getTypeIcon(task['type']), size: 18, color: getPriorityColor(task['priority'])),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Room ${task['room']}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(task['type'].toString().replaceAll('_', ' '), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  _chip(task['priority'], getPriorityColor(task['priority'])),
                  const SizedBox(width: 6),
                  _chip(task['status'].toString().replaceAll('_', ' '), getStatusColor(task['status'])),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
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
                  _kv('Assigned to', task['assignee']),
                  _kv('Due Time', dueTime),
                  if (task['checkoutTime'] != null) _kv('Checkout/Checkin', '${task['checkoutTime']} → ${task['checkinTime']}'),
                ],
              );
            },
          ),
          if (task['notes'] != null) ...[
            const SizedBox(height: 12),
            const Align(alignment: Alignment.centerLeft, child: Text('Notes', style: TextStyle(fontSize: 12, color: Colors.grey))),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Text(task['notes'], style: const TextStyle(fontSize: 14, color: Colors.black87)),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (task['status'] == 'pending')
                ElevatedButton(
                  onPressed: () => updateTaskStatus(task['id'] as int, 'in_progress'),
                  child: const Text('Start Task'),
                ),
              if (task['status'] == 'in_progress')
                ElevatedButton(
                  onPressed: () => updateTaskStatus(task['id'] as int, 'completed'),
                  child: const Text('Mark Complete'),
                ),
              if (task['status'] == 'scheduled')
                OutlinedButton(onPressed: () {}, child: const Text('View Details')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(k, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(v, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
    );
  }
  // Upcoming Tasks card matching React
  Widget _buildUpcomingTasksCard() {
    return Card(
      color: Colors.white.withOpacity(0.8),
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
                    Text('Upcoming Tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text('Tasks scheduled for the next few days', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(children: upcomingTasks.take(3).map((t) => _buildUpcomingTaskItem(t)).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingTaskItem(Map<String, dynamic> task) {
    final due = task['dueDate'] as DateTime;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(getTypeIcon(task['type']), size: 18, color: getPriorityColor(task['priority'])),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Room ${task['room']} - ${task['type'].toString().replaceAll('_', ' ')}',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(task['assignee'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${due.month}/${due.day}/${due.year}', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              _chip(task['status'].toString().replaceAll('_', ' '), getStatusColor(task['status'])),
            ],
          ),
        ],
      ),
    );
  }

  // Staff tab matching React layout
  Widget _buildStaffTab() {
    return Card(
      color: Colors.white.withOpacity(0.8),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Staff Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Manage your housekeeping team', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                int cols = 1;
                if (constraints.maxWidth >= 1024) cols = 3;
                else if (constraints.maxWidth >= 768) cols = 2;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: staff.length,
                  itemBuilder: (context, i) => _buildStaffCard(staff[i]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffCard(Map<String, dynamic> m) {
    return Card(
      color: const Color(0xFFF9FAFB),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    Text(m['role'], style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
                _chip(m['status'], getStaffStatusColor(m['status'])),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Contact', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(m['phone']),
            Text(m['email'], style: const TextStyle(color: Colors.blue)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Active Tasks', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('${m['activeTasks']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Completed Today', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('${m['completedToday']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Rating', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('${m['rating']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber)),
                const SizedBox(width: 4),
                const Text('/5.0', style: TextStyle(color: Colors.grey)),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('View Schedule'))),
                const SizedBox(width: 8),
                Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('Assign Task'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

