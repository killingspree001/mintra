import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_provider.dart';
import '../providers/currency_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/spending_chart.dart';
import '../widgets/monthly_trend_chart.dart';
import '../widgets/transaction_filters.dart';
import '../widgets/transaction_list.dart';
import '../widgets/add_transaction_form.dart';
import '../widgets/budget_panel.dart';
import '../widgets/currency_selector.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(totalBalanceProvider);
    final income = ref.watch(totalIncomeProvider);
    final expenses = ref.watch(totalExpensesProvider);
    final filteredTransactions = ref.watch(filteredTransactionsProvider);
    final spending = ref.watch(spendingByCategoryProvider);
    final monthlyTrend = ref.watch(monthlyTrendProvider);
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Finance Tracker',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Track your money wisely',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Currency selector
                        const CurrencySelector(),
                        const SizedBox(width: 8),
                        // Settings button
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: IconButton(
                            onPressed: () => _showBudgetPanel(context),
                            icon: const Icon(Icons.settings_outlined, color: Color(0xFF6B7280)),
                            iconSize: 22,
                            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Balance Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: BalanceCard(
                  balance: balance,
                  income: income,
                  expenses: expenses,
                  currency: currency,
                ),
              ),
            ),

            // Spending by Category
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SpendingChart(spending: spending),
              ),
            ),

            // Monthly Trend
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: MonthlyTrendChart(data: monthlyTrend),
              ),
            ),

            // Transaction Filters
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 24),
                child: TransactionFilters(),
              ),
            ),

            // Transaction List
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 100),
                child: TransactionList(
                  transactions: filteredTransactions,
                  onDelete: (id) => ref.read(transactionsProvider.notifier).removeTransaction(id),
                ),
              ),
            ),
          ],
        ),
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransaction(context, ref),
        backgroundColor: const Color(0xFF22C55E),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  void _showAddTransaction(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTransactionForm(
        onAdd: (t) => ref.read(transactionsProvider.notifier).addTransaction(t),
      ),
    );
  }

  void _showBudgetPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => const BudgetPanel(),
      ),
    );
  }
}
