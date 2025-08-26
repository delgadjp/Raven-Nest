import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/expense_model.dart';

class ExpenseDatabase {
  static final ExpenseDatabase _instance = ExpenseDatabase._internal();
  static Database? _database;

  ExpenseDatabase._internal();

  factory ExpenseDatabase() => _instance;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'expenses.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        isVariable INTEGER NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // Insert a new expense
  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return await db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all expenses
  Future<List<Expense>> getAllExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('expenses');
    
    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  // Get expenses by type (fixed or variable)
  Future<List<Expense>> getExpensesByType(bool isVariable) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'isVariable = ?',
      whereArgs: [isVariable ? 1 : 0],
    );
    
    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  // Get fixed expenses
  Future<List<Expense>> getFixedExpenses() async {
    return await getExpensesByType(false);
  }

  // Get variable expenses
  Future<List<Expense>> getVariableExpenses() async {
    return await getExpensesByType(true);
  }

  // Update an expense
  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  // Delete an expense
  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get total amount for fixed expenses
  Future<double> getFixedTotal() async {
    final expenses = await getFixedExpenses();
    double total = 0.0;
    for (final expense in expenses) {
      total += expense.amount;
    }
    return total;
  }

  // Get total amount for variable expenses
  Future<double> getVariableTotal() async {
    final expenses = await getVariableExpenses();
    double total = 0.0;
    for (final expense in expenses) {
      total += expense.amount;
    }
    return total;
  }

  // Get grand total of all expenses
  Future<double> getGrandTotal() async {
    final fixedTotal = await getFixedTotal();
    final variableTotal = await getVariableTotal();
    return fixedTotal + variableTotal;
  }

  // Delete all expenses (useful for testing)
  Future<int> deleteAllExpenses() async {
    final db = await database;
    return await db.delete('expenses');
  }

  // Close the database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
