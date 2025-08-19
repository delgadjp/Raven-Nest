import 'package:flutter/material.dart';

class StaffTab extends StatelessWidget {
  final List<Map<String,dynamic>> staff;
  final Color Function(String) getStaffStatusColor;
  const StaffTab({super.key,required this.staff,required this.getStaffStatusColor});

  @override
  Widget build(BuildContext context){
    return Card(color: Colors.white.withOpacity(0.85),surfaceTintColor: Colors.transparent,elevation:0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),child: Padding(padding: const EdgeInsets.all(16),child: Column(crossAxisAlignment: CrossAxisAlignment.start,children:[
      const Text('Staff Overview',style: TextStyle(fontSize:18,fontWeight:FontWeight.bold)),
      const SizedBox(height:4),
      const Text('Manage your housekeeping team',style: TextStyle(color:Colors.grey)),
      const SizedBox(height:12),
      LayoutBuilder(builder:(context,constraints){int cols=1; if(constraints.maxWidth>=1024) cols=3; else if(constraints.maxWidth>=768) cols=2; return GridView.builder(shrinkWrap:true,physics: const NeverScrollableScrollPhysics(),gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:cols,crossAxisSpacing:16,mainAxisSpacing:16,childAspectRatio:1.1),itemCount: staff.length,itemBuilder:(c,i)=>_staffCard(staff[i]));})
    ])));
  }

  Widget _staffCard(Map<String,dynamic> m){
    return Card(color: const Color(0xFFF9FAFB),elevation:0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: const BorderSide(color: Color(0xFFE5E7EB))),child: Padding(padding: const EdgeInsets.all(12),child: Column(crossAxisAlignment: CrossAxisAlignment.start,children:[
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,children:[Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children:[Text(m['name'],style: const TextStyle(fontSize:16,fontWeight:FontWeight.w600,color: Color(0xFF111827)),overflow: TextOverflow.ellipsis),Text(m['role'],style: const TextStyle(fontSize:12,color: Color(0xFF6B7280)))],)),Container(padding: const EdgeInsets.symmetric(horizontal:8,vertical:2),decoration: BoxDecoration(color: getStaffStatusColor(m['status']).withOpacity(0.1),borderRadius: BorderRadius.circular(12),border: Border.all(color: getStaffStatusColor(m['status']).withOpacity(0.2))),child: Text(m['status'],style: TextStyle(fontSize:12,fontWeight:FontWeight.w600,color: getStaffStatusColor(m['status']))))]),
      const SizedBox(height:8),
      const Text('Contact',style: TextStyle(fontSize:11,color: Color(0xFF6B7280),fontWeight: FontWeight.w500)),
      const SizedBox(height:2),
      Text(m['phone'],style: const TextStyle(fontSize:13,color: Color(0xFF111827))),
      Text(m['email'],style: const TextStyle(fontSize:13,color: Color(0xFF2563EB)),overflow: TextOverflow.ellipsis),
      const SizedBox(height:8),
      Row(children:[Expanded(child: _stat('Active Tasks','${m['activeTasks']}',const Color(0xFF2563EB))),Expanded(child: _stat('Completed Today','${m['completedToday']}',const Color(0xFF16A34A)))]),
      const SizedBox(height:8),
      Row(children:[const Text('Rating: ',style: TextStyle(fontSize:12,color: Color(0xFF6B7280),fontWeight: FontWeight.w500)),Text('${m['rating']}',style: const TextStyle(fontSize:18,fontWeight:FontWeight.bold,color: Color(0xFFEAB308))),const Text('/5.0',style: TextStyle(fontSize:14,color: Color(0xFF6B7280)))]),
      const Spacer(),
      Row(children:[Expanded(child: OutlinedButton(style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFD1D5DB)),foregroundColor: const Color(0xFF374151),backgroundColor: Colors.white,padding: const EdgeInsets.symmetric(vertical:6),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),onPressed:(){},child: const Text('View Schedule',style: TextStyle(fontSize:12,fontWeight:FontWeight.bold)))),const SizedBox(width:6),Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF111827),foregroundColor: Colors.white,elevation:0,padding: const EdgeInsets.symmetric(vertical:6),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),onPressed:(){},child: const Text('Assign Task',style: TextStyle(fontSize:12,fontWeight:FontWeight.w500))))])
    ])));
  }

  Widget _stat(String label,String value,Color color){return Column(crossAxisAlignment: CrossAxisAlignment.start,children:[Text(label,style: const TextStyle(fontSize:11,color: Color(0xFF6B7280),fontWeight: FontWeight.w500)),Text(value,style: TextStyle(fontSize:18,fontWeight:FontWeight.bold,color: color))]);}
}
