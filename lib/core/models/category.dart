class Category {
  final String id;
  final String name;
  final String? image;
  final String? parentId;

  Category({
    required this.id,
    required this.name,
    this.image,
    this.parentId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString(),
    );
  }
}
