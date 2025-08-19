// lib/providers/category_provider.dart
import 'package:deventerprise/model/category_model.dart';
import 'package:deventerprise/model/product_list_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/apiServices.dart';

// Create a provider for the ApiService
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

// Create the FutureProvider for categories
final categoryListProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final apiService = ref.watch(apiServiceProvider); // get ApiService instance
  return apiService.fetchCategories(); // call method from service
});

// --- State provider for selected category ---
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// Holds the selected product name
final selectedProductProvider = StateProvider<String?>((ref) => null);


// Create the FutureProvider for products by category
final productsByCategoryProvider = FutureProvider<List<ProductListModel>>((ref) async {
  final category = ref.watch(selectedCategoryProvider);
  if (category == null || category.isEmpty) {
    return [];
  }
  final apiService = ref.watch(apiServiceProvider);
  return apiService.fetchProductsByCategory(category); // Fetch by selected category
});



final scannedCategoryProvider = StateProvider<String?>((ref) => null);
final scannedProductProvider = StateProvider<String?>((ref) => null);


