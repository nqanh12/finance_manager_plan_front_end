import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/index.dart';
import '../services/transaction_service.dart';

final transactionServiceProvider = Provider<TransactionService>((ref) => TransactionService());

final transactionProvider = StateNotifierProvider<TransactionNotifier, AsyncValue<List<Transaction>>>((ref) {
  return TransactionNotifier(ref.read(transactionServiceProvider));
});

final filteredTransactionsProvider = Provider<List<Transaction>>((ref) {
  final transactionsState = ref.watch(transactionProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final selectedFilter = ref.watch(filterProvider);

  return transactionsState.when(
    data: (transactions) {
      var filtered = transactions;

      // Apply type filter
      if (selectedFilter != 'all') {
        filtered = filtered.where((t) => 
          t.type.toString().split('.').last.toLowerCase() == selectedFilter
        ).toList();
      }

      // Apply search query
      if (searchQuery.isNotEmpty) {
        filtered = filtered.where((t) => 
          t.note?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false
        ).toList();
      }

      // Sort by date (newest first)
      filtered.sort((a, b) => b.date.compareTo(a.date));
      
      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Search query state
final searchQueryProvider = StateProvider<String>((ref) => '');

// Filter state (all, income, expense)
final filterProvider = StateProvider<String>((ref) => 'all');

// Selected transaction for details/edit
final selectedTransactionProvider = StateProvider<Transaction?>((ref) => null);

class TransactionNotifier extends StateNotifier<AsyncValue<List<Transaction>>> {
  final TransactionService _transactionService;

  TransactionNotifier(this._transactionService) : super(const AsyncValue.loading()) {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    try {
      final transactions = await _transactionService.getTransactions();
      state = AsyncValue.data(transactions);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      final newTransaction = await _transactionService.addTransaction(transaction);
      state.whenData((transactions) {
        state = AsyncValue.data([...transactions, newTransaction]);
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateTransaction(Transaction transaction) async {
    try {
      final updatedTransaction = await _transactionService.updateTransaction(transaction);
      state.whenData((transactions) {
        final index = transactions.indexWhere((t) => t.id == transaction.id);
        if (index != -1) {
          final updatedList = [...transactions];
          updatedList[index] = updatedTransaction;
          state = AsyncValue.data(updatedList);
        }
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteTransaction(int id) async {
    try {
      await _transactionService.deleteTransaction(id);
      state.whenData((transactions) {
        state = AsyncValue.data(
          transactions.where((t) => t.id != id).toList(),
        );
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  double getTotalIncome() {
    return state.whenData((transactions) {
      return transactions
          .where((t) => t.type == TransactionType.income)
          .fold(0.0, (sum, t) => sum + t.amount);
    }).value ?? 0.0;
  }

  double getTotalExpenses() {
    return state.whenData((transactions) {
      return transactions
          .where((t) => t.type == TransactionType.expense)
          .fold(0.0, (sum, t) => sum + t.amount);
    }).value ?? 0.0;
  }
} 