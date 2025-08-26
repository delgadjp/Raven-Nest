import '/constants/app_exports.dart';

class HousekeepingScreen extends StatefulWidget {
  const HousekeepingScreen({super.key});
  @override
  State<HousekeepingScreen> createState() => _HousekeepingScreenState();
}

class _HousekeepingScreenState extends State<HousekeepingScreen> {
  int _currentTab = 0;

  final List<Map<String, dynamic>> tasks = [
    {'id': 1,'room': '201','type': 'checkout_cleaning','assignee': 'Maria Santos','dueDate': DateTime(2025,8,19,14,0),'status': 'completed','priority': 'high','checkoutTime': '11:00 AM','checkinTime': '3:00 PM','notes': 'Deep clean bathroom, replace towels'},
    {'id': 2,'room': '305','type': 'maintenance','assignee': 'John Smith','dueDate': DateTime(2025,8,20,10,0),'status': 'in_progress','priority': 'medium','notes': 'Fix leaky faucet in kitchen'},
    {'id': 3,'room': '412','type': 'room_service','assignee': 'Lisa Chen','dueDate': DateTime(2025,8,20,15,30),'status': 'pending','priority': 'low','notes': 'Guest requested extra towels and coffee pods'},
  ];

  final List<Map<String, dynamic>> staff = [
    {'id': 1,'name': 'Maria Santos','role': 'Head Housekeeper','phone': '(555) 123-4567','email': 'maria@email.com','activeTasks': 3,'completedToday': 2,'rating': 4.9,'status': 'available'},
    {'id': 2,'name': 'John Smith','role': 'Maintenance','phone': '(555) 234-5678','email': 'john@email.com','activeTasks': 1,'completedToday': 1,'rating': 4.7,'status': 'busy'},
    {'id': 3,'name': 'Lisa Chen','role': 'Housekeeper','phone': '(555) 345-6789','email': 'lisa@email.com','activeTasks': 2,'completedToday': 0,'rating': 4.8,'status': 'available'},
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
  int get availableStaff => staff.where((m) => m['status'] == 'available').length;

  void updateTaskStatus(int id, String newStatus) {
    setState(() {
      final i = tasks.indexWhere((t) => t['id'] == id);
      if (i != -1) tasks[i]['status'] = newStatus;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(children:[
        const NavigationWidget(),
        Expanded(child: Container(
          decoration: const BoxDecoration(gradient: LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:[Color(0xFFF8FAFC),Color(0xFFE0F2F1),Color(0xFFB2DFDB)])),
          child: SingleChildScrollView(
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
                    SummaryCard(
                      title: 'Available Staff',
                      value: availableStaff.toString(),
                      subtitle: 'ready now',
                      icon: Icons.people_alt,
                      iconColor: Colors.teal,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TabNavigation(
                  tabs: const ['Tasks', 'Schedule'],
                  currentTab: _currentTab,
                  onTabChanged: (index) => setState(() => _currentTab = index),
                ),
                const SizedBox(height: 12),
            if(_currentTab==0) 
              TasksTab(
                tasks: tasks,
                todayTasks: todayTasks,
                upcomingTasks: upcomingTasks,
                updateTaskStatus: updateTaskStatus,
              ) 
            else 
              StaffTab(staff: staff),
          ])),
        )),
      ]),
    );
  }
}
