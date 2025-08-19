import '/constants/app_exports.dart';

class StaffTab extends StatelessWidget {
  final List<Map<String,dynamic>> staff;
  
  const StaffTab({
    super.key,
    required this.staff,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.85),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Staff Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Manage your housekeeping team',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                int cols = 1;
                if (constraints.maxWidth >= 1024) {
                  cols = 3;
                } else if (constraints.maxWidth >= 768) {
                  cols = 2;
                }
                
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
                  itemBuilder: (context, index) => StaffCard(
                    staff: staff[index],
                    onViewSchedule: () => _handleViewSchedule(staff[index]),
                    onAssignTask: () => _handleAssignTask(staff[index]),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleViewSchedule(Map<String, dynamic> staffMember) {
    // Handle view schedule action
    print('View schedule for: ${staffMember['name']}');
  }

  void _handleAssignTask(Map<String, dynamic> staffMember) {
    // Handle assign task action
    print('Assign task to: ${staffMember['name']}');
  }
}
