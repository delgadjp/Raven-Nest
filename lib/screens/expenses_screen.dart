import '../constants/app_exports.dart';
import '../models/expense_model.dart';
import '../services/expense_database.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final ExpenseDatabase _database = ExpenseDatabase();
  List<Expense> fixedExpenses = [];
  List<Expense> variableExpenses = [];
  double fixedTotal = 0.0;
  double variableTotal = 0.0;
  bool isLoading = true;

  double get grandTotal => fixedTotal + variableTotal;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    setState(() {
      isLoading = true;
    });

    try {
      final fixed = await _database.getFixedExpenses();
      final variable = await _database.getVariableExpenses();
      final fixedTotalAmount = await _database.getFixedTotal();
      final variableTotalAmount = await _database.getVariableTotal();

      setState(() {
        fixedExpenses = fixed;
        variableExpenses = variable;
        fixedTotal = fixedTotalAmount;
        variableTotal = variableTotalAmount;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error - you might want to show a snackbar or dialog
      print('Error loading expenses: $e');
    }
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
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
    final List<Expense> expenses = variable ? variableExpenses : fixedExpenses;
    final double total = variable ? variableTotal : fixedTotal;

    return ExpenseSectionCard(
      title: title,
      description: description,
      dotColor: dotColor,
      children: expenses.map((expense) => 
        ExpenseItemCard(
          name: expense.name,
          category: expense.category,
          amount: expense.amount,
          showDeleteButton: true,
          onDelete: () => _deleteExpense(expense.id!, variable),
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
      totalAmount: "\$${total.toInt()}",
      totalAmountColor: amountColor,
    );
  }

  void _showAddExpenseDialog(bool isVariable) {
    final String title = isVariable ? 'Add New Variable Expense' : 'Add New Fixed Expense';
    showDialog(
      context: context,
      builder: (context) => GenericFormDialog(
        config: DialogConfigurations.addExpense(
          title: title,
          onAdd: (name, amount, category) async {
            try {
              final newExpense = Expense(
                name: name,
                amount: amount,
                category: category,
                isVariable: isVariable,
                createdAt: DateTime.now(),
              );
              
              await _database.insertExpense(newExpense);
              await _loadExpenses(); // Refresh the data
            } catch (e) {
              // Handle error - you might want to show a snackbar
              print('Error adding expense: $e');
            }
          },
        ),
      ),
    );
  }

  void _deleteExpense(int id, bool isVariable) async {
    try {
      await _database.deleteExpense(id);
      await _loadExpenses(); // Refresh the data
    } catch (e) {
      // Handle error - you might want to show a snackbar
      print('Error deleting expense: $e');
    }
  }

  Widget _grandTotalCard() {
    return GradientTotalCard(
      title: 'Monthly Total',
      subtitle: 'Combined fixed and variable expenses',
      amount: "\$${grandTotal.toInt()}",
    );
  }
}
