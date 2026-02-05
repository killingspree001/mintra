import 'package:uuid/uuid.dart';
import 'category.dart';

enum TransactionType { income, expense }

class Transaction {
  final String id;
  final double amount;
  final DateTime date;
  final Category category;
  final TransactionType type;
  final String? note;

  Transaction({
    String? id,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
    this.note,
  }) : id = id ?? const Uuid().v4();

  /// Get the display title (category label).
  String get title => category.label;

  Transaction copyWith({
    String? id,
    double? amount,
    DateTime? date,
    Category? category,
    TransactionType? type,
    String? note,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      type: type ?? this.type,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category.name,
      'type': type.name,
      'note': note,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      amount: map['amount'].toDouble(),
      date: DateTime.parse(map['date']),
      category: Category.values.byName(map['category']),
      type: TransactionType.values.byName(map['type']),
      note: map['note'],
    );
  }
}
