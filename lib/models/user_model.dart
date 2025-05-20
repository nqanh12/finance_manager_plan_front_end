import '../models/index.dart';

class User {
  final int id;
  final String fullName;
  final String email;
  final String passwordHash;
  final UserRole role;
  final double salary;
  final DateTime createdAt;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.passwordHash,
    required this.role,
    this.salary = 0.0,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      passwordHash: json['password_hash'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last.toLowerCase() == json['role'].toString().toLowerCase(),
      ),
      salary: (json['salary'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'password_hash': passwordHash,
      'role': role.toString().split('.').last.toLowerCase(),
      'salary': salary,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

enum UserRole {
  admin,
  user,
}

