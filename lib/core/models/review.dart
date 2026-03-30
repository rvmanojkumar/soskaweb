class Review {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String comment;
  final List<String> images;
  final int helpfulCount;
  final bool isHelpful;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    required this.images,
    required this.helpfulCount,
    required this.isHelpful,
    required this.createdAt,
    this.updatedAt,
  });
  
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      userName: json['user_name'] ?? json['user']['name'] ?? 'Anonymous',
      userAvatar: json['user_avatar'] ?? json['user']['avatar'],
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['review'] ?? json['comment'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      helpfulCount: json['helpful_count'] ?? 0,
      isHelpful: json['is_helpful'] ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }
}