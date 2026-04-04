import '../../../core/network/api_client.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/models/category.dart';
import '../../../core/models/product.dart';

class CategoryApi {
  final ApiClient _apiClient = ApiClient();

  Future<List<Category>> getCategories() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.categories);
      final List<dynamic> categoriesData = response['data'] ?? response;
      return categoriesData.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }

  Future<Category> getCategoryDetails(String categoryId) async {
    try {
      final endpoint = '${ApiEndpoints.categories}/$categoryId';
      final response = await _apiClient.get(endpoint);
      final categoryData = response['data'] ?? response;
      return Category.fromJson(categoryData);
    } catch (e) {
      print('Error getting category details: $e');
      rethrow;
    }
  }

  Future<List<Product>> getCategoryProducts(
    String categoryId, {
    int page = 1,
    int perPage = 20,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final endpoint =
          ApiEndpoints.categoryProducts.replaceAll('{id}', categoryId);
      final response = await _apiClient.get(
        endpoint,
        queryParams: {
          'page': page,
          'per_page': perPage,
          if (sortBy != null) 'sort_by': sortBy,
          if (sortOrder != null) 'sort_order': sortOrder,
        },
      );
      final List<dynamic> productsData = response['data'] ?? response;
      return productsData.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error getting category products: $e');
      return [];
    }
  }
}
