import '../constants/app_exports.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isOutlined;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final EdgeInsets padding;

  const ActionButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isOutlined = true,
    this.isFullWidth = true,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    final Widget buttonContent = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon!, size: 16),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: TextStyle(
            color: isOutlined ? (textColor ?? Colors.black87) : Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );

    if (isOutlined) {
      return SizedBox(
        width: isFullWidth ? double.infinity : null,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: borderColor ?? textColor ?? Colors.grey.shade300,
              width: borderColor != null ? 1.5 : 1,
            ),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          child: buttonContent,
        ),
      );
    } else {
      return SizedBox(
        width: isFullWidth ? double.infinity : null,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? const Color(0xFF2563EB),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
            shadowColor: (backgroundColor ?? const Color(0xFF2563EB)).withOpacity(0.3),
          ),
          child: buttonContent,
        ),
      );
    }
  }
}
