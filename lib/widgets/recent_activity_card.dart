import 'package:flutter/material.dart';
import 'dart:ui' as ui show ImageFilter;
import 'package:go_router/go_router.dart';
import 'activity_item.dart';

class RecentActivityCard extends StatelessWidget {
  final List<ActivityData> activities;
  final String? viewAllRoute;
  final String? viewAllText;

  const RecentActivityCard({
    super.key,
    required this.activities,
    this.viewAllRoute,
    this.viewAllText = 'View All Notifications',
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.notifications, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Recent Activity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  children: activities.map((activity) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ActivityItem(
                      dotColor: activity.dotColor,
                      backgroundColor: activity.backgroundColor,
                      borderColor: activity.borderColor,
                      title: activity.title,
                      subtitle: activity.subtitle,
                      timeAgo: activity.timeAgo,
                    ),
                  )).toList(),
                ),
                if (viewAllRoute != null) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.go(viewAllRoute!),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                        foregroundColor: Colors.black87,
                      ).copyWith(
                        overlayColor: MaterialStateProperty.resolveWith(
                          (states) {
                            if (states.contains(MaterialState.hovered) ||
                                states.contains(MaterialState.pressed) ||
                                states.contains(MaterialState.focused)) {
                              return Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.08);
                            }
                            return null;
                          },
                        ),
                      ),
                      child: Text(
                        viewAllText!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ActivityData {
  final Color dotColor;
  final Color backgroundColor;
  final Color borderColor;
  final String title;
  final String subtitle;
  final String timeAgo;

  const ActivityData({
    required this.dotColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
  });
}
