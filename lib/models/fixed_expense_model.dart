class FixedExpense {
  final int id;
  final int userId;
  final String name;
  final double amount;
  final DateTime dueDate;

  FixedExpense({
    required this.id,
    required this.userId,
    required this.name,
    required this.amount,
    required this.dueDate,
  });

  factory FixedExpense.fromJson(Map<String, dynamic> json) {
    return FixedExpense(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      dueDate: DateTime.parse(json['due_date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'amount': amount,
      'due_date': dueDate.toIso8601String(),
    };
  }
} 