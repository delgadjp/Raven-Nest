import '../constants/app_exports.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  List<Map<String, dynamic>> fixedExpenses = [];
  List<Map<String, dynamic>> variableExpenses = [];
  List<Map<String, dynamic>> expenseCategories = [];
  double fixedTotal = 0.0;
  double variableTotal = 0.0;
  double budgetUtilization = 0.0;
  bool isLoading = true;
  String? errorMessage;

  double get grandTotal => fixedTotal + variableTotal;

  @override
  void initState() {
    super.initState();
    _loadExpensesData();
  }

  Future<void> _loadExpensesData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Load all data concurrently
      final results = await Future.wait([
        ExpensesService.getExpenseCategories(),
        ExpensesService.getFixedExpenses(),
        ExpensesService.getVariableExpenses(),
        ExpensesService.getFixedExpensesTotal(),
        ExpensesService.getVariableExpensesTotal(),
        ExpensesService.getBudgetUtilization(),
      ]);

      setState(() {
        expenseCategories = results[0] as List<Map<String, dynamic>>;
        fixedExpenses = (results[1] as List<Map<String, dynamic>>)
            .map((e) => ExpensesService.formatExpenseForUI(e))
            .toList();
        variableExpenses = (results[2] as List<Map<String, dynamic>>)
            .map((e) => ExpensesService.formatExpenseForUI(e))
            .toList();
        fixedTotal = results[3] as double;
        variableTotal = results[4] as double;
        budgetUtilization = results[5] as double;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading expenses data: $e';
        isLoading = false;
      });
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
                : errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                            const SizedBox(height: 16),
                            Text(
                              'Failed to load expenses',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              errorMessage!,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _loadExpensesData,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
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
                                    title: 'Monthly Expenses',
                                    value: "\$${grandTotal.toInt()}",
                                    subtitle: 'Combined total',
                                    icon: Icons.attach_money,
                                    iconColor: const Color(0xFFDC2626),
                                  ),
                                  SummaryGradientCard(
                                    title: 'Budget Status',
                                    value: '${budgetUtilization.toStringAsFixed(0)}%',
                                    subtitle: budgetUtilization <= 100 ? 'Within budget' : 'Over budget',
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
    final double total = variable ? variableTotal : fixedTotal;

    return ExpenseSectionCard(
      title: title,
      description: description,
      dotColor: dotColor,
      children: expenses.map((expense) => 
        ExpenseItemCard(
          name: expense['name'] as String,
          category: expense['category'] as String,
          amount: expense['amount'] as double,
          showDeleteButton: true,
          onDelete: () => _deleteExpense(expense['id'] as String, variable),
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
    
    // Filter categories based on expense type
    final filteredCategories = expenseCategories
        .where((category) => category['is_variable'] == isVariable)
        .toList();
    
    showDialog(
      context: context,
      builder: (context) => GenericFormDialog(
        config: DialogConfigurations.addExpense(
          title: title,
          categories: filteredCategories,
          onAdd: (name, amount, categoryId) async {
            final success = await ExpensesService.addExpense(
              name: name,
              amount: amount,
              categoryId: categoryId,
            );
            
            if (success) {
              // Reload data to reflect changes
              _loadExpensesData();
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Expense "$name" added successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to add expense'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }

  void _deleteExpense(String expenseId, bool isVariable) async {
    final success = await ExpensesService.deleteExpense(expenseId);
    
    if (success) {
      // Reload data to reflect changes
      _loadExpensesData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete expense'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
