import '../../../core/network/api_client.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/models/user.dart';

class AuthApi {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      // Handle different response structures
      Map<String, dynamic> userData;
      String token;

      // Check if response has nested data structure
      if (response.containsKey('data')) {
        userData = response['data']['user'] ?? response['data'];
        token = response['data']['token'] ?? response['token'];
      } else {
        userData = response['user'] ?? response;
        token = response['token'] ?? '';
      }

      return {
        'token': token,
        'user': User.fromJson(userData),
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<double> getWalletBalance() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.wallet);
      final walletData =
          response.containsKey('data') ? response['data'] : response;
      return (walletData['balance'] ?? 0).toDouble();
    } catch (e) {
      print('Error getting wallet balance: $e');
      return 0;
    }
  }

  Future<User> getUserProfile() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.userProfile);

      // Handle different response structures
      final userData =
          response.containsKey('data') ? response['data'] : response;
      return User.fromJson(userData);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.updateProfile,
        data: data,
      );

      final userData =
          response.containsKey('data') ? response['data'] : response;
      return User.fromJson(userData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } catch (e) {
      // Don't rethrow on logout, just log
      print('Logout error: $e');
    }
  }

  // TODO: Add forgot password when endpoint is available
  // Future<void> forgotPassword(String email) async {
  //   try {
  //     await _apiClient.post(ApiEndpoints.forgotPassword, data: {'email': email});
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // TODO: Add change password when endpoint is available
  // Future<void> changePassword(Map<String, dynamic> data) async {
  //   try {
  //     await _apiClient.put(ApiEndpoints.changePassword, data: data);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
