import 'package:cloud_firestore/cloud_firestore.dart';

class OrderActivityModel {
  final String id;
  final String orderId;
  final String clientId;


  final String type;        // created / dispatch / production / delivery / payment
  final String title;       // Short headline
  final String description; // Human readable

  final String stage;       // order / dispatch / production / delivery / finance

  final DateTime activityDate;

  final String createdBy;

  final DateTime createdAt;

  const OrderActivityModel({
    required this.id,
    required this.clientId,
    required this.orderId,
    required this.type,
    required this.title,
    required this.description,
    required this.stage,
    required this.activityDate,
    required this.createdBy,
    required this.createdAt,
  });

  factory OrderActivityModel.fromDoc(DocumentSnapshot doc) {
    final d = (doc.data() as Map<String, dynamic>? ?? {});

    DateTime _dt(dynamic v, {DateTime? fallback}) {
      if (v is Timestamp) return v.toDate();
      if (v is DateTime) return v;
      if (v is String) return DateTime.tryParse(v) ?? (fallback ?? DateTime.now());
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      return fallback ?? DateTime.now();
    }

    return OrderActivityModel(
      id: doc.id,
      orderId: (d['orderId'] ?? '').toString(),
      clientId: (d['clientId'] ?? '').toString(),
      type: (d['type'] ?? '').toString(),
      title: (d['title'] ?? '').toString(),
      description: (d['description'] ?? '').toString(),
      stage: (d['stage'] ?? '').toString(),
      activityDate: _dt(d['activityDate'], fallback: _dt(d['createdAt'])),
      createdBy: (d['createdBy'] ?? d['createdByName'] ?? d['createdByEmail'] ?? 'system').toString(),
      createdAt: _dt(d['createdAt']),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'clientId': clientId,
      'type': type,
      'title': title,
      'description': description,
      'stage': stage,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'activityDate': Timestamp.fromDate(activityDate),
    };
  }

  OrderActivityModel copyWith({
    String? id,
    DateTime? createdAt,
  }) {
    return OrderActivityModel(
      id: id ?? this.id,
      orderId: orderId,
      clientId: clientId,
      type: type,
      title: title,
      description: description,
      stage: stage,
      activityDate: activityDate,
      createdBy: createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
