import 'enums.dart';

class SavingsGoal {
  final int id;
  final int userId;
  final double targetAmount;
  final double currentAmount;
  final DateTime startDate;
  final DateTime endDate;
  final String goalName;
  final SavingsGoalStatus status;

  SavingsGoal({
    required this.id,
    required this.userId,
    required this.targetAmount,
    this.currentAmount = 0.0,
    required this.startDate,
    required this.endDate,
    required this.goalName,
    this.status = SavingsGoalStatus.inProgress,
  });

  factory SavingsGoal.fromJson(Map<String, dynamic> json) {
    return SavingsGoal(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      targetAmount: (json['target_amount'] as num).toDouble(),
      currentAmount: (json['current_amount'] as num).toDouble(),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      goalName: json['goal_name'] as String,
      status: SavingsGoalStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'target_amount': targetAmount,
      'current_amount': currentAmount,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'goal_name': goalName,
      'status': status.toString().split('.').last,
    };
  }
} 