import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String itemId;
  final int totalBottles;
  final int deliveredBottles;
  final double totalAmount;
  final String status;
  final DateTime deliveryDate;

  OrderModel({
    required this.id,
    required this.itemId,
    required this.totalBottles,
    required this.deliveredBottles,
    required this.totalAmount,
    required this.status,
    required this.deliveryDate,
  });

  factory OrderModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      itemId: d['itemId'],
      totalBottles: d['totalBottles'],
      deliveredBottles: d['deliveredBottles'],
      totalAmount: (d['totalAmount'] ?? 0).toDouble(),
      status: d['status'],
      deliveryDate: (d['deliveryDate'] as Timestamp).toDate(),
    );
  }
}
