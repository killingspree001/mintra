import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_provider.dart';
import '../models/category.dart';

/// Transaction filters widget with Day/Week/Month tabs, search, and category dropdown.
class TransactionFilters extends ConsumerWidget {
  const TransactionFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFilter = ref.watch(dateFilterProvider);
    final categoryFilter = ref.watch(categoryFilterProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transactions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              // Export button (icon only to save space)
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Export coming soon!')),
                  );
                },
                icon: const Icon(Icons.download_rounded, size: 20),
                color: const Color(0xFF6B7280),
                tooltip: 'Export',
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Date filter tabs row
          Row(
            children: [
              _FilterTab(
                label: 'Day',
                isSelected: dateFilter == DateFilter.day,
                onTap: () => ref.read(dateFilterProvider.notifier).set(DateFilter.day),
              ),
              const SizedBox(width: 8),
              _FilterTab(
                label: 'Week',
                isSelected: dateFilter == DateFilter.week,
                onTap: () => ref.read(dateFilterProvider.notifier).set(DateFilter.week),
              ),
              const SizedBox(width: 8),
              _FilterTab(
                label: 'Month',
                isSelected: dateFilter == DateFilter.month,
                onTap: () => ref.read(dateFilterProvider.notifier).set(DateFilter.month),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Search bar (full width)
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              onChanged: (value) => ref.read(searchQueryProvider.notifier).update(value),
              decoration: const InputDecoration(
                hintText: 'Search transactions...',
                hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 12),
          // Category filter (full width)
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Category?>(
                value: categoryFilter,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
                hint: const Row(
                  children: [
                    Icon(Icons.filter_list, size: 18, color: Color(0xFF6B7280)),
                    SizedBox(width: 8),
                    Text(
                      'All categories',
                      style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
                selectedItemBuilder: (context) {
                  return [
                    const Row(
                      children: [
                        Icon(Icons.filter_list, size: 18, color: Color(0xFF6B7280)),
                        SizedBox(width: 8),
                        Text('All categories', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    ...Category.values.map((c) => Row(
                      children: [
                        Text(c.emoji, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Text(c.label, style: const TextStyle(fontSize: 14)),
                      ],
                    )),
                  ];
                },
                items: [
                  const DropdownMenuItem<Category?>(
                    value: null,
                    child: Row(
                      children: [
                        Icon(Icons.check, size: 16, color: Color(0xFF22C55E)),
                        SizedBox(width: 8),
                        Text('All categories', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  ...Category.values.map((c) => DropdownMenuItem(
                    value: c,
                    child: Row(
                      children: [
                        Text(c.emoji, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            c.label,
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
                onChanged: (value) => ref.read(categoryFilterProvider.notifier).set(value),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1F2937) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF1F2937) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
