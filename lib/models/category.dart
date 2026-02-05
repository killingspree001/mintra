/// Enum representing transaction categories with associated emoji icons.
enum Category {
  foodAndDining('Food & Dining', '🍔'),
  transport('Transport', '🚗'),
  rentAndHousing('Rent & Housing', '🏠'),
  entertainment('Entertainment', '🎭'),
  shopping('Shopping', '🛍️'),
  utilities('Utilities', '💡'),
  health('Health', '❤️'),
  other('Other', '📦'),
  salary('Salary', '💼'),
  freelance('Freelance', '💵'),
  investment('Investment', '📈');

  final String label;
  final String emoji;

  const Category(this.label, this.emoji);

  /// Returns true if this category is an expense type.
  bool get isExpense => ![Category.salary, Category.freelance, Category.investment].contains(this);

  /// Returns true if this category is an income type.
  bool get isIncome => !isExpense;

  /// Get display name with emoji.
  String get displayName => '$emoji $label';

  /// Get all expense categories.
  static List<Category> get expenseCategories => values.where((c) => c.isExpense).toList();

  /// Get all income categories.
  static List<Category> get incomeCategories => values.where((c) => c.isIncome).toList();
}
