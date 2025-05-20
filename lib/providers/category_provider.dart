import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';
import '../utils/api_client.dart';
final categoryServiceProvider = Provider<CategoryService>((ref) => CategoryService(ref.read(apiClientProvider)));

final categoryProvider = AsyncNotifierProvider<CategoryNotifier, List<Category>>(() {
  return CategoryNotifier();
});

class CategoryNotifier extends AsyncNotifier<List<Category>> {
  late final CategoryService _categoryService;

  @override
  Future<List<Category>> build() async {
    _categoryService = ref.read(categoryServiceProvider);
    return _fetchCategories();
  }

  Future<List<Category>> _fetchCategories() async {
    try {
      final categories = await _categoryService.getCategories();
      return categories;
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  Future<void> addCategory(Category category) async {
    try {
      state = const AsyncLoading();
      await _categoryService.createCategory(category);
      state = AsyncData(await _fetchCategories());
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      throw Exception('Failed to add category: $e');
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      state = const AsyncLoading();
      await _categoryService.updateCategory(category);
      state = AsyncData(await _fetchCategories());
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      throw Exception('Failed to update category: $e');
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      state = const AsyncLoading();
      await _categoryService.deleteCategory(id);
      state = AsyncData(await _fetchCategories());
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      throw Exception('Failed to delete category: $e');
    }
  }
} 