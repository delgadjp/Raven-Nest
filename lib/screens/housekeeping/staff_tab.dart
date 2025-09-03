import '/constants/app_exports.dart';

class StaffTab extends StatelessWidget {
  final List<Map<String,dynamic>> staff;
  final void Function(String, String, String, String)? addStaff;
  final void Function(int)? removeStaff;
  final void Function(Map<String, dynamic>)? viewStaffSchedule;
  
  const StaffTab({
    super.key,
    required this.staff,
    this.addStaff,
    this.removeStaff,
    this.viewStaffSchedule,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Staff Management',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _showAddStaffDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.person_add, size: 14),
                  label: const Text('Add Staff', style: TextStyle(fontSize: 14)),
                ),
              ],
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
                    childAspectRatio: 1.45,
                  ),
                  itemCount: staff.length,
                  itemBuilder: (context, index) => StaffCard(
                    staff: staff[index],
                    onViewSchedule: () => _handleViewSchedule(staff[index]),
                    onRemoveStaff: () => _handleRemoveStaff(staff[index], context),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddStaffDialog(BuildContext context) {
    if (addStaff == null) return;
    
    showDialog(
      context: context,
      builder: (context) => GenericFormDialog(
        config: DialogConfigurations.addStaff(
          onAdd: addStaff!,
        ),
      ),
    );
  }

  void _handleViewSchedule(Map<String, dynamic> staffMember) {
    if (viewStaffSchedule != null) {
      viewStaffSchedule!(staffMember);
    } else {
      // Fallback behavior
      print('View schedule for: ${staffMember['name']}');
    }
  }

  void _handleRemoveStaff(Map<String, dynamic> staffMember, BuildContext context) {
    if (removeStaff == null) return;
    
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Staff Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to remove ${staffMember['name']} from the staff?'),
            const SizedBox(height: 8),
            if (staffMember['activeTasks'] > 0)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This staff member has ${staffMember['activeTasks']} active task(s). These will be reassigned as "Unassigned".',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              removeStaff!(staffMember['id']);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${staffMember['name']} has been removed from staff'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
