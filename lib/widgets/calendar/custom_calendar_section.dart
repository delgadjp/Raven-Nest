import 'package:flutter/material.dart';

class CustomCalendarSection extends StatelessWidget {
  final bool showCustom;
  final VoidCallback onToggle;
  final TextEditingController nameController;
  final TextEditingController urlController;
  final String? Function(String?)? nameValidator;
  final String? Function(String?)? urlValidator;

  const CustomCalendarSection({
    super.key,
    required this.showCustom,
    required this.onToggle,
    required this.nameController,
    required this.urlController,
    this.nameValidator,
    this.urlValidator,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: showCustom ? Colors.purple.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: showCustom ? Colors.purple.shade200 : Colors.grey.shade200,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: showCustom ? Colors.purple.shade600 : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Custom Calendar',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: showCustom ? Colors.purple.shade700 : Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          'Add VRBO, direct bookings, or other platforms',
                          style: TextStyle(
                            fontSize: 12,
                            color: showCustom ? Colors.purple.shade600 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: showCustom ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.expand_more,
                      color: showCustom ? Colors.purple.shade600 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Animated Custom Fields
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: showCustom ? Column(
              children: [
                const SizedBox(height: 16),
                _buildStyledTextField(
                  controller: nameController,
                  label: 'Calendar Name',
                  hint: 'e.g., VRBO, Direct Bookings',
                  icon: Icons.label_outline,
                  validator: nameValidator,
                ),
                const SizedBox(height: 12),
                _buildStyledTextField(
                  controller: urlController,
                  label: 'iCal URL',
                  hint: 'https://example.com/calendar.ics',
                  icon: Icons.link,
                  validator: urlValidator,
                ),
              ],
            ) : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.purple.shade400),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.purple.shade400, width: 2),
        ),
        contentPadding: const EdgeInsets.all(12),
      ),
      validator: validator,
    );
  }
}