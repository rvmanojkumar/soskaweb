class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final List<String> images;
  final List<String> colors;
  final List<String> sizes;
  final double rating;
  final int reviewCount;
  final String categoryId;
  final String categoryName;
  final String brand;
  final bool inStock;
  final int stockQuantity;
  final List<String> tags;
  final String? vendorId;
  final String? vendorName;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.images,
    required this.colors,
    required this.sizes,
    required this.rating,
    required this.reviewCount,
    required this.categoryId,
    required this.categoryName,
    required this.brand,
    required this.inStock,
    required this.stockQuantity,
    required this.tags,
    this.vendorId,
    this.vendorName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discountPrice: json['discount_price'] != null
          ? (json['discount_price']).toDouble()
          : null,
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      colors: json['colors'] != null ? List<String>.from(json['colors']) : [],
      sizes: json['sizes'] != null ? List<String>.from(json['sizes']) : [],
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      categoryId: json['category_id']?.toString() ?? '',
      categoryName: json['category_name'] ?? '',
      brand: json['brand'] ?? '',
      inStock: json['in_stock'] ?? false,
      stockQuantity: json['stock_quantity'] ?? 0,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      vendorId: json['vendor_id']?.toString(),
      vendorName: json['vendor_name'],
    );
  }

  double get currentPrice => discountPrice ?? price;
  double get discountPercentage => discountPrice != null
      ? ((price - discountPrice!) / price * 100).roundToDouble()
      : 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discount_price': discountPrice,
      'images': images,
      'colors': colors,
      'sizes': sizes,
      'rating': rating,
      'review_count': reviewCount,
      'category_id': categoryId,
      'category_name': categoryName,
      'brand': brand,
      'in_stock': inStock,
      'stock_quantity': stockQuantity,
      'tags': tags,
      'vendor_id': vendorId,
      'vendor_name': vendorName,
    };
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }
}
