class Product {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final List<String>? colors; // Make sure this is List<String>? not String?
  final List<String>? sizes;
  final String? categoryId;
  final String? categoryName;
  final String brand;
  final double price;
  final double? discountPrice;
  final double rating;
  final int reviewCount;
  final bool inStock;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.images,
    required this.rating,
    required this.reviewCount,
    required this.inStock,
    this.colors,
    this.sizes,
    this.categoryId,
    this.categoryName,
    required this.brand
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        price: (json['price'] ?? 0).toDouble(),
        discountPrice: json['discount_price'] != null
            ? (json['discount_price']).toDouble()
            : null,
        images: json['images'] != null ? List<String>.from(json['images']) : [],
        rating: (json['rating'] ?? 0).toDouble(),
        reviewCount: json['review_count'] ?? 0,
        inStock: json['in_stock'] ?? false,
        colors: json['colors']?.toString() ?? '',
        sizes: json['sizes']?.toString() ?? '',
        categoryId: json['category_id']?.toString() ?? '',
        categoryName: json['category_name']?.toString() ?? '',
        brand: json['brand']?.toString() ?? '');
  }

  double get currentPrice => discountPrice ?? price;
  double get discountPercentage => discountPrice != null
      ? ((price - discountPrice!) / price * 100).roundToDouble()
      : 0;
}
