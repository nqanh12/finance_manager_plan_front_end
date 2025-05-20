import 'package:dio/dio.dart';
import '../models/index.dart';

class SavingsGoalService {
  final _dio = Dio();
  final _baseUrl = 'http://localhost:3000/api'; // TODO: Move to config

  Future<List<SavingsGoal>> getSavingsGoals() async {
    try {
      final response = await _dio.get('$_baseUrl/savings-goals');
      final List<dynamic> data = response.data;
      return data.map((json) => SavingsGoal.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch savings goals: $e');
    }
  }

  Future<SavingsGoal> addSavingsGoal(SavingsGoal goal) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/savings-goals',
        data: goal.toJson(),
      );
      return SavingsGoal.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to add savings goal: $e');
    }
  }

  Future<SavingsGoal> updateSavingsGoal(SavingsGoal goal) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/savings-goals/${goal.id}',
        data: goal.toJson(),
      );
      return SavingsGoal.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update savings goal: $e');
    }
  }

  Future<void> deleteSavingsGoal(int id) async {
    try {
      await _dio.delete('$_baseUrl/savings-goals/$id');
    } catch (e) {
      throw Exception('Failed to delete savings goal: $e');
    }
  }
} 