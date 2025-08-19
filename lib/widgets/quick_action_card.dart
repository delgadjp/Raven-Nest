import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Gradient gradient;
  final String route;
  final IconData? trailingIcon;

  const QuickActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.gradient,
    required this.route,
    this.trailingIcon = Icons.trending_up,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.go(route),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                if (trailingIcon != null)
                  Icon(
                    trailingIcon!,
                    color: Colors.white70,
                    size: 22,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
