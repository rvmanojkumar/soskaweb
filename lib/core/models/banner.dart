class BannerModel {
  final String id;
  final String title;
  final String? subtitle;
  final String image;
  final String? ctaText;
  final String? ctaLink;
  final String type; // hero_slider, promo, category
  final int sortOrder;
  final bool isActive;
  final DateTime startDate;
  final DateTime? endDate;

  BannerModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.image,
    this.ctaText,
    this.ctaLink,
    required this.type,
    required this.sortOrder,
    required this.isActive,
    required this.startDate,
    this.endDate,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      image: json['image'] ?? '',
      ctaText: json['cta_text'],
      ctaLink: json['cta_link'],
      type: json['type'] ?? 'hero_slider',
      sortOrder: json['sort_order'] ?? 0,
      isActive: json['is_active'] ?? true,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : DateTime.now(),
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
    );
  }

  bool get isActiveNow {
    final now = DateTime.now();
    if (!isActive) return false;
    if (now.isBefore(startDate)) return false;
    if (endDate != null && now.isAfter(endDate!)) return false;
    return true;
  }
}
