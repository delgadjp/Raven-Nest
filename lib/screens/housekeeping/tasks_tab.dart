import 'package:flutter/material.dart';

class TasksTab extends StatelessWidget {
  final List<Map<String,dynamic>> tasks;
  final List<Map<String,dynamic>> todayTasks;
  final List<Map<String,dynamic>> upcomingTasks;
  final Color Function(String) getPriorityColor;
  final Color Function(String) getStatusColor;
  final IconData Function(String) getTypeIcon;
  final void Function(int,String) updateTaskStatus;
  const TasksTab({super.key,required this.tasks,required this.todayTasks,required this.upcomingTasks,required this.getPriorityColor,required this.getStatusColor,required this.getTypeIcon,required this.updateTaskStatus});

  @override
  Widget build(BuildContext context){
    return Column(crossAxisAlignment: CrossAxisAlignment.start,children:[
      _today(context),
      const SizedBox(height:14),
      _upcoming(context),
    ]);
  }

  Widget _today(BuildContext context){
    return Card(color: Colors.white.withOpacity(0.85),surfaceTintColor: Colors.transparent,elevation:0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),child: Padding(padding: const EdgeInsets.all(16),child: Column(crossAxisAlignment: CrossAxisAlignment.start,children:[
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children:[const Column(crossAxisAlignment: CrossAxisAlignment.start,children:[Text("Today's Tasks",style: TextStyle(fontSize:18,fontWeight:FontWeight.bold)),SizedBox(height:2),Text('Tasks scheduled for today',style: TextStyle(color:Colors.grey))]),ElevatedButton.icon(onPressed:(){},style: ElevatedButton.styleFrom(backgroundColor:Colors.black,foregroundColor:Colors.white,elevation:0,padding: const EdgeInsets.symmetric(horizontal:16,vertical:12),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),icon: const Icon(Icons.add,size:16),label: const Text('Add Task'))]),
      const SizedBox(height:16),
      Column(children: todayTasks.map((t)=>_taskItem(context,t)).toList()),
    ])));
  }

  Widget _taskItem(BuildContext context, Map<String,dynamic> task){
    final due = task['dueDate'] as DateTime; final dueTime = TimeOfDay.fromDateTime(due).format(context);
    return Container(margin: const EdgeInsets.only(bottom:12),padding: const EdgeInsets.all(16),decoration: BoxDecoration(color: const Color(0xFFF8FAFC),border: Border.all(color: const Color(0xFFF1F5F9)),borderRadius: BorderRadius.circular(12)),child: Column(children:[
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,children:[
        Row(children:[Icon(getTypeIcon(task['type']),size:18,color:getPriorityColor(task['priority'])),const SizedBox(width:8),Column(crossAxisAlignment: CrossAxisAlignment.start,children:[Text('Room ${task['room']}',style: const TextStyle(fontWeight:FontWeight.w600)),Text(task['type'].toString().replaceAll('_',' '),style: const TextStyle(fontSize:12,color:Colors.grey))])]),
        Row(children:[_chip(task['priority'],getPriorityColor(task['priority'])),const SizedBox(width:6),_chip(task['status'].toString().replaceAll('_',' '),getStatusColor(task['status']))])
      ]),
      const SizedBox(height:12),
      LayoutBuilder(builder:(context,constraints){final isMd=constraints.maxWidth>=768; return GridView(shrinkWrap:true,physics: const NeverScrollableScrollPhysics(),gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isMd?3:1,crossAxisSpacing:12,mainAxisSpacing:12,childAspectRatio:4),children:[_kv('Assigned to',task['assignee']),_kv('Due Time',dueTime),if(task['checkoutTime']!=null)_kv('Checkout/Checkin','${task['checkoutTime']} → ${task['checkinTime']}')]);}),
      if(task['notes']!=null)...[const SizedBox(height:12),const Align(alignment: Alignment.centerLeft,child: Text('Notes',style: TextStyle(fontSize:12,color:Colors.grey))),const SizedBox(height:6),Container(width:double.infinity,padding: const EdgeInsets.all(10),decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(8)),child: Text(task['notes'],style: const TextStyle(fontSize:14,color:Colors.black87)))],
      const SizedBox(height:12),
      Row(children:[
        if(task['status']=='pending') ElevatedButton(onPressed:()=>updateTaskStatus(task['id'] as int,'in_progress'),child: const Text('Start Task')),
        if(task['status']=='in_progress') ElevatedButton(onPressed:()=>updateTaskStatus(task['id'] as int,'completed'),child: const Text('Mark Complete')),
        if(task['status']=='scheduled') OutlinedButton(onPressed:(){},child: const Text('View Details')),
      ])
    ]));
  }

  Widget _kv(String k,String v)=>Column(crossAxisAlignment: CrossAxisAlignment.start,children:[Text(k,style: const TextStyle(fontSize:12,color:Colors.grey)),const SizedBox(height:2),Text(v,style: const TextStyle(fontWeight:FontWeight.w500))]);
  Widget _chip(String text,Color color)=>Container(padding: const EdgeInsets.symmetric(horizontal:8,vertical:4),decoration: BoxDecoration(color: color.withOpacity(0.1),borderRadius: BorderRadius.circular(12)),child: Text(text,style: TextStyle(fontSize:12,color:color,fontWeight:FontWeight.w600)));

  Widget _upcoming(BuildContext context){
    return Card(color: Colors.white.withOpacity(0.85),surfaceTintColor: Colors.transparent,elevation:0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),child: Padding(padding: const EdgeInsets.all(16),child: Column(crossAxisAlignment: CrossAxisAlignment.start,children:[
      const Column(crossAxisAlignment: CrossAxisAlignment.start,children:[Text('Upcoming Tasks',style: TextStyle(fontSize:18,fontWeight:FontWeight.bold)),SizedBox(height:2),Text('Tasks scheduled for the next few days',style: TextStyle(color:Colors.grey))]),
      const SizedBox(height:16),
      Column(children: upcomingTasks.take(3).map((t)=>_upcomingItem(t)).toList())
    ])));
  }

  Widget _upcomingItem(Map<String,dynamic> task){final due=task['dueDate'] as DateTime; return Container(margin: const EdgeInsets.only(bottom:8),padding: const EdgeInsets.all(12),decoration: BoxDecoration(color: const Color(0xFFF8FAFC),borderRadius: BorderRadius.circular(12)),child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children:[
    Row(children:[Icon(getTypeIcon(task['type']),size:18,color:getPriorityColor(task['priority'])),const SizedBox(width:8),Column(crossAxisAlignment: CrossAxisAlignment.start,children:[Text('Room ${task['room']} - ${task['type'].toString().replaceAll('_',' ')}',style: const TextStyle(fontWeight:FontWeight.w600)),Text(task['assignee'],style: const TextStyle(fontSize:12,color:Colors.grey))])]),
    Column(crossAxisAlignment: CrossAxisAlignment.end,children:[Text('${due.month}/${due.day}/${due.year}',style: const TextStyle(fontWeight:FontWeight.w600)),const SizedBox(height:4),_chip(task['status'].toString().replaceAll('_',' '),getStatusColor(task['status']))])
  ]));}
}
