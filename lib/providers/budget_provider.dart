import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/budget.dart';
import '../models/category.dart';
import 'transaction_provider.dart';

class BudgetNotifier extends Notifier<List<Budget>> {
  static const _key = 'budgets';

  @override
  List<Budget> build() {
    _loadBudgets();
    return _getDefaultBudgets();
  }

  List<Budget> _getDefaultBudgets() {
    return Category.expenseCategories
        .map((c) => Budget(category: c, limit: 500.0))
        .toList();
  }

  Future<void> _loadBudgets() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key);
    if (data != null && data.isNotEmpty) {
      state = data.map((item) => Budget.fromMap(jsonDecode(item))).toList();
    }
  }

  Future<void> _saveBudgets() async {
    final prefs = await SharedPreferences.getInstance();
    final data = state.map((item) => jsonEncode(item.toMap())).toList();
    await prefs.setStringList(_key, data);
  }

  void updateLimit(Category category, double limit) {
    state = state.map((b) {
      if (b.category == category) {
        return b.copyWith(limit: limit);
      }
      return b;
    }).toList();
    _saveBudgets();
  }
}

final budgetsProvider = NotifierProvider<BudgetNotifier, List<Budget>>(
  BudgetNotifier.new,
);

/// Provider that calculates spent amount for each budget based on transactions.
final budgetsWithSpentProvider = Provider<List<Budget>>((ref) {
  final budgets = ref.watch(budgetsProvider);
  final spendingByCategory = ref.watch(spendingByCategoryProvider);

  return budgets.map((budget) {
    final spending = spendingByCategory
        .where((s) => s.category == budget.category)
        .fold(0.0, (sum, s) => sum + s.amount);

    return budget.copyWith(spent: spending);
  }).toList();
});
