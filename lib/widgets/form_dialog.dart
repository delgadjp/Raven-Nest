import 'package:flutter/material.dart';

typedef ValidationFunction = String? Function(String?);

class FormDialog extends StatelessWidget {
  final String title;
  final List<DialogFormField> fields;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;
  final String submitButtonText;
  final String cancelButtonText;

  const FormDialog({
    super.key,
    required this.title,
    required this.fields,
    required this.onCancel,
    required this.onSubmit,
    this.submitButtonText = 'Submit',
    this.cancelButtonText = 'Cancel',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < fields.length; i++) ...[
              if (fields[i].isRow && i + 1 < fields.length)
                Row(
                  children: [
                    Expanded(child: _buildField(fields[i])),
                    const SizedBox(width: 12),
                    Expanded(child: _buildField(fields[i + 1])),
                  ],
                )
              else if (!fields[i].isRow || i == 0 || !fields[i - 1].isRow)
                _buildField(fields[i]),
              if (i < fields.length - 1 && !fields[i].isRow) 
                const SizedBox(height: 12),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(cancelButtonText),
        ),
        ElevatedButton(
          onPressed: onSubmit,
          child: Text(submitButtonText),
        ),
      ],
    );
  }

  Widget _buildField(DialogFormField field) {
    return TextField(
      controller: field.controller,
      decoration: InputDecoration(labelText: field.label),
      keyboardType: field.keyboardType,
    );
  }
}

class DialogFormField {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final ValidationFunction? validator;
  final bool isRow;

  DialogFormField({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.isRow = false,
  });
}
