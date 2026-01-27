import 'package:cloud_firestore/cloud_firestore.dart';

class OrderMaterialDispatchModel {
  final String id;
  final String orderId;

  final int bottlesSent;
  final int labelsSent;
  final int capsSent;
  final int packagingSent;

  final String status; // pending / partial / completed

  final DateTime dispatchDate;
  final String createdBy;

  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderMaterialDispatchModel({
    required this.id,
    required this.orderId,
    required this.bottlesSent,
    required this.labelsSent,
    required this.capsSent,
    required this.packagingSent,
    required this.status,
    required this.dispatchDate,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderMaterialDispatchModel.fromDoc(
      DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;

    return OrderMaterialDispatchModel(
      id: doc.id,
      orderId: d['orderId'],
      bottlesSent: d['bottlesSent'],
      labelsSent: d['labelsSent'],
      capsSent: d['capsSent'],
      packagingSent: d['packagingSent'],
      status: d['status'],
      dispatchDate: d['dispatchDate'].toDate(),
      createdBy: d['createdBy'],
      createdAt: d['createdAt'].toDate(),
      updatedAt: d['updatedAt'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'bottlesSent': bottlesSent,
      'labelsSent': labelsSent,
      'capsSent': capsSent,
      'packagingSent': packagingSent,
      'status': status,
      'dispatchDate': dispatchDate,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
  OrderMaterialDispatchModel copyWith({
    String? id,
    DateTime? updatedAt,
  }) {
    return OrderMaterialDispatchModel(
      id: id ?? this.id,
      orderId: orderId,
      bottlesSent: bottlesSent,
      labelsSent: labelsSent,
      capsSent: capsSent,
      packagingSent: packagingSent,
      status: status,
      dispatchDate: dispatchDate,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

}
