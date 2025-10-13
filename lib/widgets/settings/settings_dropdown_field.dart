import '../../constants/app_exports.dart';

class SettingsDropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final Color? labelColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final String? helperText;

  const SettingsDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.labelColor,
    this.borderColor,
    this.focusedBorderColor,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveValue = options.contains(value) ? value : null;

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
        DropdownButtonFormField<String>(
          key: ValueKey('${label}_$effectiveValue'),
          initialValue: effectiveValue,
          onChanged: (newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
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
              borderSide:
                  BorderSide(color: focusedBorderColor ?? const Color(0xFF3B82F6)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            helperText: helperText,
          ),
          icon: const Icon(Icons.arrow_drop_down),
          items: options
              .map(
                (option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
