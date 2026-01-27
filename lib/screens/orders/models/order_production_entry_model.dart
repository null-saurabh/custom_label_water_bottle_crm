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

  factory OrderProductionEntryModel.fromDoc(
      DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;

    return OrderProductionEntryModel(
      id: doc.id,
      orderId: d['orderId'],
      quantityProducedToday:
      d['quantityProducedToday'],
      cumulativeProduced:
      d['cumulativeProduced'],
      productionDate:
      d['productionDate'].toDate(),
      notes: d['notes'],
      createdBy: d['createdBy'],
      createdAt: d['createdAt'].toDate(),
      updatedAt: d['updatedAt'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'quantityProducedToday':
      quantityProducedToday,
      'cumulativeProduced':
      cumulativeProduced,
      'productionDate': productionDate,
      'notes': notes,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
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
