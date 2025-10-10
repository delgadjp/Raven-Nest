import 'package:flutter/material.dart';

class ImportResultMessage extends StatelessWidget {
  final String message;

  const ImportResultMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isError = message.contains('failed') || 
                   message.contains('Error') || 
                   message.contains('❌');
    final isSuccess = message.contains('🎉') || 
                     message.contains('✓') || 
                     message.contains('Complete');
    final isProgress = message.contains('Importing') || 
                      message.contains('Please wait');

    Color backgroundColor;
    Color borderColor;
    Color textColor;
    IconData icon;

    if (isError) {
      backgroundColor = Colors.red.shade50;
      borderColor = Colors.red.shade200;
      textColor = Colors.red.shade700;
      icon = Icons.error_outline;
    } else if (isSuccess) {
      backgroundColor = Colors.green.shade50;
      borderColor = Colors.green.shade200;
      textColor = Colors.green.shade700;
      icon = Icons.check_circle_outline;
    } else if (isProgress) {
      backgroundColor = Colors.blue.shade50;
      borderColor = Colors.blue.shade200;
      textColor = Colors.blue.shade700;
      icon = Icons.sync;
    } else {
      backgroundColor = Colors.orange.shade50;
      borderColor = Colors.orange.shade200;
      textColor = Colors.orange.shade700;
      icon = Icons.info_outline;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: borderColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: isProgress
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    ),
                  )
                : Icon(
                    icon,
                    size: 16,
                    color: textColor,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                color: textColor,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}