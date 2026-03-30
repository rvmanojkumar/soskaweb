import 'package:flutter/material.dart';
import '../data/profile_api.dart';
import '../../../core/models/address.dart';
import '../../../core/models/wallet.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileApi _profileApi = ProfileApi();

  List<Address> _addresses = [];
  Wallet? _wallet;
  List<Transaction> _transactions = [];

  bool _isLoadingAddresses = false;
  bool _isLoadingWallet = false;
  bool _isLoadingTransactions = false;
  String? _error;

  // Getters
  List<Address> get addresses => _addresses;
  Wallet? get wallet => _wallet;
  List<Transaction> get transactions => _transactions;
  bool get isLoadingAddresses => _isLoadingAddresses;
  bool get isLoadingWallet => _isLoadingWallet;
  bool get isLoadingTransactions => _isLoadingTransactions;
  String? get error => _error;

  // Get default address
  Address? get defaultAddress {
    try {
      return _addresses.firstWhere((address) => address.isDefault);
    } catch (e) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  // Address Methods
  Future<void> loadAddresses() async {
    _isLoadingAddresses = true;
    _error = null;
    notifyListeners();

    try {
      _addresses = await _profileApi.getAddresses();
      _isLoadingAddresses = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoadingAddresses = false;
      notifyListeners();
      print('Error loading addresses: $e');
    }
  }

  Future<Address?> addAddress(Map<String, dynamic> addressData) async {
    try {
      final newAddress = await _profileApi.addAddress(addressData);

      // If this address is set as default, update other addresses
      if (newAddress.isDefault) {
        _updateDefaultAddress(newAddress.id);
      }

      _addresses.add(newAddress);
      notifyListeners();
      return newAddress;
    } catch (e) {
      print('Error adding address: $e');
      rethrow;
    }
  }

  Future<Address?> updateAddress(
      String addressId, Map<String, dynamic> data) async {
    try {
      final updatedAddress = await _profileApi.updateAddress(addressId, data);

      // Update the address in the list
      final index = _addresses.indexWhere((a) => a.id == addressId);
      if (index != -1) {
        // If this address is set as default, update other addresses
        if (updatedAddress.isDefault) {
          _updateDefaultAddress(updatedAddress.id);
        }
        _addresses[index] = updatedAddress;
        notifyListeners();
      }

      return updatedAddress;
    } catch (e) {
      print('Error updating address: $e');
      rethrow;
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      await _profileApi.deleteAddress(addressId);
      _addresses.removeWhere((a) => a.id == addressId);
      notifyListeners();
    } catch (e) {
      print('Error deleting address: $e');
      rethrow;
    }
  }

  void _updateDefaultAddress(String newDefaultId) {
    for (var i = 0; i < _addresses.length; i++) {
      if (_addresses[i].id == newDefaultId) {
        _addresses[i] = Address(
          id: _addresses[i].id,
          addressLine1: _addresses[i].addressLine1,
          addressLine2: _addresses[i].addressLine2,
          city: _addresses[i].city,
          state: _addresses[i].state,
          country: _addresses[i].country,
          postalCode: _addresses[i].postalCode,
          phone: _addresses[i].phone,
          addressType: _addresses[i].addressType,
          isDefault: true,
          createdAt: _addresses[i].createdAt,
          updatedAt: _addresses[i].updatedAt,
        );
      } else if (_addresses[i].isDefault) {
        _addresses[i] = Address(
          id: _addresses[i].id,
          addressLine1: _addresses[i].addressLine1,
          addressLine2: _addresses[i].addressLine2,
          city: _addresses[i].city,
          state: _addresses[i].state,
          country: _addresses[i].country,
          postalCode: _addresses[i].postalCode,
          phone: _addresses[i].phone,
          addressType: _addresses[i].addressType,
          isDefault: false,
          createdAt: _addresses[i].createdAt,
          updatedAt: _addresses[i].updatedAt,
        );
      }
    }
  }

  // Wallet Methods
  Future<void> loadWallet() async {
    _isLoadingWallet = true;
    _error = null;
    notifyListeners();

    try {
      _wallet = await _profileApi.getWallet();
      _isLoadingWallet = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoadingWallet = false;
      notifyListeners();
      print('Error loading wallet: $e');
    }
  }

  Future<void> loadWalletTransactions() async {
    _isLoadingTransactions = true;
    _error = null;
    notifyListeners();

    try {
      _transactions = await _profileApi.getWalletTransactions();
      _isLoadingTransactions = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoadingTransactions = false;
      notifyListeners();
      print('Error loading transactions: $e');
    }
  }

  Future<Map<String, dynamic>> addFunds(
      double amount, String paymentMethod) async {
    try {
      final result = await _profileApi.addFunds(amount, paymentMethod);

      // Reload wallet after adding funds
      await loadWallet();
      await loadWalletTransactions();

      return result;
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
      // This would be similar to order payment verification
      // For wallet recharge verification
      final result =
          await _profileApi.verifyWalletPayment(orderId, paymentId, signature);

      // Reload wallet after verification
      await loadWallet();
      await loadWalletTransactions();

      return result;
    } catch (e) {
      print('Error verifying wallet payment: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> redeemWallet(
      double amount, String orderId) async {
    try {
      final result = await _profileApi.redeemWallet(amount, orderId);

      // Reload wallet after redemption
      await loadWallet();
      await loadWalletTransactions();

      return result;
    } catch (e) {
      print('Error redeeming wallet: $e');
      rethrow;
    }
  }

  // Helper Methods
  void clearError() {
    _error = null;
    notifyListeners();
  }

  void refresh() async {
    await loadAddresses();
    await loadWallet();
    await loadWalletTransactions();
  }
}
