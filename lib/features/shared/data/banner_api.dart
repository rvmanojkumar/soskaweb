import '../../../core/network/api_client.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/mocks/mock_api.dart';
import '../../../core/models/banner.dart';

class BannerApi {
  final ApiClient _apiClient = ApiClient();

  // Get all banners
  Future<List<BannerModel>> getBanners() async {
    // Use mock data if enabled
    if (ApiClient.useMockData) {
      return await MockApi.getBanners();
    }

    // Real API call
    try {
      final response = await _apiClient.get(ApiEndpoints.banners);
      print('Banners API Response: $response');

      List<dynamic> bannersData;
      if (response['data'] != null) {
        bannersData = response['data'];
      } else if (response is List) {
        bannersData = response;
      } else {
        bannersData = [];
      }

      return bannersData.map((json) => BannerModel.fromJson(json)).toList();
    } catch (e) {
      print('Error getting banners: $e');
      return [];
    }
  }

  // Get banners by type
  Future<List<BannerModel>> getBannersByType(String type) async {
    if (ApiClient.useMockData) {
      return await MockApi.getBannersByType(type);
    }

    try {
      final response = await _apiClient.get(
        ApiEndpoints.banners,
        queryParams: {'type': type},
      );
      final List<dynamic> bannersData = response['data'] ?? response;
      return bannersData.map((json) => BannerModel.fromJson(json)).toList();
    } catch (e) {
      print('Error getting banners by type: $e');
      return [];
    }
  }

  // Get active banners (only those currently valid)
  Future<List<BannerModel>> getActiveBanners() async {
    if (ApiClient.useMockData) {
      return await MockApi.getActiveBanners();
    }

    try {
      final response = await _apiClient.get(
        ApiEndpoints.banners,
        queryParams: {'active': 'true'},
      );
      final List<dynamic> bannersData = response['data'] ?? response;
      final banners =
          bannersData.map((json) => BannerModel.fromJson(json)).toList();

      // Filter by date if not done by API
      final now = DateTime.now();
      return banners.where((banner) {
        return banner.isActive &&
            banner.startDate.isBefore(now) &&
            (banner.endDate == null || banner.endDate!.isAfter(now));
      }).toList();
    } catch (e) {
      print('Error getting active banners: $e');
      return [];
    }
  }
}
