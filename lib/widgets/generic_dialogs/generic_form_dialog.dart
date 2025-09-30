import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogField {
  final String key;
  final String label;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool isRequired;
  final List<String>? dropdownItems; // Add dropdown items support
  final List<TextInputFormatter>? inputFormatters; // Add input formatters support

  const DialogField({
    required this.key,
    required this.label,
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.isRequired = true,
    this.dropdownItems,
    this.inputFormatters,
  });
}

class DialogConfig {
  final String title;
  final IconData headerIcon;
  final Color accentColor;
  final String actionButtonText;
  final List<DialogField> fields;
  final Function(Map<String, String>) onSubmit;

  const DialogConfig({
    required this.title,
    required this.headerIcon,
    required this.accentColor,
    required this.actionButtonText,
    required this.fields,
    required this.onSubmit,
  });
}

class GenericFormDialog extends StatefulWidget {
  final DialogConfig config;

  const GenericFormDialog({
    super.key,
    required this.config,
  });

  @override
  State<GenericFormDialog> createState() => _GenericFormDialogState();
}

class _GenericFormDialogState extends State<GenericFormDialog> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String> _dropdownValues = {}; // Add dropdown values storage

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each field
    for (final field in widget.config.fields) {
      if (field.dropdownItems == null) {
        _controllers[field.key] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleSubmit() {
    final values = <String, String>{};
    
    // Validate required fields and collect values
    for (final field in widget.config.fields) {
      String value = '';
      
      if (field.dropdownItems != null) {
        // Get dropdown value
        value = _dropdownValues[field.key] ?? '';
      } else {
        // Get text field value
        value = _controllers[field.key]?.text ?? '';
      }
      
      if (field.isRequired && value.isEmpty) {
        return; // Don't submit if required field is empty
      }
      values[field.key] = value;
    }
    
    // Submit the form
    widget.config.onSubmit(values);
    
    // Clear controllers and dropdown values
    for (final controller in _controllers.values) {
      controller.clear();
    }
    _dropdownValues.clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxDialogHeight = screenHeight * 0.8; // 80% of screen height
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxDialogHeight,
          maxWidth: 400,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.config.accentColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      widget.config.headerIcon,
                      color: widget.config.accentColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.config.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Scrollable Form Fields
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: widget.config.fields.asMap().entries.map((entry) {
                      final index = entry.key;
                      final field = entry.value;
                      return Column(
                        children: [
                          if (index > 0) const SizedBox(height: 16),
                          _buildFieldWidget(field),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: Colors.grey.withValues(alpha: 0.3),
                        ),
                        foregroundColor: Colors.grey.shade700,
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.config.accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        widget.config.actionButtonText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldWidget(DialogField field) {
    // Handle special cases where fields need to be side by side
    if (field.key == 'quantity' || field.key == 'minQuantity') {
      final quantityField = widget.config.fields.firstWhere((f) => f.key == 'quantity');
      final minQuantityField = widget.config.fields.firstWhere((f) => f.key == 'minQuantity');
      
      // Only render once for the quantity field, skip for minQuantity
      if (field.key == 'minQuantity') {
        return const SizedBox.shrink();
      }
      
      return Row(
        children: [
          Expanded(
            child: _buildTextField(
              controller: _controllers[quantityField.key]!,
              field: quantityField,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildTextField(
              controller: _controllers[minQuantityField.key]!,
              field: minQuantityField,
            ),
          ),
        ],
      );
    }
    
    return _buildInputWidget(field);
  }

  Widget _buildInputWidget(DialogField field) {
    if (field.dropdownItems != null) {
      return _buildDropdownField(field);
    } else {
      return _buildTextField(
        controller: _controllers[field.key]!,
        field: field,
      );
    }
  }

  Widget _buildDropdownField(DialogField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.2),
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: _dropdownValues[field.key],
            hint: Row(
              children: [
                Icon(
                  field.icon,
                  color: Colors.grey.shade500,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  field.hintText,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            items: field.dropdownItems!.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Row(
                  children: [
                    Icon(
                      field.icon,
                      color: Colors.grey.shade600,
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _dropdownValues[field.key] = newValue ?? '';
              });
            },
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required DialogField field,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.2),
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: field.keyboardType,
            inputFormatters: field.inputFormatters,
            decoration: InputDecoration(
              hintText: field.hintText,
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
              prefixIcon: Icon(
                field.icon,
                color: Colors.grey.shade500,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
