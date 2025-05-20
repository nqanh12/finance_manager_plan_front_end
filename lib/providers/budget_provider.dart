import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/budget_model.dart';
import '../services/budget_service.dart';

final budgetProvider = AsyncNotifierProvider<BudgetNotifier, List<Budget>>(() {
  return BudgetNotifier();
});

class BudgetNotifier extends AsyncNotifier<List<Budget>> {
  late final BudgetService _budgetService;

  @override
  Future<List<Budget>> build() async {
    _budgetService = ref.read(budgetServiceProvider);
    return _fetchBudgets();
  }

  Future<List<Budget>> _fetchBudgets() async {
    try {
      final budgets = await _budgetService.getBudgets();
      return budgets;
    } catch (e) {
      throw Exception('Failed to fetch budgets: $e');
    }
  }

  Future<void> addBudget(Budget budget) async {
    try {
      state = const AsyncLoading();
      await _budgetService.createBudget(budget);
      state = AsyncData(await _fetchBudgets());
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      throw Exception('Failed to add budget: $e');
    }
  }

  Future<void> updateBudget(Budget budget) async {
    try {
      state = const AsyncLoading();
      await _budgetService.updateBudget(budget);
      state = AsyncData(await _fetchBudgets());
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      throw Exception('Failed to update budget: $e');
    }
  }

  Future<void> deleteBudget(int id) async {
    try {
      state = const AsyncLoading();
      await _budgetService.deleteBudget(id);
      state = AsyncData(await _fetchBudgets());
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      throw Exception('Failed to delete budget: $e');
    }
  }
} 