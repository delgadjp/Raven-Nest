import 'package:flutter/material.dart';

class SectionHeaderWithAction extends StatelessWidget {
  final String title;
  final VoidCallback? onActionPressed;
  final String actionText;
  final IconData actionIcon;
  final Color actionBackgroundColor;
  final Color actionTextColor;
  final VoidCallback? onDelete;

  const SectionHeaderWithAction({
    super.key,
    required this.title,
    this.onActionPressed,
    this.actionText = 'Add Item',
    this.actionIcon = Icons.add,
    this.actionBackgroundColor = Colors.black,
    this.actionTextColor = Colors.white,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (onDelete != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Delete Category',
                  ),
                ],
              ],
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
