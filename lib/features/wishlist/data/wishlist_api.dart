import '../../../core/network/api_client.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/models/product.dart';

class WishlistApi {
  final ApiClient _apiClient = ApiClient();

  Future<List<Product>> getWishlist() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.wishlist);
      final List<dynamic> productsData = response['data'] ?? response;
      return productsData.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error getting wishlist: $e');
      return [];
    }
  }

  Future<void> addToWishlist(String productId) async {
    try {
      final endpoint = ApiEndpoints.addToWishlist.replaceAll('{id}', productId);
      await _apiClient.post(endpoint);
    } catch (e) {
      print('Error adding to wishlist: $e');
      rethrow;
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    try {
      final endpoint =
          ApiEndpoints.removeFromWishlist.replaceAll('{id}', productId);
      await _apiClient.delete(endpoint);
    } catch (e) {
      print('Error removing from wishlist: $e');
      rethrow;
    }
  }
}
