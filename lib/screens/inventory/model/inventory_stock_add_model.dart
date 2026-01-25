import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/core/utils/model_helpers.dart';

enum DeliveryStatus {
  pending,
  partial,
  received,
}

class InventoryStockAddModel {
  final String id;

  /// Relations
  final String itemId; // SKU
  final String supplierId;

  /// Quantity
  final int orderedQuantity; // total ordered
  final int receivedQuantity; // actually received

  /// Pricing (IMMUTABLE FOR THIS TRANSACTION)
  final double ratePerUnit; // cost per pack / unit
  final double totalAmount; // orderedQuantity * ratePerUnit

  /// Payments
  final double paidAmount;
  final double dueAmount;

  /// Delivery
  final DeliveryStatus status;
  final DateTime? deliveryDate;
  final DateTime? dueDate;

  /// Metadata
  final DateTime createdAt;
  final DateTime updatedAt;

  InventoryStockAddModel({
    required this.id,
    required this.itemId,
    required this.supplierId,
    required this.orderedQuantity,
    required this.receivedQuantity,
    required this.ratePerUnit,
    required this.totalAmount,
    required this.paidAmount,
    required this.dueAmount,
    required this.status,
    this.deliveryDate,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InventoryStockAddModel.fromMap(
      Map<String, dynamic> d,
      ) {
    return InventoryStockAddModel(
      id: d['id'],
      itemId: d['itemId'],
      supplierId: d['supplierId'],
      orderedQuantity: d['orderedQuantity'] ?? 0,
      receivedQuantity: d['receivedQuantity'] ?? 0,

      ratePerUnit: (d['ratePerUnit'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (d['totalAmount'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (d['paidAmount'] as num?)?.toDouble() ?? 0.0,
      dueAmount: (d['dueAmount'] as num?)?.toDouble() ?? 0.0,

      status: d['status'],
      deliveryDate: d['deliveryDate']?.toDate(),
      dueDate: d['dueDate']?.toDate(),
      createdAt: d['createdAt'].toDate(),
      updatedAt: d['updatedAt'].toDate(),
    );
  }


  // factory InventoryStockAddModel.fromMap(Map<String, dynamic> d, {String id = ''}) {
  //   final orderedQty = asInt(d['orderedQuantity']);
  //   final rate = asDouble(d['ratePerUnit']);
  //
  //   // if totalAmount missing, compute safely
  //   final total = d.containsKey('totalAmount')
  //       ? asDouble(d['totalAmount'])
  //       : (orderedQty * rate);
  //
  //   return InventoryStockAddModel(
  //     id: (d['id'] ?? id).toString(),
  //     itemId: (d['itemId'] ?? '').toString(),
  //     supplierId: (d['supplierId'] ?? '').toString(),
  //     orderedQuantity: orderedQty,
  //     receivedQuantity: asInt(d['receivedQuantity']),
  //     ratePerUnit: rate,
  //     totalAmount: total,
  //     paidAmount: asDouble(d['paidAmount']),
  //     dueAmount: asDouble(d['dueAmount']),
  //     status: enumFromName(DeliveryStatus.values, d['status'], DeliveryStatus.pending),
  //     deliveryDate: asNullableDateTime(d['deliveryDate']),
  //     dueDate: asNullableDateTime(d['dueDate']),
  //     createdAt: asDateTime(d['createdAt']),
  //     updatedAt: asDateTime(d['updatedAt']),
  //   );
  // }

  factory InventoryStockAddModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return InventoryStockAddModel(
      id: doc.id,
      itemId: data['itemId'],
      supplierId: data['supplierId'],
      orderedQuantity: asInt(data['orderedQuantity']),
      receivedQuantity: asInt(data['receivedQuantity']),
      ratePerUnit: (data['ratePerUnit'] as num).toDouble(),
      totalAmount: (data['totalAmount'] as num).toDouble(),
      paidAmount: (data['paidAmount'] as num).toDouble(),
      dueAmount: (data['dueAmount'] as num).toDouble(),
      status: DeliveryStatus.values.byName(data['status']),
      deliveryDate: data['deliveryDate'] != null
          ? (data['deliveryDate'] as Timestamp).toDate()
          : null,
      dueDate: data['dueDate'] != null
          ? (data['dueDate'] as Timestamp).toDate()
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      // optional: keep id inside doc too, handy for exports
      'id': id,

      'itemId': itemId,
      'supplierId': supplierId,

      'orderedQuantity': orderedQuantity,
      'receivedQuantity': receivedQuantity,

      'ratePerUnit': ratePerUnit,
      'totalAmount': totalAmount,

      'paidAmount': paidAmount,
      'dueAmount': dueAmount,

      'status': status.name,
      'deliveryDate': deliveryDate == null ? null : Timestamp.fromDate(deliveryDate!),
      'dueDate': dueDate == null ? null : Timestamp.fromDate(dueDate!),

      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  InventoryStockAddModel copyWith({
    String? id,
    String? itemId,
    String? supplierId,
    int? orderedQuantity,
    int? receivedQuantity,
    double? ratePerUnit,
    double? totalAmount,
    double? paidAmount,
    double? dueAmount,
    DeliveryStatus? status,
    DateTime? deliveryDate,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InventoryStockAddModel(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      supplierId: supplierId ?? this.supplierId,
      orderedQuantity: orderedQuantity ?? this.orderedQuantity,
      receivedQuantity: receivedQuantity ?? this.receivedQuantity,
      ratePerUnit: ratePerUnit ?? this.ratePerUnit,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      dueAmount: dueAmount ?? this.dueAmount,
      status: status ?? this.status,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Optional convenience for your UI
  double get pendingAmount => (totalAmount - paidAmount).clamp(0.0, double.infinity);

  bool get isFullyReceived => status == DeliveryStatus.received && receivedQuantity >= orderedQuantity;

  bool get hasDue => dueAmount > 0.0;
}