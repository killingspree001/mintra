import 'category.dart';

/// Model representing a budget limit for a category.
class Budget {
  final Category category;
  final double limit;
  final double spent;

  const Budget({
    required this.category,
    required this.limit,
    this.spent = 0.0,
  });

  /// Calculate the percentage spent.
  double get percentSpent => limit > 0 ? (spent / limit * 100).clamp(0, 100) : 0;

  /// Check if over budget.
  bool get isOverBudget => spent > limit;

  /// Remaining budget amount.
  double get remaining => (limit - spent).clamp(0, double.infinity);

  Budget copyWith({
    Category? category,
    double? limit,
    double? spent,
  }) {
    return Budget(
      category: category ?? this.category,
      limit: limit ?? this.limit,
      spent: spent ?? this.spent,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category.name,
      'limit': limit,
      'spent': spent,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      category: Category.values.byName(map['category']),
      limit: map['limit'].toDouble(),
      spent: map['spent']?.toDouble() ?? 0.0,
    );
  }
}
