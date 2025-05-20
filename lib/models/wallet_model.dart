class Wallet {
  final int id;
  final int userId;
  final String name;
  final double balance;

  Wallet({
    required this.id,
    required this.userId,
    required this.name,
    this.balance = 0.0,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      name: json['name'] as String,
      balance: (json['balance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'balance': balance,
    };
  }
} 