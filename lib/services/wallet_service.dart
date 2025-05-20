import 'package:dio/dio.dart';
import '../models/index.dart';

class WalletService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://localhost:3000/api'; // TODO: Move to config

  Future<List<Wallet>> getWallets() async {
    try {
      final response = await _dio.get('$_baseUrl/wallets');
      return (response.data as List)
          .map((json) => Wallet.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load wallets: $e');
    }
  }

  Future<Wallet> addWallet(Wallet wallet) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/wallets',
        data: wallet.toJson(),
      );
      return Wallet.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to add wallet: $e');
    }
  }

  Future<Wallet> updateWallet(Wallet wallet) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/wallets/${wallet.id}',
        data: wallet.toJson(),
      );
      return Wallet.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update wallet: $e');
    }
  }

  Future<void> deleteWallet(int id) async {
    try {
      await _dio.delete('$_baseUrl/wallets/$id');
    } catch (e) {
      throw Exception('Failed to delete wallet: $e');
    }
  }
} 