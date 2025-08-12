import 'package:flutter/material.dart';
import '../widgets/navigation.dart';
import '../widgets/summary_card.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  // Static fixed expenses (read-only)
  final List<Map<String, dynamic>> fixedExpenses = const [
    {'id': 1, 'name': 'Mortgage/Rent', 'amount': 1500, 'category': 'Housing'},
    {'id': 2, 'name': 'Property Insurance', 'amount': 200, 'category': 'Insurance'},
    {'id': 3, 'name': 'Property Tax', 'amount': 300, 'category': 'Taxes'},
    {'id': 4, 'name': 'HOA Fees', 'amount': 150, 'category': 'Fees'},
  ];

  // Starting data for variable expenses (mutable copy is created in initState)
  final List<Map<String, dynamic>> _initialVariable = const [
    {'id': 1, 'name': 'Utilities', 'amount': 180, 'category': 'Bills'},
    {'id': 2, 'name': 'Cleaning Supplies', 'amount': 85, 'category': 'Maintenance'},
    {'id': 3, 'name': 'Repairs', 'amount': 250, 'category': 'Maintenance'},
  ];

  late List<Map<String, dynamic>> variableExpenses;

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();

  double get fixedTotal => fixedExpenses.fold(0.0, (sum, e) => sum + (e['amount'] as num).toDouble());
  double get variableTotal => variableExpenses.fold(0.0, (sum, e) => sum + (e['amount'] as num).toDouble());
  double get grandTotal => fixedTotal + variableTotal;

  @override
  void initState() {
    super.initState();
    variableExpenses = List<Map<String, dynamic>>.from(_initialVariable);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const NavigationWidget(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF8FAFC), // slate-50
                    Color(0xFFECFDF5), // emerald-50
                    Color(0xFFD1FAE5), // green-100/50
                  ],
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF16A34A),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.attach_money, color: Colors.white, size: 24),
                              ),
                              const SizedBox(width: 12),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Expense Management',
                                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                                  Text('Track your fixed and variable costs',
                                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Summary Cards
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Wrap(
                              spacing: 24,
                              runSpacing: 24,
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth >= 1200 
                                    ? (constraints.maxWidth - 72) / 4 // 4 columns with spacing
                                    : constraints.maxWidth >= 900 
                                      ? (constraints.maxWidth - 24) / 2 // 2 columns with spacing
                                      : constraints.maxWidth, // 1 column
                                  child: SummaryCard(
                                    title: 'Fixed Expenses',
                                    value: "\$${fixedTotal.toInt()}",
                                    subtitle: 'Monthly recurring',
                                    icon: Icons.trending_up,
                                    iconColor: const Color(0xFF2563EB),
                                  ),
                                ),
                                SizedBox(
                                  width: constraints.maxWidth >= 1200 
                                    ? (constraints.maxWidth - 72) / 4 // 4 columns with spacing
                                    : constraints.maxWidth >= 900 
                                      ? (constraints.maxWidth - 24) / 2 // 2 columns with spacing
                                      : constraints.maxWidth, // 1 column
                                  child: SummaryCard(
                                    title: 'Variable Expenses',
                                    value: "\$${variableTotal.toInt()}",
                                    subtitle: 'This month',
                                    icon: Icons.trending_down,
                                    iconColor: const Color(0xFFEA580C),
                                  ),
                                ),
                                SizedBox(
                                  width: constraints.maxWidth >= 1200 
                                    ? (constraints.maxWidth - 72) / 4 // 4 columns with spacing
                                    : constraints.maxWidth >= 900 
                                      ? (constraints.maxWidth - 24) / 2 // 2 columns with spacing
                                      : constraints.maxWidth, // 1 column
                                  child: SummaryCard(
                                    title: 'Total Expenses',
                                    value: "\$${grandTotal.toInt()}",
                                    subtitle: 'Combined total',
                                    icon: Icons.attach_money,
                                    iconColor: const Color(0xFFDC2626),
                                  ),
                                ),
                                SizedBox(
                                  width: constraints.maxWidth >= 1200 
                                    ? (constraints.maxWidth - 72) / 4 // 4 columns with spacing
                                    : constraints.maxWidth >= 900 
                                      ? (constraints.maxWidth - 24) / 2 // 2 columns with spacing
                                      : constraints.maxWidth, // 1 column
                                  child: SummaryGradientCard(
                                    title: 'Budget Status',
                                    value: '89%',
                                    subtitle: 'Within budget',
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Sections responsive (Row on wide, Column on narrow)
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final bool twoCols = constraints.maxWidth > 1024;
                            if (twoCols) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: _expenseSection(false)),
                                  const SizedBox(width: 24),
                                  Expanded(child: _expenseSection(true)),
                                ],
                              );
                            }
                            return Column(
                              children: [
                                _expenseSection(false),
                                const SizedBox(height: 24),
                                _expenseSection(true),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        _grandTotalCard(grandTotal.toInt()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _expenseSection(bool variable) {
    final String title = variable ? 'Variable Expenses' : 'Fixed Expenses';
    final String description = variable ? 'Monthly costs that can vary' : 'Monthly recurring costs that remain constant';
    final Color amountColor = variable ? const Color(0xFFEA580C) : const Color(0xFF2563EB);
    final List<Map<String, dynamic>> expenses = variable ? variableExpenses : fixedExpenses;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: variable ? const Color(0xFFEA580C) : const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 4),
          Text(description, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 16),
          ...expenses.map((e) => _expenseItem(e, variable, amountColor)),
          if (variable) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _showAddExpenseDialog,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Variable Expense'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  side: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                  foregroundColor: Colors.grey.shade800,
                ).copyWith(
                  overlayColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed) || states.contains(MaterialState.hovered)) {
                      return Colors.grey.withValues(alpha: 0.08);
                    }
                    return null;
                  }),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(children: [
            Text(
              variable ? 'Total Variable' : 'Total Fixed',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            const Spacer(),
            Text(
              variable ? "\$${variableTotal.toInt()}" : "\$${fixedTotal.toInt()}",
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: amountColor),
            ),
          ]),
        ]),
      ),
    );
  }

  Widget _expenseItem(Map<String, dynamic> e, bool variable, Color amountColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(e['name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
            Text(e['category'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ]),
        ),
        Text("\$${e['amount']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: amountColor)),
        if (variable) ...[
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _deleteExpense(e['id'] as int),
            icon: const Icon(Icons.delete, size: 18, color: Color(0xFFEF4444)),
            tooltip: 'Remove',
          ),
        ],
      ]),
    );
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Variable Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Expense Name')),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount (\$)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(controller: _categoryController, decoration: const InputDecoration(labelText: 'Category')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: _addExpense, child: const Text('Add')),
        ],
      ),
    );
  }

  void _addExpense() {
    if (_nameController.text.isNotEmpty && _amountController.text.isNotEmpty && _categoryController.text.isNotEmpty) {
      setState(() {
        variableExpenses.add({
          'id': DateTime.now().millisecondsSinceEpoch,
          'name': _nameController.text,
          'amount': double.tryParse(_amountController.text) ?? 0,
          'category': _categoryController.text,
        });
      });
      _nameController.clear();
      _amountController.clear();
      _categoryController.clear();
      if (mounted) Navigator.pop(context);
    }
  }

  void _deleteExpense(int id) {
    setState(() {
      variableExpenses.removeWhere((expense) => expense['id'] == id);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Widget _grandTotalCard(int grandTotal) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF111827), Color(0xFF374151)]),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Monthly Total', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Combined fixed and variable expenses', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("\$$grandTotal", style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              const Text('This month', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ]),
      ),
    );
  }
}
