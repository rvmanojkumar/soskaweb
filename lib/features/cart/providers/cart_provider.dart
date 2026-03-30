import 'package:flutter/material.dart';
import '../data/cart_api.dart';
import '../../../core/models/cart.dart';

class CartProvider extends ChangeNotifier {
  final CartApi _cartApi = CartApi();
  Cart? _cart;
  bool _isLoading = false;
  
  Cart? get cart => _cart;
  bool get isLoading => _isLoading;
  List<CartItem> get items => _cart?.items ?? [];
  int get itemCount => _cart?.items.length ?? 0;
  double get subtotal => _cart?.subtotal ?? 0;
  double get total => _cart?.total ?? 0;
  double get discount => _cart?.discount ?? 0;
  
  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _cart = await _cartApi.getCart();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
  
  Future<void> addToCart(String variantId, int quantity) async {
    try {
      await _cartApi.addToCart(variantId, quantity);
      await loadCart();
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> updateQuantity(String cartItemId, int quantity) async {
    try {
      await _cartApi.updateCartItem(cartItemId, quantity);
      await loadCart();
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> removeItem(String cartItemId) async {
    try {
      await _cartApi.removeCartItem(cartItemId);
      await loadCart();
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> clearCart() async {
    try {
      await _cartApi.clearCart();
      await loadCart();
    } catch (e) {
      rethrow;
    }
  }
}