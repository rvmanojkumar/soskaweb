import '../../../core/network/api_client.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/models/notification_preference.dart';

class NotificationApi {
  final ApiClient _apiClient = ApiClient();

  Future<NotificationPreference> getNotificationPreferences() async {
    try {
      final response =
          await _apiClient.get(ApiEndpoints.notificationPreferences);
      final prefsData = response['data'] ?? response;
      return NotificationPreference.fromJson(prefsData);
    } catch (e) {
      print('Error getting notification preferences: $e');
      return NotificationPreference(
        orderUpdates: true,
        promoAlerts: true,
        vendorAlerts: false,
        flashSales: true,
        newsletters: false,
      );
    }
  }

  Future<NotificationPreference> updateNotificationPreferences(
      Map<String, dynamic> data) async {
    try {
      final response = await _apiClient
          .put(ApiEndpoints.updateNotificationPrefs, data: data);
      final prefsData = response['data'] ?? response;
      return NotificationPreference.fromJson(prefsData);
    } catch (e) {
      print('Error updating notification preferences: $e');
      rethrow;
    }
  }
}
