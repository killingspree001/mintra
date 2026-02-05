import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';
import '../models/category.dart';

// ============================================================================
// Date Filter
// ============================================================================

enum DateFilter { day, week, month }

class DateFilterNotifier extends Notifier<DateFilter> {
  @override
  DateFilter build() => DateFilter.month;

  void set(DateFilter filter) => state = filter;
}

final dateFilterProvider = NotifierProvider<DateFilterNotifier, DateFilter>(
  DateFilterNotifier.new,
);

// ============================================================================
// Category Filter
// ============================================================================

class CategoryFilterNotifier extends Notifier<Category?> {
  @override
  Category? build() => null; // null means "All categories"

  void set(Category? category) => state = category;
}

final categoryFilterProvider = NotifierProvider<CategoryFilterNotifier, Category?>(
  CategoryFilterNotifier.new,
);

// ============================================================================
// Search Query
// ============================================================================

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String query) => state = query;
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

// ============================================================================
// Transactions
// ============================================================================

class TransactionNotifier extends Notifier<List<Transaction>> {
  static const _key = 'transactions_v2';

  @override
  List<Transaction> build() {
    _loadTransactions();
    return [];
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key);
    if (data != null && data.isNotEmpty) {
      state = data.map((item) => Transaction.fromMap(jsonDecode(item))).toList();
    }
  }

  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final data = state.map((item) => jsonEncode(item.toMap())).toList();
    await prefs.setStringList(_key, data);
  }

  void addTransaction(Transaction transaction) {
    state = [...state, transaction];
    _saveTransactions();
  }

  void removeTransaction(String id) {
    state = state.where((t) => t.id != id).toList();
    _saveTransactions();
  }

  void clearAll() {
    state = [];
    _saveTransactions();
  }
}

final transactionsProvider = NotifierProvider<TransactionNotifier, List<Transaction>>(
  TransactionNotifier.new,
);

// ============================================================================
// Filtered Transactions
// ============================================================================

final filteredTransactionsProvider = Provider<List<Transaction>>((ref) {
  final transactions = ref.watch(transactionsProvider);
  final dateFilter = ref.watch(dateFilterProvider);
  final categoryFilter = ref.watch(categoryFilterProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  final now = DateTime.now();
  final startOfToday = DateTime(now.year, now.month, now.day);

  return transactions.where((t) {
    // Date filter
    bool matchesDate = true;
    switch (dateFilter) {
      case DateFilter.day:
        matchesDate = t.date.isAfter(startOfToday.subtract(const Duration(days: 1)));
        break;
      case DateFilter.week:
        matchesDate = t.date.isAfter(startOfToday.subtract(const Duration(days: 7)));
        break;
      case DateFilter.month:
        matchesDate = t.date.isAfter(DateTime(now.year, now.month - 1, now.day));
        break;
    }

    // Category filter
    final matchesCategory = categoryFilter == null || t.category == categoryFilter;

    // Search filter
    final matchesSearch = searchQuery.isEmpty ||
        t.category.label.toLowerCase().contains(searchQuery) ||
        (t.note?.toLowerCase().contains(searchQuery) ?? false);

    return matchesDate && matchesCategory && matchesSearch;
  }).toList()
    ..sort((a, b) => b.date.compareTo(a.date)); // Most recent first
});

// ============================================================================
// Derived State
// ============================================================================

final totalIncomeProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionsProvider);
  return transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);
});

final totalExpensesProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionsProvider);
  return transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);
});

final totalBalanceProvider = Provider<double>((ref) {
  final income = ref.watch(totalIncomeProvider);
  final expenses = ref.watch(totalExpensesProvider);
  return income - expenses;
});

// ============================================================================
// Spending by Category (for donut chart)
// ============================================================================

class CategorySpending {
  final Category category;
  final double amount;
  final double percentage;

  const CategorySpending({
    required this.category,
    required this.amount,
    required this.percentage,
  });
}

final spendingByCategoryProvider = Provider<List<CategorySpending>>((ref) {
  final transactions = ref.watch(transactionsProvider);
  final expenses = transactions.where((t) => t.type == TransactionType.expense).toList();

  if (expenses.isEmpty) return [];

  final totalExpenses = expenses.fold(0.0, (sum, t) => sum + t.amount);

  // Group by category
  final Map<Category, double> categoryTotals = {};
  for (final t in expenses) {
    categoryTotals[t.category] = (categoryTotals[t.category] ?? 0) + t.amount;
  }

  // Convert to list with percentages
  return categoryTotals.entries
      .map((e) => CategorySpending(
            category: e.key,
            amount: e.value,
            percentage: (e.value / totalExpenses) * 100,
          ))
      .toList()
    ..sort((a, b) => b.amount.compareTo(a.amount)); // Highest first
});

// ============================================================================
// Monthly Trend (for bar chart)
// ============================================================================

class MonthlyData {
  final String month;
  final double income;
  final double expenses;

  const MonthlyData({
    required this.month,
    required this.income,
    required this.expenses,
  });
}

final monthlyTrendProvider = Provider<List<MonthlyData>>((ref) {
  final transactions = ref.watch(transactionsProvider);
  final now = DateTime.now();

  // Get last 6 months
  final result = <MonthlyData>[];

  for (int i = 5; i >= 0; i--) {
    final targetMonth = DateTime(now.year, now.month - i, 1);
    final monthTransactions = transactions.where((t) =>
        t.date.year == targetMonth.year && t.date.month == targetMonth.month);

    final income = monthTransactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    final expenses = monthTransactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    result.add(MonthlyData(
      month: monthNames[targetMonth.month - 1],
      income: income,
      expenses: expenses,
    ));
  }

  return result;
});
