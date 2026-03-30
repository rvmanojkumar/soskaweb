import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/auth_api.dart';
import '../../../core/models/user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthApi _authApi = AuthApi();
  User? _user;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  // Wallet balance getter - this is what was missing
  double get walletBalance => _user?.walletBalance ?? 0;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      try {
        _user = await _authApi.getUserProfile();
        notifyListeners();
      } catch (e) {
        print('Error loading user: $e');
        await logout();
      }
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authApi.login(email, password);
      _user = result['user'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', result['token']);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(Map<String, dynamic> userData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement signup API when available
      // For now, simulate a successful signup
      await Future.delayed(Duration(seconds: 1));
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _authApi.logout();
    } catch (e) {
      print('Logout error: $e');
    }

    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    notifyListeners();
  }

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    try {
      _user = await _authApi.updateProfile(data);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Refresh wallet balance from server
  Future<void> refreshWalletBalance() async {
    if (_user != null) {
      try {
        final updatedUser = await _authApi.getUserProfile();
        _user = updatedUser;
        notifyListeners();
      } catch (e) {
        print('Error refreshing wallet: $e');
      }
    }
  }

  // Update local wallet balance (after transactions)
  Future<void> updateWalletBalance(double newBalance) async {
    if (_user != null) {
      _user = User(
        id: _user!.id,
        name: _user!.name,
        email: _user!.email,
        phone: _user!.phone,
        avatar: _user!.avatar,
        dob: _user!.dob,
        role: _user!.role,
        isActive: _user!.isActive,
        walletBalance: newBalance,
        emailVerifiedAt: _user!.emailVerifiedAt,
        createdAt: _user!.createdAt,
      );
      notifyListeners();
    }
  }

  // Deduct amount from wallet (returns true if successful)
  Future<bool> deductFromWallet(double amount) async {
    if (_user == null) return false;
    if (_user!.walletBalance < amount) return false;

    final newBalance = _user!.walletBalance - amount;
    await updateWalletBalance(newBalance);
    return true;
  }

  // Add amount to wallet
  Future<void> addToWallet(double amount) async {
    if (_user != null) {
      final newBalance = _user!.walletBalance + amount;
      await updateWalletBalance(newBalance);
    }
  }

  // Forgot password (placeholder)
  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement when API is available
      await Future.delayed(Duration(seconds: 1));
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Change password (placeholder)
  Future<bool> changePassword(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement when API is available
      await Future.delayed(Duration(seconds: 1));
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
