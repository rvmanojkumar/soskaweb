import '../../../core/network/api_client.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/models/cart.dart';

class CartApi {
  final ApiClient _apiClient = ApiClient();

  Future<Cart> getCart() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.cart);
      final cartData = response['data'] ?? response;
      return Cart.fromJson(cartData);
    } catch (e) {
      print('Error getting cart: $e');
      // Return empty cart on error
      return Cart(items: [], subtotal: 0, total: 0);
    }
  }

  Future<CartItem> addToCart(String variantId, int quantity) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.addToCart,
        data: {
          'product_variant_id': variantId,
          'quantity': quantity,
        },
      );
      final itemData = response['data'] ?? response;
      return CartItem.fromJson(itemData);
    } catch (e) {
      print('Error adding to cart: $e');
      rethrow;
    }
  }

  Future<CartItem> updateCartItem(String cartItemId, int quantity) async {
    try {
      final endpoint =
          ApiEndpoints.updateCartItem.replaceAll('{id}', cartItemId);
      final response = await _apiClient.put(
        endpoint,
        data: {'quantity': quantity},
      );
      final itemData = response['data'] ?? response;
      return CartItem.fromJson(itemData);
    } catch (e) {
      print('Error updating cart item: $e');
      rethrow;
    }
  }

  Future<void> removeCartItem(String cartItemId) async {
    try {
      final endpoint =
          ApiEndpoints.removeCartItem.replaceAll('{id}', cartItemId);
      await _apiClient.delete(endpoint);
    } catch (e) {
      print('Error removing cart item: $e');
      rethrow;
    }
  }

  Future<void> clearCart() async {
    try {
      await _apiClient.delete(ApiEndpoints.clearCart);
    } catch (e) {
      print('Error clearing cart: $e');
      rethrow;
    }
  }
}
