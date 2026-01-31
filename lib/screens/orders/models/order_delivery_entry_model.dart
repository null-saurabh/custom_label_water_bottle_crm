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

  factory OrderDeliveryEntryModel.fromDoc(DocumentSnapshot doc) {
    final d = (doc.data() as Map<String, dynamic>? ?? {});

    DateTime _dt(dynamic v, {DateTime? fallback}) {
      if (v is Timestamp) return v.toDate();
      if (v is DateTime) return v;
      if (v is String) return DateTime.tryParse(v) ?? (fallback ?? DateTime.now());
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      return fallback ?? DateTime.now();
    }

    int _int(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v?.toString() ?? '') ?? 0;
    }

    return OrderDeliveryEntryModel(
      id: doc.id,
      orderId: (d['orderId'] ?? '').toString(),
      quantityDeliveredToday: _int(d['quantityDeliveredToday']),
      cumulativeDelivered: _int(d['cumulativeDelivered']),
      deliveryDate: _dt(d['deliveryDate'], fallback: _dt(d['createdAt'])),
      notes: (d['notes'] ?? '').toString(),
      createdBy: (d['createdBy'] ?? d['createdByName'] ?? d['createdByEmail'] ?? 'system').toString(),
      createdAt: _dt(d['createdAt']),
      updatedAt: _dt(d['updatedAt'], fallback: _dt(d['createdAt'])),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'quantityDeliveredToday':
      quantityDeliveredToday,
      'cumulativeDelivered':
      cumulativeDelivered,
      'notes': notes,
      'createdBy': createdBy,
      'deliveryDate': Timestamp.fromDate(deliveryDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),

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
