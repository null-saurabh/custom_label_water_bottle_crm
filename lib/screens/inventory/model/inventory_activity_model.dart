import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryActivityModel {
  final String id;

  // 🔥 Core identity
  final String itemId;                 // Which inventory item
  final String type;                   // add / deduct / production / restock / adjustment / purchase
  final String source;                 // order / supplier / manual / cancellation

  // 🔥 Human-readable
  final String title;
  final String description;

  // 🔥 Quantities & Finance
  final int stockDelta;                // +120 / -40
  final double? amount;                // optional cost
  final double? unitCost;              // optional

  // 🔥 Cross-module links
  final String? referenceId;           // orderId / stockEntryId
  final String? referenceType;         // order_production / stock_purchase

  // 🔥 Audit
  final String createdBy;
  final DateTime createdAt;
  final bool isActive;

  InventoryActivityModel({
    required this.id,
    required this.itemId,
    required this.type,
    required this.source,
    required this.title,
    required this.description,
    required this.stockDelta,
    this.amount,
    this.unitCost,
    this.referenceId,
    this.referenceType,
    required this.createdBy,
    required this.createdAt,
    required this.isActive,
  });

  factory InventoryActivityModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return InventoryActivityModel(
      id: doc.id,
      itemId: data['itemId'],
      type: data['type'],
      source: data['source'],
      title: data['title'],
      description: data['description'],
      stockDelta: data['stockDelta'],
      amount: data['amount']?.toDouble(),
      unitCost: data['unitCost']?.toDouble(),
      referenceId: data['referenceId'],
      referenceType: data['referenceType'],
      createdBy: data['createdBy'] ?? 'system',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'type': type,
      'source': source,
      'title': title,
      'description': description,
      'stockDelta': stockDelta,
      'amount': amount,
      'unitCost': unitCost,
      'referenceId': referenceId,
      'referenceType': referenceType,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'isActive': isActive,
    };
  }
  InventoryActivityModel copyWith({
    String? id,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return InventoryActivityModel(
      id: id ?? this.id,
      itemId: itemId,
      type: type,
      source: source,
      title: title,
      description: description,
      stockDelta: stockDelta,
      amount: amount,
      unitCost: unitCost,
      referenceId: referenceId,
      referenceType: referenceType,
      createdBy: createdBy,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

}
