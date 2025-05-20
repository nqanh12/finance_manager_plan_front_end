import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/index.dart';
import '../services/savings_goal_service.dart';

final savingsGoalServiceProvider = Provider<SavingsGoalService>((ref) {
  return SavingsGoalService();
});

final savingsGoalProvider =
    StateNotifierProvider<SavingsGoalNotifier, AsyncValue<List<SavingsGoal>>>(
  (ref) => SavingsGoalNotifier(ref.watch(savingsGoalServiceProvider)),
);

class SavingsGoalNotifier extends StateNotifier<AsyncValue<List<SavingsGoal>>> {
  final SavingsGoalService _service;

  SavingsGoalNotifier(this._service) : super(const AsyncValue.loading()) {
    loadSavingsGoals();
  }

  Future<void> loadSavingsGoals() async {
    try {
      state = const AsyncValue.loading();
      final goals = await _service.getSavingsGoals();
      state = AsyncValue.data(goals);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addSavingsGoal(SavingsGoal goal) async {
    try {
      final newGoal = await _service.addSavingsGoal(goal);
      state.whenData((goals) {
        state = AsyncValue.data([...goals, newGoal]);
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateSavingsGoal(SavingsGoal goal) async {
    try {
      final updatedGoal = await _service.updateSavingsGoal(goal);
      state.whenData((goals) {
        state = AsyncValue.data(goals
            .map((g) => g.id == updatedGoal.id ? updatedGoal : g)
            .toList());
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteSavingsGoal(int id) async {
    try {
      await _service.deleteSavingsGoal(id);
      state.whenData((goals) {
        state = AsyncValue.data(goals.where((g) => g.id != id).toList());
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
} 