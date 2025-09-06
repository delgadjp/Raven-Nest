import '../constants/app_exports.dart';

class ExpensesService {
  static final _supabase = SupabaseService.client;

  // Get all expense categories
  static Future<List<Map<String, dynamic>>> getExpenseCategories() async {
    try {
      final response = await _supabase
          .from('expense_categories')
          .select('*')
          .order('name');
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching expense categories: $e');
      return [];
    }
  }

  // Get fixed expenses (categories where is_variable = false)
  static Future<List<Map<String, dynamic>>> getFixedExpenses() async {
    try {
      // First get fixed expense categories
      final categories = await _supabase
          .from('expense_categories')
          .select('id, name')
          .eq('is_variable', false);
      
      if (categories.isEmpty) return [];
      
      final categoryIds = categories.map((cat) => cat['id']).toList();
      
      // Then get expenses for those categories
      final expenses = await _supabase
          .from('expenses')
          .select('*')
          .inFilter('category_id', categoryIds)
          .order('created_at', ascending: false);
      
      // Enrich expenses with category information
      List<Map<String, dynamic>> enrichedExpenses = [];
      for (var expense in expenses) {
        final category = categories.firstWhere(
          (cat) => cat['id'] == expense['category_id'],
          orElse: () => {'name': 'Unknown Category'},
        );
        
        Map<String, dynamic> enrichedExpense = Map<String, dynamic>.from(expense);
        enrichedExpense['category'] = category;
        enrichedExpenses.add(enrichedExpense);
      }
      
      return enrichedExpenses;
    } catch (e) {
      print('Error fetching fixed expenses: $e');
      return [];
    }
  }

  // Get variable expenses (categories where is_variable = true)
  static Future<List<Map<String, dynamic>>> getVariableExpenses() async {
    try {
      // First get variable expense categories
      final categories = await _supabase
          .from('expense_categories')
          .select('id, name')
          .eq('is_variable', true);
      
      if (categories.isEmpty) return [];
      
      final categoryIds = categories.map((cat) => cat['id']).toList();
      
      // Then get expenses for those categories
      final expenses = await _supabase
          .from('expenses')
          .select('*')
          .inFilter('category_id', categoryIds)
          .order('created_at', ascending: false);
      
      // Enrich expenses with category information
      List<Map<String, dynamic>> enrichedExpenses = [];
      for (var expense in expenses) {
        final category = categories.firstWhere(
          (cat) => cat['id'] == expense['category_id'],
          orElse: () => {'name': 'Unknown Category'},
        );
        
        Map<String, dynamic> enrichedExpense = Map<String, dynamic>.from(expense);
        enrichedExpense['category'] = category;
        enrichedExpenses.add(enrichedExpense);
      }
      
      return enrichedExpenses;
    } catch (e) {
      print('Error fetching variable expenses: $e');
      return [];
    }
  }

  // Get total fixed expenses for current month
  static Future<double> getFixedExpensesTotal([int? month, int? year]) async {
    try {
      final currentMonth = month ?? DateTime.now().month;
      final currentYear = year ?? DateTime.now().year;
      
      // First get fixed expense categories
      final categories = await _supabase
          .from('expense_categories')
          .select('id')
          .eq('is_variable', false);
      
      if (categories.isEmpty) return 0.0;
      
      final categoryIds = categories.map((cat) => cat['id']).toList();
      
      // Then get expenses for those categories for the specified month/year
      final response = await _supabase
          .from('expenses')
          .select('amount')
          .inFilter('category_id', categoryIds)
          .eq('month', currentMonth)
          .eq('year', currentYear);
      
      double total = 0.0;
      for (final expense in response) {
        final amount = expense['amount'];
        if (amount != null) {
          total += (amount is int) ? amount.toDouble() : (amount as num).toDouble();
        }
      }
      
      return total;
    } catch (e) {
      print('Error calculating fixed expenses total: $e');
      return 0.0;
    }
  }

  // Get total variable expenses for current month
  static Future<double> getVariableExpensesTotal([int? month, int? year]) async {
    try {
      final currentMonth = month ?? DateTime.now().month;
      final currentYear = year ?? DateTime.now().year;
      
      // First get variable expense categories
      final categories = await _supabase
          .from('expense_categories')
          .select('id')
          .eq('is_variable', true);
      
      if (categories.isEmpty) return 0.0;
      
      final categoryIds = categories.map((cat) => cat['id']).toList();
      
      // Then get expenses for those categories for the specified month/year
      final response = await _supabase
          .from('expenses')
          .select('amount')
          .inFilter('category_id', categoryIds)
          .eq('month', currentMonth)
          .eq('year', currentYear);
      
      double total = 0.0;
      for (final expense in response) {
        final amount = expense['amount'];
        if (amount != null) {
          total += (amount is int) ? amount.toDouble() : (amount as num).toDouble();
        }
      }
      
      return total;
    } catch (e) {
      print('Error calculating variable expenses total: $e');
      return 0.0;
    }
  }

  // Add a new expense
  static Future<bool> addExpense({
    required String name,
    required double amount,
    required String categoryId,
    String? bookingId,
    DateTime? date,
  }) async {
    try {
      final expenseDate = date ?? DateTime.now();
      
      await _supabase.from('expenses').insert({
        'name': name,
        'amount': amount,
        'category_id': categoryId,
        'booking_id': bookingId,
        'date': expenseDate.toIso8601String().split('T')[0], // YYYY-MM-DD format
        'month': expenseDate.month,
        'year': expenseDate.year,
      });
      
      return true;
    } catch (e) {
      print('Error adding expense: $e');
      return false;
    }
  }

  // Delete an expense
  static Future<bool> deleteExpense(String expenseId) async {
    try {
      await _supabase
          .from('expenses')
          .delete()
          .eq('id', expenseId);
      
      return true;
    } catch (e) {
      print('Error deleting expense: $e');
      return false;
    }
  }

  // Update an expense
  static Future<bool> updateExpense({
    required String expenseId,
    String? name,
    double? amount,
    String? categoryId,
    DateTime? date,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      
      if (name != null) updateData['name'] = name;
      if (amount != null) updateData['amount'] = amount;
      if (categoryId != null) updateData['category_id'] = categoryId;
      if (date != null) {
        updateData['date'] = date.toIso8601String().split('T')[0];
        updateData['month'] = date.month;
        updateData['year'] = date.year;
      }
      
      if (updateData.isNotEmpty) {
        await _supabase
            .from('expenses')
            .update(updateData)
            .eq('id', expenseId);
      }
      
      return true;
    } catch (e) {
      print('Error updating expense: $e');
      return false;
    }
  }

  // Get budget utilization percentage
  static Future<double> getBudgetUtilization([int? month, int? year]) async {
    try {
      final currentMonth = month ?? DateTime.now().month;
      final currentYear = year ?? DateTime.now().year;
      
      // Get total budget from categories
      final categoriesResponse = await _supabase
          .from('expense_categories')
          .select('budget');
      
      double totalBudget = 0.0;
      for (final category in categoriesResponse) {
        final budget = category['budget'];
        if (budget != null) {
          totalBudget += (budget is int) ? budget.toDouble() : (budget as num).toDouble();
        }
      }
      
      if (totalBudget == 0) return 0.0;
      
      // Get total expenses for the month
      final fixedTotal = await getFixedExpensesTotal(currentMonth, currentYear);
      final variableTotal = await getVariableExpensesTotal(currentMonth, currentYear);
      final totalExpenses = fixedTotal + variableTotal;
      
      return (totalExpenses / totalBudget) * 100;
    } catch (e) {
      print('Error calculating budget utilization: $e');
      return 0.0;
    }
  }

  // Helper method to format expense data for UI
  static Map<String, dynamic> formatExpenseForUI(Map<String, dynamic> expense) {
    return {
      'id': expense['id'],
      'name': expense['name'] ?? 'Unknown',
      'amount': expense['amount'] ?? 0.0,
      'category': expense['expense_categories']?['name'] ?? 'Uncategorized',
      'date': expense['date'],
      'created_at': expense['created_at'],
    };
  }
}
