import 'package:flutter/foundation.dart';
import 'cart_item.dart';

class Order {
  final String id;
  final DateTime orderDate;
  final DateTime deliveryDate;
  final List<CartItem> items;
  final double totalAmount;
  final String status;
  final String shippingAddress;
  final String paymentMethod;
  final String? note;

  Order({
    required this.id,
    required this.orderDate,
    required this.deliveryDate,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.paymentMethod,
    this.note,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'orderDate': orderDate.toIso8601String(),
        'deliveryDate': deliveryDate.toIso8601String(),
        'items': items.map((e) => e.toJson()).toList(),
        'totalAmount': totalAmount,
        'status': status,
        'shippingAddress': shippingAddress,
        'paymentMethod': paymentMethod,
        'note': note,
      };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
        orderDate: DateTime.parse(json['orderDate']),
        deliveryDate: DateTime.parse(json['deliveryDate']),
        items: (json['items'] as List)
            .map((e) => CartItem.fromJson(e))
            .toList(),
        totalAmount: (json['totalAmount'] as num).toDouble(),
        status: json['status'],
        shippingAddress: json['shippingAddress'] ?? '',
        paymentMethod: json['paymentMethod'] ?? 'Thanh toán khi nhận hàng',
        note: json['note'],
      );
} 