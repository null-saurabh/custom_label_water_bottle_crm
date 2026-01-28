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

    // 🔥 Extract itemId from document path
    // Path: inventory_items/{itemId}/activities/{activityId}
    final segments = doc.reference.path.split('/');
    final itemIdFromPath =
    segments.length >= 2 ? segments[1] : '_unknown';

    return InventoryActivityModel(
      id: doc.id,
      itemId: data['itemId'] ?? itemIdFromPath, // ✅ SAFE
      stockDelta: data['stockDelta'] ?? 0,
      amount: (data['amount'] as num?)?.toDouble(),
      unitCost: (data['unitCost'] as num?)?.toDouble(),
      type: (data['type'] ?? '').toString(),
      source: (data['source'] ?? '').toString(),
      title: (data['title'] ?? '').toString(),
      description: (data['description'] ?? '').toString(),
      createdBy: (data['createdBy'] ?? 'system').toString(),
      referenceId: data['referenceId']?.toString(),
      referenceType: data['referenceType']?.toString(),
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
