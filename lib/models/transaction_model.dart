import 'enums.dart';

class Transaction {
  final int id;
  final int userId;
  final int? walletId;
  final int? categoryId;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final String? note;

  Transaction({
    required this.id,
    required this.userId,
    this.walletId,
    this.categoryId,
    required this.amount,
    required this.type,
    required this.date,
    this.note,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      walletId: json['wallet_id'] as int?,
      categoryId: json['category_id'] as int?,
      amount: (json['amount'] as num).toDouble(),
      type: TransactionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      date: DateTime.parse(json['date'] as String),
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'wallet_id': walletId,
      'category_id': categoryId,
      'amount': amount,
      'type': type.toString().split('.').last,
      'date': date.toIso8601String(),
      'note': note,
    };
  }
} 