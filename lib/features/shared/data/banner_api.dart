import '../../../core/network/api_client.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/models/banner.dart';

class BannerApi {
  final ApiClient _apiClient = ApiClient();
  
  Future<List<BannerModel>> getBanners() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.banners);
      final List<dynamic> bannersData = response['data'] ?? [];
      return bannersData.map((json) => BannerModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}