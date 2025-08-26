import 'package:flutter/material.dart';
import 'generic_form_dialog.dart';

class DialogConfigurations {
  // Add Category Dialog Configuration
  static DialogConfig addCategory({
    required Function(String name) onAdd,
  }) {
    return DialogConfig(
      title: 'Add New Category',
      headerIcon: Icons.category_outlined,
      accentColor: Colors.black87,
      actionButtonText: 'Add Category',
      fields: [
        const DialogField(
          key: 'name',
          label: 'Category Name',
          hintText: 'e.g., Kitchen Supplies, Maintenance',
          icon: Icons.category,
        ),
      ],
      onSubmit: (values) {
        onAdd(values['name']!);
      },
    );
  }

  // Add Item Dialog Configuration
  static DialogConfig addItem({
    required String categoryName,
    required Function(String name, int quantity, int minQuantity, String unit) onAdd,
  }) {
    return DialogConfig(
      title: 'Add New $categoryName',
      headerIcon: Icons.inventory_2,
      accentColor: const Color(0xFF3B82F6),
      actionButtonText: 'Add Item',
      fields: [
        const DialogField(
          key: 'name',
          label: 'Item Name',
          hintText: 'e.g., All-Purpose Cleaner',
          icon: Icons.inventory_2,
        ),
        const DialogField(
          key: 'quantity',
          label: 'Current Quantity',
          hintText: '0',
          icon: Icons.numbers,
          keyboardType: TextInputType.number,
        ),
        const DialogField(
          key: 'minQuantity',
          label: 'Minimum Quantity',
          hintText: '0',
          icon: Icons.warning_amber,
          keyboardType: TextInputType.number,
        ),
        const DialogField(
          key: 'unit',
          label: 'Unit',
          hintText: 'e.g., bottles, rolls, pcs',
          icon: Icons.straighten,
        ),
      ],
      onSubmit: (values) {
        final quantity = int.tryParse(values['quantity']!) ?? 0;
        final minQuantity = int.tryParse(values['minQuantity']!) ?? 0;
        onAdd(values['name']!, quantity, minQuantity, values['unit']!);
      },
    );
  }

  // Add Expense Dialog Configuration
  static DialogConfig addExpense({
    required String title,
    required Function(String name, double amount, String category) onAdd,
  }) {
    return DialogConfig(
      title: title,
      headerIcon: Icons.add,
      accentColor: const Color(0xFF10B981),
      actionButtonText: 'Add Expense',
      fields: [
        const DialogField(
          key: 'name',
          label: 'Expense Name',
          hintText: 'e.g., Internet Bill',
          icon: Icons.receipt_long,
        ),
        const DialogField(
          key: 'amount',
          label: 'Amount (\$)',
          hintText: '0.00',
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
        ),
        const DialogField(
          key: 'category',
          label: 'Category',
          hintText: 'e.g., Bills, Maintenance',
          icon: Icons.category,
        ),
      ],
      onSubmit: (values) {
        final amount = double.tryParse(values['amount']!) ?? 0;
        onAdd(values['name']!, amount, values['category']!);
      },
    );
  }
}
