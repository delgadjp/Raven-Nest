import 'package:flutter/material.dart';

class AddExpenseDialog extends StatefulWidget {
  final String title;
  final Function(String name, double amount, String category) onAdd;

  const AddExpenseDialog({
    super.key,
    required this.title,
    required this.onAdd,
  });

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _handleAdd() {
    if (_nameController.text.isNotEmpty &&
        _amountController.text.isNotEmpty &&
        _categoryController.text.isNotEmpty) {
      final amount = double.tryParse(_amountController.text) ?? 0;
      widget.onAdd(_nameController.text, amount, _categoryController.text);
      _nameController.clear();
      _amountController.clear();
      _categoryController.clear();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Expense Name'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'Amount (\$)'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _categoryController,
            decoration: const InputDecoration(labelText: 'Category'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleAdd,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
