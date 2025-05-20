import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/budget_model.dart';
import '../utils/api_client.dart';

final budgetServiceProvider = Provider<BudgetService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return BudgetService(apiClient);
});

class BudgetService {
  final ApiClient _apiClient;

  BudgetService(this._apiClient);

  Future<List<Budget>> getBudgets() async {
    final response = await _apiClient.get('/budgets');
    return (response as List).map((json) => Budget.fromJson(json)).toList();
  }

  Future<Budget> createBudget(Budget budget) async {
    final response = await _apiClient.post('/budgets', budget.toJson());
    return Budget.fromJson(response);
  }

  Future<Budget> updateBudget(Budget budget) async {
    final response = await _apiClient.put('/budgets/${budget.id}', budget.toJson());
    return Budget.fromJson(response);
  }

  Future<void> deleteBudget(int id) async {
    await _apiClient.delete('/budgets/$id');
  }
} 