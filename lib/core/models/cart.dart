class CartItem {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final double? discountPrice;
  final String variantId;
  final String color;
  final String size;
  int quantity;
  final int maxQuantity;
  final String? vendorId;
  
  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    this.discountPrice,
    required this.variantId,
    required this.color,
    required this.size,
    required this.quantity,
    required this.maxQuantity,
    this.vendorId,
  });
  
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'].toString(),
      productId: json['product_id'].toString(),
      productName: json['product_name'] ?? '',
      productImage: json['product_image'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discountPrice: json['discount_price'] != null ? (json['discount_price']).toDouble() : null,
      variantId: json['variant_id']?.toString() ?? '',
      color: json['color'] ?? '',
      size: json['size'] ?? '',
      quantity: json['quantity'] ?? 1,
      maxQuantity: json['max_quantity'] ?? 99,
      vendorId: json['vendor_id']?.toString(),
    );
  }
  
  double get currentPrice => discountPrice ?? price;
  double get totalPrice => currentPrice * quantity;
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'price': price,
      'discount_price': discountPrice,
      'variant_id': variantId,
      'color': color,
      'size': size,
      'quantity': quantity,
      'max_quantity': maxQuantity,
      'vendor_id': vendorId,
    };
  }
}

class Cart {
  final List<CartItem> items;
  final double subtotal;
  final double? discount;
  final double? deliveryFee;
  final double total;
  
  Cart({
    required this.items,
    required this.subtotal,
    this.discount,
    this.deliveryFee,
    required this.total,
  });
  
  factory Cart.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List? ?? [];
    return Cart(
      items: itemsList.map((item) => CartItem.fromJson(item)).toList(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      discount: json['discount'] != null ? (json['discount']).toDouble() : null,
      deliveryFee: json['delivery_fee'] != null ? (json['delivery_fee']).toDouble() : null,
      total: (json['total'] ?? 0).toDouble(),
    );
  }
}