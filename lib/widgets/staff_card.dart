import 'package:flutter/material.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/info_row.dart';
import '../../constants/housekeeping_helpers.dart';

class StaffCard extends StatelessWidget {
  final Map<String, dynamic> staff;
  final VoidCallback? onViewSchedule;
  final VoidCallback? onAssignTask;

  const StaffCard({
    super.key,
    required this.staff,
    this.onViewSchedule,
    this.onAssignTask,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF9FAFB),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with name, role, and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        staff['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        staff['role'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                StatusChip(
                  text: staff['status'],
                  color: HousekeepingHelpers.getStatusColor(staff['status']),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Contact Information
            const Text(
              'Contact',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              staff['phone'],
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF111827),
              ),
            ),
            Text(
              staff['email'],
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF2563EB),
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: InfoRow(
                    label: 'Active Tasks',
                    value: '${staff['activeTasks']}',
                    valueColor: const Color(0xFF2563EB),
                    valueFontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: InfoRow(
                    label: 'Completed Today',
                    value: '${staff['completedToday']}',
                    valueColor: const Color(0xFF16A34A),
                    valueFontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Rating
            Row(
              children: [
                const Text(
                  'Rating: ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${staff['rating']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEAB308),
                  ),
                ),
                const Text(
                  '/5.0',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
            const Spacer(),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFD1D5DB)),
                      foregroundColor: const Color(0xFF374151),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: onViewSchedule,
                    child: const Text(
                      'View Schedule',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF111827),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: onAssignTask,
                    child: const Text(
                      'Assign Task',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
