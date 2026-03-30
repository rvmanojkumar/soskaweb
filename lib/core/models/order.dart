import 'address.dart'; // Add this import
import 'package:flutter/material.dart';

class Order {
  final String id;
  final String orderNumber;
  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double total;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final String? trackingNumber;
  final String? courierName;
  final Address shippingAddress;
  final List<OrderItem> items;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final DateTime? cancelledAt;
  final String? cancellationReason;

  Order({
    required this.id,
    required this.orderNumber,
    required this.subtotal,
    required this.discount,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    this.trackingNumber,
    this.courierName,
    required this.shippingAddress,
    required this.items,
    required this.orderDate,
    this.deliveryDate,
    this.cancelledAt,
    this.cancellationReason,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id']?.toString() ?? '',
      orderNumber: json['order_number'] ?? json['order_id'] ?? '',
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      deliveryFee: (json['delivery_fee'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      paymentStatus: json['payment_status'] ?? 'pending',
      paymentMethod: json['payment_method'] ?? '',
      trackingNumber: json['tracking_number'],
      courierName: json['courier_name'],
      shippingAddress:
          Address.fromJson(json['shipping_address'] ?? json['address'] ?? {}),
      items: (json['items'] as List? ?? [])
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      orderDate: json['order_date'] != null
          ? DateTime.parse(json['order_date'])
          : (json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now()),
      deliveryDate: json['delivery_date'] != null
          ? DateTime.parse(json['delivery_date'])
          : null,
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'])
          : null,
      cancellationReason: json['cancellation_reason'],
    );
  }

  String get statusText {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'out_for_delivery':
        return 'Out for Delivery';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      case 'returned':
        return 'Returned';
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'shipped':
        return Colors.cyan;
      case 'out_for_delivery':
        return Colors.teal;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'returned':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  bool get isCancellable {
    return status == 'pending' || status == 'confirmed';
  }

  bool get isReturnable {
    if (status != 'delivered') return false;
    if (deliveryDate == null) return false;
    final daysSinceDelivery = DateTime.now().difference(deliveryDate!).inDays;
    return daysSinceDelivery <= 7; // Return within 7 days
  }
}

class OrderItem {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final String? variantId;
  final String color;
  final String size;
  final int quantity;
  final double price;
  final double? discountPrice;
  final double total;
  final String? vendorId;
  final String? vendorName;
  final String status;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    this.variantId,
    required this.color,
    required this.size,
    required this.quantity,
    required this.price,
    this.discountPrice,
    required this.total,
    this.vendorId,
    this.vendorName,
    required this.status,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name'] ?? json['name'] ?? '',
      productImage: json['product_image'] ?? json['image'] ?? '',
      variantId: json['variant_id']?.toString(),
      color: json['color'] ?? '',
      size: json['size'] ?? '',
      quantity: json['quantity'] ?? 1,
      price: (json['price'] ?? 0).toDouble(),
      discountPrice: json['discount_price'] != null
          ? (json['discount_price']).toDouble()
          : null,
      total: (json['total'] ?? 0).toDouble(),
      vendorId: json['vendor_id']?.toString(),
      vendorName: json['vendor_name'],
      status: json['status'] ?? 'pending',
    );
  }

  double get currentPrice => discountPrice ?? price;
}
