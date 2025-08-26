import '/constants/app_exports.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  // Starting data for fixed expenses (mutable copy is created in initState)
  final List<Map<String, dynamic>> _initialFixed = const [
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

  late List<Map<String, dynamic>> fixedExpenses;
  late List<Map<String, dynamic>> variableExpenses;

  double get fixedTotal => fixedExpenses.fold(0.0, (sum, e) => sum + (e['amount'] as num).toDouble());
  double get variableTotal => variableExpenses.fold(0.0, (sum, e) => sum + (e['amount'] as num).toDouble());
  double get grandTotal => fixedTotal + variableTotal;

  @override
  void initState() {
    super.initState();
    fixedExpenses = List<Map<String, dynamic>>.from(_initialFixed);
    variableExpenses = List<Map<String, dynamic>>.from(_initialVariable);
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      colors: const [
        Color(0xFFF8FAFC), // slate-50
        Color(0xFFECFDF5), // emerald-50
        Color(0xFFD1FAE5), // green-100/50
      ],
      child: Column(
        children: [
          const NavigationWidget(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Summary Cards
                        ResponsiveCardGrid(
                          children: [
                            SummaryCard(
                              title: 'Fixed Expenses',
                              value: "\$${fixedTotal.toInt()}",
                              subtitle: 'Monthly recurring',
                              icon: Icons.trending_up,
                              iconColor: const Color(0xFF2563EB),
                            ),
                            SummaryCard(
                              title: 'Variable Expenses',
                              value: "\$${variableTotal.toInt()}",
                              subtitle: 'This month',
                              icon: Icons.trending_down,
                              iconColor: const Color(0xFFEA580C),
                            ),
                            SummaryCard(
                              title: 'Total Expenses',
                              value: "\$${grandTotal.toInt()}",
                              subtitle: 'Combined total',
                              icon: Icons.attach_money,
                              iconColor: const Color(0xFFDC2626),
                            ),
                            SummaryGradientCard(
                              title: 'Budget Status',
                              value: '89%',
                              subtitle: 'Within budget',
                            ),
                          ],
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

                        _grandTotalCard(),
                      ],
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
    final Color dotColor = variable ? const Color(0xFFEA580C) : const Color(0xFF2563EB);
    final Color amountColor = variable ? const Color(0xFFEA580C) : const Color(0xFF2563EB);
    final List<Map<String, dynamic>> expenses = variable ? variableExpenses : fixedExpenses;

    return ExpenseSectionCard(
      title: title,
      description: description,
      dotColor: dotColor,
      children: expenses.map((e) => 
        ExpenseItemCard(
          name: e['name'],
          category: e['category'],
          amount: (e['amount'] as num).toDouble(),
          showDeleteButton: true,
          onDelete: () => _deleteExpense(e['id'] as int, variable),
          amountColor: amountColor,
        ),
      ).toList(),
      actionButton: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _showAddExpenseDialog(variable),
          icon: const Icon(Icons.add, size: 18),
          label: Text(variable ? 'Add Variable Expense' : 'Add Fixed Expense'),
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
      totalLabel: variable ? 'Total Variable' : 'Total Fixed',
      totalAmount: variable ? "\$${variableTotal.toInt()}" : "\$${fixedTotal.toInt()}",
      totalAmountColor: amountColor,
    );
  }

  void _showAddExpenseDialog(bool isVariable) {
    final String title = isVariable ? 'Add New Variable Expense' : 'Add New Fixed Expense';
    showDialog(
      context: context,
      builder: (context) => Theme(
        data: Theme.of(context).copyWith(
          dialogBackgroundColor: Colors.white,
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
          ),
        ),
        child: AddExpenseDialog(
          title: title,
          onAdd: (name, amount, category) {
            setState(() {
              final newExpense = {
                'id': DateTime.now().millisecondsSinceEpoch,
                'name': name,
                'amount': amount,
                'category': category,
              };
              if (isVariable) {
                variableExpenses.add(newExpense);
              } else {
                fixedExpenses.add(newExpense);
              }
            });
          },
        ),
      ),
    );
  }

  void _deleteExpense(int id, bool isVariable) {
    setState(() {
      if (isVariable) {
        variableExpenses.removeWhere((expense) => expense['id'] == id);
      } else {
        fixedExpenses.removeWhere((expense) => expense['id'] == id);
      }
    });
  }

  Widget _grandTotalCard() {
    return GradientTotalCard(
      title: 'Monthly Total',
      subtitle: 'Combined fixed and variable expenses',
      amount: "\$${grandTotal.toInt()}",
    );
  }
}
