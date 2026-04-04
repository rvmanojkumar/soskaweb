class BannerModel {
  final String id;
  final String title;
  final String? subtitle;
  final String image;
  final String? ctaLink;
  final String? ctaText;

  BannerModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.image,
    this.ctaLink,
    this.ctaText,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      image: json['image']?.toString() ?? '',
      ctaLink: json['cta_link']?.toString(),
      ctaText: json['cta_text']?.toString(),
    );
  }
}
