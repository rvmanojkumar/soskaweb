class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final DateTime? dob;
  final String? role;
  final bool isActive;
  final double walletBalance;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.dob,
    this.role,
    required this.isActive,
    required this.walletBalance,
    this.emailVerifiedAt,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Handle different possible wallet balance field names from API
    double walletBalance = 0;

    // Try different possible field names
    if (json['wallet_balance'] != null) {
      walletBalance = (json['wallet_balance'] as num).toDouble();
    } else if (json['wallet'] != null) {
      if (json['wallet'] is Map) {
        walletBalance = (json['wallet']['balance'] as num?)?.toDouble() ?? 0;
      } else {
        walletBalance = (json['wallet'] as num).toDouble();
      }
    } else if (json['balance'] != null) {
      walletBalance = (json['balance'] as num).toDouble();
    }

    return User(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      avatar: json['avatar']?.toString(),
      dob: json['dob'] != null
          ? DateTime.tryParse(json['dob'].toString())
          : null,
      role: json['role']?.toString(),
      isActive: json['is_active'] ?? true,
      walletBalance: walletBalance,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.tryParse(json['email_verified_at'].toString())
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'dob': dob?.toIso8601String(),
      'role': role,
      'is_active': isActive,
      'wallet_balance': walletBalance,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
