import 'package:flutter/material.dart';
import '../data/order_api.dart';
import '../../../core/models/order.dart';

class OrderProvider extends ChangeNotifier {
  final OrderApi _orderApi = OrderApi();
  
  List<Order> _orders = [];
  Order? _currentOrder;
  bool _isLoading = false;
  bool _isPlacingOrder = false;
  String? _error;
  
  // Getters
  List<Order> get orders => _orders;
  Order? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  bool get isPlacingOrder => _isPlacingOrder;
  String? get error => _error;
  
  Future<void> loadOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _orders = await _orderApi.getMyOrders();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Error loading orders: $e');
    }
  }
  
  Future<Order?> loadOrderDetails(String orderId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _currentOrder = await _orderApi.getOrderDetails(orderId);
      _isLoading = false;
      notifyListeners();
      return _currentOrder;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Error loading order details: $e');
      return null;
    }
  }
  
  Future<Map<String, dynamic>> checkout({
    required String addressId,
    required String paymentMethod,
    String? promoCode,
  }) async {
    _isPlacingOrder = true;
    _error = null;
    notifyListeners();
    
    try {
      final result = await _orderApi.checkout(
        addressId: addressId,
        paymentMethod: paymentMethod,
        promoCode: promoCode,
      );
      _isPlacingOrder = false;
      notifyListeners();
      return result;
    } catch (e) {
      _error = e.toString();
      _isPlacingOrder = false;
      notifyListeners();
      print('Error during checkout: $e');
      rethrow;
    }
  }
  
  Future<Map<String, dynamic>> verifyPayment({
    required String orderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    _isPlacingOrder = true;
    notifyListeners();
    
    try {
      final result = await _orderApi.verifyPayment(
        orderId: orderId,
        razorpayPaymentId: razorpayPaymentId,
        razorpaySignature: razorpaySignature,
      );
      _isPlacingOrder = false;
      notifyListeners();
      
      // Reload orders after successful payment
      await loadOrders();
      
      return result;
    } catch (e) {
      _error = e.toString();
      _isPlacingOrder = false;
      notifyListeners();
      print('Error verifying payment: $e');
      rethrow;
    }
  }
  
  Future<bool> cancelOrder(String orderId) async {
    try {
      await _orderApi.cancelOrder(orderId);
      // Update the order in the list
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index] = Order(
          id: _orders[index].id,
          orderNumber: _orders[index].orderNumber,
          subtotal: _orders[index].subtotal,
          discount: _orders[index].discount,
          deliveryFee: _orders[index].deliveryFee,
          total: _orders[index].total,
          status: 'cancelled',
          paymentStatus: _orders[index].paymentStatus,
          paymentMethod: _orders[index].paymentMethod,
          trackingNumber: _orders[index].trackingNumber,
          courierName: _orders[index].courierName,
          shippingAddress: _orders[index].shippingAddress,
          items: _orders[index].items,
          orderDate: _orders[index].orderDate,
          deliveryDate: _orders[index].deliveryDate,
          cancelledAt: DateTime.now(),
          cancellationReason: 'Cancelled by user',
        );
        notifyListeners();
      }
      return true;
    } catch (e) {
      print('Error cancelling order: $e');
      return false;
    }
  }
  
  Future<Map<String, dynamic>> validatePromoCode(String code, double subtotal) async {
    try {
      // This would call your promo API
      // For now, return a mock response
      return {
        'valid': true,
        'discount': subtotal * 0.1, // 10% discount
        'message': 'Promo code applied successfully',
      };
    } catch (e) {
      print('Error validating promo code: $e');
      rethrow;
    }
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}