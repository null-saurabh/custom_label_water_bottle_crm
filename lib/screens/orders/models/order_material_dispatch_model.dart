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

  factory OrderMaterialDispatchModel.fromDoc(DocumentSnapshot doc) {
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

    return OrderMaterialDispatchModel(
      id: doc.id,
      orderId: (d['orderId'] ?? '').toString(),
      bottlesSent: _int(d['bottlesSent']),
      labelsSent: _int(d['labelsSent']),
      capsSent: _int(d['capsSent']),
      packagingSent: _int(d['packagingSent']),
      status: (d['status'] ?? 'pending').toString(),
      dispatchDate: _dt(d['dispatchDate'], fallback: _dt(d['createdAt'])),
      createdBy: (d['createdBy'] ?? d['createdByName'] ?? d['createdByEmail'] ?? 'system').toString(),
      createdAt: _dt(d['createdAt']),
      updatedAt: _dt(d['updatedAt'], fallback: _dt(d['createdAt'])),
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
      'createdBy': createdBy,
      'dispatchDate': Timestamp.fromDate(dispatchDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),

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
