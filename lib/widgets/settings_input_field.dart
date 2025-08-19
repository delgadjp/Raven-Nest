import '../constants/app_exports.dart';

class SettingsInputField extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final Color? labelColor;
  final Color? borderColor;
  final Color? focusedBorderColor;

  const SettingsInputField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.labelColor,
    this.borderColor,
    this.focusedBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: labelColor ?? const Color(0xFF374151),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: borderColor ?? Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: borderColor ?? Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: focusedBorderColor ?? const Color(0xFF3B82F6)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }
}
