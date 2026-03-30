import 'package:flutter/material.dart';
import '../data/wishlist_api.dart';
import '../../../core/models/product.dart';

class WishlistProvider extends ChangeNotifier {
  final WishlistApi _wishlistApi = WishlistApi();
  
  List<Product> _wishlistItems = [];
  bool _isLoading = false;
  String? _error;
  
  // Getters
  List<Product> get wishlistItems => _wishlistItems;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get itemCount => _wishlistItems.length;
  
  WishlistProvider() {
    loadWishlist();
  }
  
  Future<void> loadWishlist() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _wishlistItems = await _wishlistApi.getWishlist();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Error loading wishlist: $e');
    }
  }
  
  Future<bool> addToWishlist(String productId) async {
    try {
      await _wishlistApi.addToWishlist(productId);
      await loadWishlist(); // Reload to get updated list
      return true;
    } catch (e) {
      print('Error adding to wishlist: $e');
      return false;
    }
  }
  
  Future<bool> removeFromWishlist(String productId) async {
    try {
      await _wishlistApi.removeFromWishlist(productId);
      _wishlistItems.removeWhere((item) => item.id == productId);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error removing from wishlist: $e');
      return false;
    }
  }
  
  bool isInWishlist(String productId) {
    return _wishlistItems.any((item) => item.id == productId);
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}