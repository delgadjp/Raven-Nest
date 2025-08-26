class Expense {
  final int? id;
  final String name;
  final double amount;
  final String category;
  final bool isVariable;
  final DateTime createdAt;

  const Expense({
    this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.isVariable,
    required this.createdAt,
  });

  // Convert Expense object to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'category': category,
      'isVariable': isVariable ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create Expense object from Map (database result)
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      name: map['name'] as String,
      amount: map['amount'] as double,
      category: map['category'] as String,
      isVariable: (map['isVariable'] as int) == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  // Create a copy of the expense with updated fields
  Expense copyWith({
    int? id,
    String? name,
    double? amount,
    String? category,
    bool? isVariable,
    DateTime? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      isVariable: isVariable ?? this.isVariable,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Expense{id: $id, name: $name, amount: $amount, category: $category, isVariable: $isVariable, createdAt: $createdAt}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Expense &&
        other.id == id &&
        other.name == name &&
        other.amount == amount &&
        other.category == category &&
        other.isVariable == isVariable &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      amount,
      category,
      isVariable,
      createdAt,
    );
  }
}
