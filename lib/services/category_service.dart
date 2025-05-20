import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';
import '../utils/api_client.dart';

final categoryServiceProvider = Provider<CategoryService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return CategoryService(apiClient);
});

class CategoryService {
  final ApiClient _apiClient;

  CategoryService(this._apiClient);

  Future<List<Category>> getCategories() async {
    final response = await _apiClient.get('/categories');
    return (response as List).map((json) => Category.fromJson(json)).toList();
  }

  Future<Category> createCategory(Category category) async {
    final response = await _apiClient.post('/categories', category.toJson());
    return Category.fromJson(response);
  }

  Future<Category> updateCategory(Category category) async {
    final response = await _apiClient.put('/categories/${category.id}', category.toJson());
    return Category.fromJson(response);
  }

  Future<void> deleteCategory(int id) async {
    await _apiClient.delete('/categories/$id');
  }
} 