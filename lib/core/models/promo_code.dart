class PromoCode {
  final String id;
  final String code;
  final String type; // percentage, fixed
  final double value;
  final double? minOrderValue;
  final double? maxDiscount;
  final int? usageLimit;
  final int? usageCount;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final String? description;
  
  PromoCode({
    required this.id,
    required this.code,
    required this.type,
    required this.value,
    this.minOrderValue,
    this.maxDiscount,
    this.usageLimit,
    this.usageCount,
    required this.startDate,
    this.endDate,
    required this.isActive,
    this.description,
  });
  
  factory PromoCode.fromJson(Map<String, dynamic> json) {
    return PromoCode(
      id: json['id']?.toString() ?? '',
      code: json['code'] ?? '',
      type: json['type'] ?? 'percentage',
      value: (json['value'] ?? 0).toDouble(),
      minOrderValue: json['min_order_value'] != null ? (json['min_order_value']).toDouble() : null,
      maxDiscount: json['max_discount'] != null ? (json['max_discount']).toDouble() : null,
      usageLimit: json['usage_limit'],
      usageCount: json['usage_count'],
      startDate: json['start_date'] != null 
          ? DateTime.parse(json['start_date']) 
          : DateTime.now(),
      endDate: json['end_date'] != null 
          ? DateTime.parse(json['end_date']) 
          : null,
      isActive: json['is_active'] ?? true,
      description: json['description'],
    );
  }
  
  double calculateDiscount(double subtotal) {
    if (minOrderValue != null && subtotal < minOrderValue!) {
      return 0;
    }
    
    double discount = type == 'percentage' 
        ? subtotal * (value / 100)
        : value;
    
    if (maxDiscount != null && discount > maxDiscount!) {
      discount = maxDiscount!;
    }
    
    return discount;
  }
  
  bool get isValid {
    final now = DateTime.now();
    if (!isActive) return false;
    if (now.isBefore(startDate)) return false;
    if (endDate != null && now.isAfter(endDate!)) return false;
    if (usageLimit != null && usageCount != null && usageCount! >= usageLimit!) {
      return false;
    }
    return true;
  }
}