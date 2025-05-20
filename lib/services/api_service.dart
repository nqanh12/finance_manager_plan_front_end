import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.example.com';

  ApiService() {
    _dio.options.baseUrl = _baseUrl;
  }

  Future<dynamic> get(String path) async {
    try {
      final response = await _dio.get(path);
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<dynamic> post(String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

  Future<dynamic> put(String path, Map<String, dynamic> data) async {
    try{
      final response = await _dio.put(path, data: data);
      return response.data;
    } catch (e) {
      throw Exception('Failed to put data: $e');
    }
  }

  Future<dynamic> delete(String path) async {
    try{
      final response = await _dio.delete(path);
      return response.data;
    }catch (e){
      throw Exception('Failed to delete data: $e');
    }
  }
} 