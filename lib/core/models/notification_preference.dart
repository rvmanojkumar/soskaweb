class NotificationPreference {
  final bool orderUpdates;
  final bool promoAlerts;
  final bool vendorAlerts;
  final bool flashSales;
  final bool newsletters;
  
  NotificationPreference({
    required this.orderUpdates,
    required this.promoAlerts,
    required this.vendorAlerts,
    required this.flashSales,
    required this.newsletters,
  });
  
  factory NotificationPreference.fromJson(Map<String, dynamic> json) {
    return NotificationPreference(
      orderUpdates: json['order_updates'] ?? true,
      promoAlerts: json['promo_alerts'] ?? true,
      vendorAlerts: json['vendor_alerts'] ?? false,
      flashSales: json['flash_sales'] ?? true,
      newsletters: json['newsletters'] ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'order_updates': orderUpdates,
      'promo_alerts': promoAlerts,
      'vendor_alerts': vendorAlerts,
      'flash_sales': flashSales,
      'newsletters': newsletters,
    };
  }
}