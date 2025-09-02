import 'package:flutter/material.dart';

class SectionHeaderWithAction extends StatelessWidget {
  final String title;
  final VoidCallback? onActionPressed;
  final String actionText;
  final IconData actionIcon;
  final Color actionBackgroundColor;
  final Color actionTextColor;

  const SectionHeaderWithAction({
    super.key,
    required this.title,
    this.onActionPressed,
    this.actionText = 'Add Item',
    this.actionIcon = Icons.add,
    this.actionBackgroundColor = Colors.black,
    this.actionTextColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: actionBackgroundColor,
              foregroundColor: actionTextColor,
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onActionPressed ?? () {},
            icon: Icon(actionIcon, size: 18),
            label: Text(actionText),
          ),
        ],
      ),
    );
  }
}
