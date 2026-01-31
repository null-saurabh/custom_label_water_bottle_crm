import 'package:cloud_firestore/cloud_firestore.dart';

class OrderProductionEntryModel {
  final String id;
  final String orderId;

  final int quantityProducedToday; // 🔥 +100 today
  final int cumulativeProduced;    // 🔥 running total

  final DateTime productionDate;

  final String notes;
  final String createdBy;

  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderProductionEntryModel({
    required this.id,
    required this.orderId,
    required this.quantityProducedToday,
    required this.cumulativeProduced,
    required this.productionDate,
    required this.notes,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderProductionEntryModel.fromDoc(DocumentSnapshot doc) {
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

    return OrderProductionEntryModel(
      id: doc.id,
      orderId: (d['orderId'] ?? '').toString(),
      quantityProducedToday: _int(d['quantityProducedToday']),
      cumulativeProduced: _int(d['cumulativeProduced']),
      productionDate: _dt(d['productionDate'], fallback: _dt(d['createdAt'])),
      notes: (d['notes'] ?? '').toString(),
      createdBy: (d['createdBy'] ?? d['createdByName'] ?? d['createdByEmail'] ?? 'system').toString(),
      createdAt: _dt(d['createdAt']),
      updatedAt: _dt(d['updatedAt'], fallback: _dt(d['createdAt'])),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'quantityProducedToday':
      quantityProducedToday,
      'cumulativeProduced':
      cumulativeProduced,
      'notes': notes,
      'createdBy': createdBy,
      'productionDate': Timestamp.fromDate(productionDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),

    };
  }
  OrderProductionEntryModel copyWith({
    String? id,
    DateTime? updatedAt,
  }) {
    return OrderProductionEntryModel(
      id: id ?? this.id,
      orderId: orderId,
      quantityProducedToday:
      quantityProducedToday,
      cumulativeProduced:
      cumulativeProduced,
      productionDate: productionDate,
      notes: notes,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

}
