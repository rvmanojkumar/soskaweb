import '../../../core/network/api_client.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/models/order.dart';

class OrderApi {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> checkout({
    required String addressId,
    required String paymentMethod,
    String? promoCode,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.checkout,
        data: {
          'address_id': addressId,
          'payment_method': paymentMethod,
          if (promoCode != null) 'promo_code': promoCode,
        },
      );
      return response;
    } catch (e) {
      print('Error during checkout: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> verifyPayment({
    required String orderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.verifyPayment,
        data: {
          'order_id': orderId,
          'razorpay_payment_id': razorpayPaymentId,
          'razorpay_signature': razorpaySignature,
        },
      );
      return response;
    } catch (e) {
      print('Error verifying payment: $e');
      rethrow;
    }
  }

  Future<List<Order>> getMyOrders() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.orders);
      final List<dynamic> ordersData = response['data'] ?? response;
      return ordersData.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      print('Error getting orders: $e');
      return [];
    }
  }

  Future<Order> getOrderDetails(String orderId) async {
    try {
      final endpoint = ApiEndpoints.orderDetails.replaceAll('{id}', orderId);
      final response = await _apiClient.get(endpoint);
      final orderData = response['data'] ?? response;
      return Order.fromJson(orderData);
    } catch (e) {
      print('Error getting order details: $e');
      rethrow;
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      final endpoint = ApiEndpoints.cancelOrder.replaceAll('{id}', orderId);
      await _apiClient.post(endpoint);
    } catch (e) {
      print('Error cancelling order: $e');
      rethrow;
    }
  }
}
