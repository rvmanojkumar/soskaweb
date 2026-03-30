class Category {
  final String id;
  final String name;
  final String? description;
  final String? image;
  final String? parentId; // ✅ FIXED
  final int sortOrder;
  final bool isActive;
  final int productCount;
  final DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.image,
    this.parentId,
    required this.sortOrder,
    required this.isActive,
    required this.productCount,
    required this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      image: json['image'],
      parentId: json['parent_id']?.toString(), // ✅ FIXED
      sortOrder: json['sort_order'] ?? 0,
      isActive: json['is_active'] ?? true,
      productCount: json['product_count'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}
