import '../constants/app_exports.dart';

class ExpensesService {
  static final _supabase = SupabaseService.client;

  // Get fixed expenses (where is_variable = false)
  static Future<List<Map<String, dynamic>>> getFixedExpenses() async {
    try {
      final expenses = await _supabase
          .from('expenses')
          .select('*')
          .eq('is_variable', false)
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(expenses);
    } catch (e) {
      print('Error fetching fixed expenses: $e');
      return [];
    }
  }

  // Get variable expenses (where is_variable = true)
  static Future<List<Map<String, dynamic>>> getVariableExpenses() async {
    try {
      final expenses = await _supabase
          .from('expenses')
          .select('*')
          .eq('is_variable', true)
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(expenses);
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
      
      final response = await _supabase
          .from('expenses')
          .select('amount')
          .eq('is_variable', false)
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
      
      final response = await _supabase
          .from('expenses')
          .select('amount')
          .eq('is_variable', true)
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
    required bool isVariable,
    String? bookingId,
    DateTime? date,
  }) async {
    try {
      final expenseDate = date ?? DateTime.now();
      
      await _supabase.from('expenses').insert({
        'name': name,
        'amount': amount,
        'is_variable': isVariable,
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
  // Note: Budget functionality temporarily disabled as budget_amount column doesn't exist
  static Future<double> getBudgetUtilization([int? month, int? year]) async {
    try {
      // For now, return 0% utilization since there's no budget column in the schema
      // You can implement budget logic later if needed
      return 0.0;
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
      'category': expense['category']?['name'] ?? 'Uncategorized',
      'date': expense['date'],
      'created_at': expense['created_at'],
    };
  }
}
