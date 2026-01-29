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
    final d = doc.data() as Map<String, dynamic>;

    return OrderActivityModel(
      id: doc.id,
      orderId: d['orderId'],
      clientId: d['clientId'],
      type: d['type'],
      title: d['title'],
      description: d['description'],
      stage: d['stage'],
      activityDate: d['activityDate'].toDate(),
      createdBy: d['createdBy'],
      createdAt: d['createdAt'].toDate(),
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
      'activityDate': activityDate,
      'createdBy': createdBy,
      'createdAt': createdAt,
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
