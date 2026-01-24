import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryActivityModel {
  final String id;

  final String title;           // "Stock Added"
  final String description;     // "120 packs received from AquaFlex"

  final int? stockDelta;        // +120 / -40
  final double? amount;         // optional (payment, purchase)

  final DateTime createdAt;

  InventoryActivityModel({
    required this.id,
    required this.title,
    required this.description,
    this.stockDelta,
    this.amount,
    required this.createdAt,
  });

  factory InventoryActivityModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return InventoryActivityModel(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      stockDelta: data['stockDelta'],
      amount: data['amount']?.toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'stockDelta': stockDelta,
      'amount': amount,
      'createdAt': createdAt,
    };
  }
}
