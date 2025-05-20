import 'package:dio/dio.dart';
import '../models/index.dart';

class TransactionService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://localhost:3000/api'; // TODO: Move to config

  Future<List<Transaction>> getTransactions() async {
    try {
      final response = await _dio.get('$_baseUrl/transactions');
      return (response.data as List)
          .map((json) => Transaction.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load transactions: $e');
    }
  }

  Future<Transaction> addTransaction(Transaction transaction) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/transactions',
        data: transaction.toJson(),
      );
      return Transaction.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  Future<Transaction> updateTransaction(Transaction transaction) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/transactions/${transaction.id}',
        data: transaction.toJson(),
      );
      return Transaction.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  Future<void> deleteTransaction(int id) async {
    try {
      await _dio.delete('$_baseUrl/transactions/$id');
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }
} 