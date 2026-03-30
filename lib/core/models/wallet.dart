import 'package:flutter/material.dart';

class Wallet {
  final String id;
  final double balance;
  final double totalCredited;
  final double totalDebited;
  final DateTime createdAt;
  final DateTime updatedAt;

  Wallet({
    required this.id,
    required this.balance,
    required this.totalCredited,
    required this.totalDebited,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id']?.toString() ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      totalCredited: (json['total_credited'] ?? 0).toDouble(),
      totalDebited: (json['total_debited'] ?? 0).toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }
}

class Transaction {
  final String id;
  final double amount;
  final String type; // credit, debit
  final String status; // success, pending, failed
  final String description;
  final String? orderId;
  final String? paymentMethod;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.status,
    required this.description,
    this.orderId,
    this.paymentMethod,
    this.metadata,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id']?.toString() ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      type: json['type'] ?? 'credit',
      status: json['status'] ?? 'success',
      description: json['description'] ?? '',
      orderId: json['order_id']?.toString(),
      paymentMethod: json['payment_method'],
      metadata: json['metadata'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  String get formattedAmount {
    return '${type == 'credit' ? '+' : '-'}\$${amount.toStringAsFixed(2)}';
  }

  Color get amountColor {
    return type == 'credit' ? Colors.green : Colors.red;
  }

  IconData get typeIcon {
    return type == 'credit' ? Icons.arrow_downward : Icons.arrow_upward;
  }
}
