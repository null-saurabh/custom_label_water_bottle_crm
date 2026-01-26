import 'package:cloud_firestore/cloud_firestore.dart';

class OrderActivityModel {
  final String id;
  final String type; // created / production_added / delivery_added / status_changed / payment_updated
  final String title;
  final String description;
  final Map<String, dynamic>? meta;
  final String createdBy;
  final DateTime createdAt;

  const OrderActivityModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.meta,
    required this.createdBy,
    required this.createdAt,
  });

  factory OrderActivityModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderActivityModel(
      id: doc.id,
      type: data['type'],
      title: data['title'],
      description: data['description'],
      meta: data['meta'],
      createdBy: data['createdBy'],
      createdAt: data['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'title': title,
      'description': description,
      'meta': meta,
      'createdBy': createdBy,
      'createdAt': createdAt,
    };
  }
}
