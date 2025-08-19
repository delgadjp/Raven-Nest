import 'package:flutter/material.dart';
import '../widgets/navigation.dart';
import '../widgets/summary_card.dart';
import 'housekeeping/tasks_tab.dart';
import 'housekeeping/staff_tab.dart';

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
    {'id': 4,'room': 'Studio','type': 'checkout_cleaning','assignee': 'Maria Santos','dueDate': DateTime(2025,8,21,11,0),'status': 'scheduled','priority': 'high','checkoutTime': '10:00 AM','checkinTime': '4:00 PM','notes': 'Standard turnover cleaning'},
  ];

  final List<Map<String, dynamic>> staff = [
    {'id': 1,'name': 'Maria Santos','role': 'Head Housekeeper','phone': '(555) 123-4567','email': 'maria@email.com','activeTasks': 3,'completedToday': 2,'rating': 4.9,'status': 'available'},
    {'id': 2,'name': 'John Smith','role': 'Maintenance','phone': '(555) 234-5678','email': 'john@email.com','activeTasks': 1,'completedToday': 1,'rating': 4.7,'status': 'busy'},
    {'id': 3,'name': 'Lisa Chen','role': 'Housekeeper','phone': '(555) 345-6789','email': 'lisa@email.com','activeTasks': 2,'completedToday': 0,'rating': 4.8,'status': 'available'},
  ];

  List<Map<String, dynamic>> get todayTasks { final t = DateTime.now(); return tasks.where((task){ final d=task['dueDate'] as DateTime; return d.year==t.year&&d.month==t.month&&d.day==t.day; }).toList(); }
  List<Map<String, dynamic>> get upcomingTasks { final now=DateTime.now(); return tasks.where((task)=>(task['dueDate'] as DateTime).isAfter(now)).toList(); }
  int get completedTasks => tasks.where((t)=>t['status']=='completed').length;
  int get availableStaff => staff.where((m)=>m['status']=='available').length;

  Color getStatusColor(String status){switch(status){case 'completed':return Colors.green.shade600;case 'in_progress':return Colors.blue.shade600;case 'pending':return Colors.orange.shade600;case 'scheduled':return Colors.purple.shade600;case 'overdue':return Colors.red.shade600;default:return Colors.grey.shade600;}}
  Color getPriorityColor(String p){switch(p){case 'high':return Colors.red.shade600;case 'medium':return Colors.orange.shade600;case 'low':return Colors.green.shade600;default:return Colors.grey.shade600;}}
  IconData getTypeIcon(String t){switch(t){case 'checkout_cleaning':return Icons.check_circle;case 'maintenance':return Icons.warning_amber_rounded;case 'room_service':return Icons.room_service_outlined;default:return Icons.access_time;}}
  Color getStaffStatusColor(String s){switch(s){case 'available':return Colors.green.shade600;case 'busy':return Colors.red.shade600;case 'offline':return Colors.grey.shade600;default:return Colors.grey.shade600;}}
  void updateTaskStatus(int id,String ns){setState((){final i=tasks.indexWhere((t)=>t['id']==id);if(i!=-1)tasks[i]['status']=ns;});}

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(children:[
        const NavigationWidget(),
        Expanded(child: Container(
          decoration: const BoxDecoration(gradient: LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:[Color(0xFFF8FAFC),Color(0xFFE0F2F1),Color(0xFFB2DFDB)])),
          child: SingleChildScrollView(padding: const EdgeInsets.all(16),child: Column(crossAxisAlignment: CrossAxisAlignment.start,children:[
            _header(),
            _summaryCards(),
            const SizedBox(height:24),
            _tabs(),
            const SizedBox(height:12),
            if(_currentTab==0) TasksTab(tasks:tasks,todayTasks:todayTasks,upcomingTasks:upcomingTasks,getPriorityColor:getPriorityColor,getStatusColor:getStatusColor,getTypeIcon:getTypeIcon,updateTaskStatus:updateTaskStatus) else StaffTab(staff:staff,getStaffStatusColor:getStaffStatusColor),
          ])),
        )),
      ]),
    );
  }

  Widget _header(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.teal.shade600, // matches bg-teal-600 from React header
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.shade600.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: const Icon(Icons.people_alt_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Housekeeping Management',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827), // gray-900 equivalent
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Manage cleaning schedules and staff',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B), // slate-500/gray-600 tone
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCards(){
    return LayoutBuilder(builder:(context,constraints){final maxW=constraints.maxWidth;int cols=1; if(maxW>=1200) cols=4; else if(maxW>=920) cols=3; else if(maxW>=600) cols=2; const gap=16.0; final itemW=(maxW-(cols-1)*gap)/cols; return Wrap(spacing:gap,runSpacing:gap,children:[
      SizedBox(width:itemW,child: SummaryCard(title:"Today's Tasks",value: todayTasks.length.toString(),subtitle:'scheduled today',icon:Icons.today,iconColor:Colors.indigo)),
      SizedBox(width:itemW,child: SummaryCard(title:'Upcoming',value: upcomingTasks.length.toString(),subtitle:'next few days',icon:Icons.upcoming,iconColor:Colors.deepPurple)),
      SizedBox(width:itemW,child: SummaryGradientCard(title:'Completed',value: completedTasks.toString(),subtitle:'total done',gradientColors: const [Color(0xFF22C55E),Color(0xFF16A34A)])),
      SizedBox(width:itemW,child: SummaryCard(title:'Available Staff',value: availableStaff.toString(),subtitle:'ready now',icon:Icons.people_alt,iconColor:Colors.teal)),
    ]);});
  }

  Widget _tabs(){
    return Container(
      height:44,
      width:double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9),borderRadius: BorderRadius.circular(6)),
      child: Row(children:[_tabButton('Tasks',0),_tabButton('Schedule',1)]));
  }

  Widget _tabButton(String label,int index){final active=_currentTab==index; return Expanded(child: GestureDetector(onTap:()=>setState(()=>_currentTab=index),child: AnimatedContainer(duration: const Duration(milliseconds:180),margin: const EdgeInsets.symmetric(horizontal:2),decoration: BoxDecoration(color: active?Colors.white:Colors.transparent,borderRadius: BorderRadius.circular(4),boxShadow: active?[BoxShadow(color: Colors.black.withOpacity(0.05),blurRadius:4,offset: const Offset(0,2))]:null),alignment: Alignment.center,child: Text(label,style: TextStyle(fontSize:14,fontWeight:FontWeight.w600,color: active? const Color(0xFF0F172A): const Color(0xFF64748B))))));}
}
