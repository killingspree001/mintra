import 'package:flutter/material.dart';
import '../models/currency.dart';

/// Main balance card matching the reference design.
/// Green gradient with total balance and income/expense sub-cards.
class BalanceCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expenses;
  final Currency currency;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expenses,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF22C55E).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Total Balance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Balance amount
          Text(
            currency.format(balance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          // Income and Expenses sub-cards
          Row(
            children: [
              Expanded(
                child: _SubCard(
                  icon: Icons.trending_up_rounded,
                  label: 'Income',
                  amount: income,
                  prefix: '+',
                  currency: currency,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SubCard(
                  icon: Icons.trending_down_rounded,
                  label: 'Expenses',
                  amount: expenses,
                  prefix: '-',
                  currency: currency,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double amount;
  final String prefix;
  final Currency currency;

  const _SubCard({
    required this.icon,
    required this.label,
    required this.amount,
    required this.prefix,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white70, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$prefix${currency.format(amount)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
