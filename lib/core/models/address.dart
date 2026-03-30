class Address {
  final String id;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final String phone;
  final String addressType; // home, work, other
  final bool isDefault;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Address({
    required this.id,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.phone,
    required this.addressType,
    required this.isDefault,
    required this.createdAt,
    this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id']?.toString() ?? '',
      addressLine1: json['address_line1'] ?? json['address'] ?? '',
      addressLine2: json['address_line2'],
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      postalCode: json['postal_code'] ?? json['pincode'] ?? '',
      phone: json['phone'] ?? json['mobile'] ?? '',
      addressType: json['address_type'] ?? 'home',
      isDefault: json['is_default'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address_line1': addressLine1,
      'address_line2': addressLine2,
      'city': city,
      'state': state,
      'country': country,
      'postal_code': postalCode,
      'phone': phone,
      'address_type': addressType,
      'is_default': isDefault,
    };
  }

  String get formattedAddress {
    String address = addressLine1;
    if (addressLine2 != null && addressLine2!.isNotEmpty) {
      address += ', $addressLine2';
    }
    address += ', $city, $state - $postalCode';
    address += ', $country';
    return address;
  }
}
