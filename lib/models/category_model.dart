import 'enums.dart';

class Category {
  final int id;
  final String name;
  final TransactionType type;
  final int userId;

  Category({
    required this.id,
    required this.name,
    required this.type,
    required this.userId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      type: TransactionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      userId: json['user_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'user_id': userId,
    };
  }
} 