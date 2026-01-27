import 'package:cloud_firestore/cloud_firestore.dart';

  class OrderDeliveryEntryModel {
  final String id;
  final String orderId;

  final int quantityDeliveredToday;
  final int cumulativeDelivered;

  final DateTime deliveryDate;

  final String notes;
  final String createdBy;

  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderDeliveryEntryModel({
    required this.id,
    required this.orderId,
    required this.quantityDeliveredToday,
    required this.cumulativeDelivered,
    required this.deliveryDate,
    required this.notes,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderDeliveryEntryModel.fromDoc(
      DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;

    return OrderDeliveryEntryModel(
      id: doc.id,
      orderId: d['orderId'],
      quantityDeliveredToday:
      d['quantityDeliveredToday'],
      cumulativeDelivered:
      d['cumulativeDelivered'],
      deliveryDate:
      d['deliveryDate'].toDate(),
      notes: d['notes'],
      createdBy: d['createdBy'],
      createdAt: d['createdAt'].toDate(),
      updatedAt: d['updatedAt'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'quantityDeliveredToday':
      quantityDeliveredToday,
      'cumulativeDelivered':
      cumulativeDelivered,
      'deliveryDate': deliveryDate,
      'notes': notes,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
  OrderDeliveryEntryModel copyWith({
    String? id,
    DateTime? updatedAt,
  }) {
    return OrderDeliveryEntryModel(
      id: id ?? this.id,
      orderId: orderId,
      quantityDeliveredToday:
      quantityDeliveredToday,
      cumulativeDelivered:
      cumulativeDelivered,
      deliveryDate: deliveryDate,
      notes: notes,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

}
