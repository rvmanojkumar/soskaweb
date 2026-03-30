import '../../../core/network/api_client.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/models/promo_code.dart';

class PromoApi {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> validatePromoCode(
      String code, double subtotal) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.validatePromoCode,
        data: {
          'code': code,
          'subtotal': subtotal,
        },
      );
      return response;
    } catch (e) {
      print('Error validating promo code: $e');
      rethrow;
    }
  }

  Future<List<PromoCode>> getUserPromoCodes() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.userPromoCodes);
      final List<dynamic> codesData = response['data'] ?? response;
      return codesData.map((json) => PromoCode.fromJson(json)).toList();
    } catch (e) {
      print('Error getting user promo codes: $e');
      return [];
    }
  }

  Future<void> applyPromoCode(String orderId, String code) async {
    try {
      final endpoint = ApiEndpoints.applyPromoCode.replaceAll('{id}', orderId);
      await _apiClient.post(endpoint, data: {'code': code});
    } catch (e) {
      print('Error applying promo code: $e');
      rethrow;
    }
  }
}
