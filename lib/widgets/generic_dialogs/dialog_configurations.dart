import 'package:flutter/services.dart';
import '../../constants/app_exports.dart';
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
    required Function(String name, double amount) onAdd,
    List<Map<String, dynamic>>? categories,
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
        DialogField(
          key: 'amount',
          label: 'Amount (\$)',
          hintText: '0.00',
          icon: Icons.attach_money,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
        ),
      ],
      onSubmit: (values) {
        final amount = double.tryParse(values['amount']!) ?? 0;
        onAdd(values['name']!, amount);
      },
    );
  }

  // Add Task Dialog Configuration
  static DialogConfig addTask({
    required Function(String room, String type, String assignee, DateTime dueDate, String? checkoutDate, String? checkinDate, String? notes) onAdd,
    required List<Map<String, dynamic>> staff,
  }) {
    // Extract staff names for dropdown
    final staffNames = staff.map((s) => s['name'] as String).toList();
    
    return DialogConfig(
      title: 'Add New Task',
      headerIcon: Icons.task_alt,
      accentColor: const Color(0xFF6366F1),
      actionButtonText: 'Create Task',
      fields: [
        const DialogField(
          key: 'room',
          label: 'Room Number',
          hintText: 'e.g., 201, Studio, 305',
          icon: Icons.room,
        ),
        const DialogField(
          key: 'type',
          label: 'Task Type',
          hintText: 'Select task type',
          icon: Icons.category,
          type: DialogFieldType.dropdown,
          dropdownItems: [
            'Check-out Cleaning',
            'Room Service',
          ],
        ),
        DialogField(
          key: 'assignee',
          label: 'Assign To',
          hintText: 'Select staff member',
          icon: Icons.person,
          type: DialogFieldType.dropdown,
          dropdownItems: staffNames,
        ),
        const DialogField(
          key: 'dueDate',
          label: 'Due Date',
          hintText: 'Select date',
          icon: Icons.calendar_today,
          type: DialogFieldType.datePicker,
        ),
        const DialogField(
          key: 'checkoutDate',
          label: 'Checkout Date (Optional)',
          hintText: 'Select checkout date',
          icon: Icons.logout,
          type: DialogFieldType.datePicker,
          isRequired: false,
        ),
        const DialogField(
          key: 'checkinDate',
          label: 'Check-in Date (Optional)',
          hintText: 'Select check-in date',
          icon: Icons.login,
          type: DialogFieldType.datePicker,
          isRequired: false,
        ),
        const DialogField(
          key: 'notes',
          label: 'Notes (Optional)',
          hintText: 'Additional instructions or details',
          icon: Icons.note,
          isRequired: false,
        ),
      ],
      onSubmit: (values) {
        // Parse due date
        final dateParts = values['dueDate']!.split('/');
        final dueDate = DateTime(
          int.parse(dateParts[2]), // year
          int.parse(dateParts[0]), // month
          int.parse(dateParts[1]), // day
        );
        
        onAdd(
          values['room']!,
          values['type']!,
          values['assignee']!,
          dueDate,
          values['checkoutDate']?.isEmpty == true ? null : values['checkoutDate'],
          values['checkinDate']?.isEmpty == true ? null : values['checkinDate'],
          values['notes']?.isEmpty == true ? null : values['notes'],
        );
      },
    );
  }

  // Assign Task to Staff Dialog Configuration
  static DialogConfig assignTaskToStaff({
    required Map<String, dynamic> task,
    required List<Map<String, dynamic>> availableStaff,
    required Function(int taskId, String staffName) onAssign,
  }) {
    return DialogConfig(
      title: 'Assign Task to Staff',
      headerIcon: Icons.assignment_ind,
      accentColor: const Color(0xFF059669),
      actionButtonText: 'Assign Task',
      fields: [
        DialogField(
          key: 'taskInfo',
          label: 'Task',
          hintText: 'Room ${task['room']} - ${task['type']}',
          icon: Icons.task,
          isRequired: false,
        ),
        const DialogField(
          key: 'assignee',
          label: 'Assign To',
          hintText: 'Select available staff member',
          icon: Icons.person,
        ),
      ],
      onSubmit: (values) {
        onAssign(task['id'], values['assignee']!);
      },
    );
  }

  // Add Staff Dialog Configuration
  static DialogConfig addStaff({
    required Function(String name, String role, String phone, String email) onAdd,
  }) {
    return DialogConfig(
      title: 'Add New Staff Member',
      headerIcon: Icons.person_add,
      accentColor: const Color(0xFF6366F1),
      actionButtonText: 'Add Staff',
      fields: [
        const DialogField(
          key: 'name',
          label: 'Full Name',
          hintText: 'e.g., Maria Santos',
          icon: Icons.person,
        ),
        const DialogField(
          key: 'role',
          label: 'Role',
          hintText: 'e.g., Housekeeper, Maintenance, Head Housekeeper',
          icon: Icons.work,
        ),
        const DialogField(
          key: 'phone',
          label: 'Phone Number',
          hintText: 'e.g., (555) 123-4567',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
        ),
        const DialogField(
          key: 'email',
          label: 'Email Address',
          hintText: 'e.g., maria@email.com',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
      onSubmit: (values) {
        onAdd(
          values['name']!,
          values['role']!,
          values['phone']!,
          values['email']!,
        );
      },
    );
  }
}
