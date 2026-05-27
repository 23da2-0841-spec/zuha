import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item.dart';

class ZOrder {
  final String id;
  final DateTime date;
  final List<ZCartItem> items;
  final double total;
  final String status;
  final String estimatedDelivery;

  const ZOrder({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    required this.status,
    required this.estimatedDelivery,
  });

  factory ZOrder.fromFirestore(Map<String, dynamic> map, String id,
      List<ZCartItem> items) {
    return ZOrder(
      id: id,
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      items: items,
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] as String? ?? 'Pending',
      estimatedDelivery: map['estimatedDelivery'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'status': status,
      'estimatedDelivery': estimatedDelivery,
    };
  }
}
