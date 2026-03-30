import '../../../core/network/api_client.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/models/address.dart';
import '../../../core/models/wallet.dart';

class ProfileApi {
  final ApiClient _apiClient = ApiClient();

  // Addresses
  Future<List<Address>> getAddresses() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.addresses);
      final List<dynamic> addressesData = response['data'] ?? response;
      return addressesData.map((json) => Address.fromJson(json)).toList();
    } catch (e) {
      print('Error getting addresses: $e');
      return [];
    }
  }

  Future<Address> addAddress(Map<String, dynamic> data) async {
    try {
      final response =
          await _apiClient.post(ApiEndpoints.addAddress, data: data);
      final addressData = response['data'] ?? response;
      return Address.fromJson(addressData);
    } catch (e) {
      print('Error adding address: $e');
      rethrow;
    }
  }

  Future<Address> updateAddress(
      String addressId, Map<String, dynamic> data) async {
    try {
      final endpoint = ApiEndpoints.updateAddress.replaceAll('{id}', addressId);
      final response = await _apiClient.put(endpoint, data: data);
      final addressData = response['data'] ?? response;
      return Address.fromJson(addressData);
    } catch (e) {
      print('Error updating address: $e');
      rethrow;
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      final endpoint = ApiEndpoints.deleteAddress.replaceAll('{id}', addressId);
      await _apiClient.delete(endpoint);
    } catch (e) {
      print('Error deleting address: $e');
      rethrow;
    }
  }

  // Wallet
  Future<Wallet> getWallet() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.wallet);
      final walletData = response['data'] ?? response;
      return Wallet.fromJson(walletData);
    } catch (e) {
      print('Error getting wallet: $e');
      return Wallet(
        id: '',
        balance: 0,
        totalCredited: 0,
        totalDebited: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  Future<List<Transaction>> getWalletTransactions() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.walletTransactions);
      final List<dynamic> transactionsData = response['data'] ?? response;
      return transactionsData
          .map((json) => Transaction.fromJson(json))
          .toList();
    } catch (e) {
      print('Error getting wallet transactions: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> addFunds(
      double amount, String paymentMethod) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.addFunds,
        data: {
          'amount': amount,
          'payment_method': paymentMethod,
        },
      );
      return response;
    } catch (e) {
      print('Error adding funds: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> verifyWalletPayment(
    String orderId,
    String paymentId,
    String signature,
  ) async {
    try {
      // Create a wallet-specific verification endpoint
      // If not available, you can use the same payment verification endpoint
      final response = await _apiClient.post(
        '/wallet/verify-payment', // Update this endpoint based on your API
        data: {
          'order_id': orderId,
          'razorpay_payment_id': paymentId,
          'razorpay_signature': signature,
        },
      );
      return response;
    } catch (e) {
      print('Error verifying wallet payment: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> redeemWallet(
      double amount, String orderId) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.redeemWallet,
        data: {
          'amount': amount,
          'order_id': orderId,
        },
      );
      return response;
    } catch (e) {
      print('Error redeeming wallet: $e');
      rethrow;
    }
  }
}
