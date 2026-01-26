import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String clientId;
  final String clientNameSnapshot;
  final String orderNumber;

  final String itemId;
  final String itemNameSnapshot;
  final String bottleSize;
  final int packSize;

  final int orderedQuantity;
  final int producedQuantity;
  final int deliveredQuantity;
  final int remainingQuantity;

  final double ratePerBottle;
  final double totalAmount;
  final double paidAmount;
  final double dueAmount;

  final String orderStatus;        // pending / in_production / partially_delivered / completed / cancelled
  final String productionStatus;   // not_started / in_progress / completed
  final String deliveryStatus;     // pending / partial / completed

  final DateTime? expectedProductionStartDate;
  final DateTime? expectedDeliveryDate;
  final DateTime? nextDeliveryDate;

  final String? notes;
  final bool isPriority;

  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const OrderModel({
    required this.id,
    required this.clientId,
    required this.clientNameSnapshot,
    required this.orderNumber,
    required this.itemId,
    required this.itemNameSnapshot,
    required this.bottleSize,
    required this.packSize,
    required this.orderedQuantity,
    required this.producedQuantity,
    required this.deliveredQuantity,
    required this.remainingQuantity,
    required this.ratePerBottle,
    required this.totalAmount,
    required this.paidAmount,
    required this.dueAmount,
    required this.orderStatus,
    required this.productionStatus,
    required this.deliveryStatus,
    required this.expectedProductionStartDate,
    required this.expectedDeliveryDate,
    required this.nextDeliveryDate,
    required this.notes,
    required this.isPriority,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  factory OrderModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      clientId: data['clientId'],
      clientNameSnapshot: data['clientNameSnapshot'],
      orderNumber: data['orderNumber'],
      itemId: data['itemId'],
      itemNameSnapshot: data['itemNameSnapshot'],
      bottleSize: data['bottleSize'],
      packSize: data['packSize'],
      orderedQuantity: data['orderedQuantity'],
      producedQuantity: data['producedQuantity'],
      deliveredQuantity: data['deliveredQuantity'],
      remainingQuantity: data['remainingQuantity'],
      ratePerBottle: (data['ratePerBottle'] ?? 0).toDouble(),
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      paidAmount: (data['paidAmount'] ?? 0).toDouble(),
      dueAmount: (data['dueAmount'] ?? 0).toDouble(),
      orderStatus: data['orderStatus'],
      productionStatus: data['productionStatus'],
      deliveryStatus: data['deliveryStatus'],
      expectedProductionStartDate: data['expectedProductionStartDate']?.toDate(),
      expectedDeliveryDate: data['expectedDeliveryDate']?.toDate(),
      nextDeliveryDate: data['nextDeliveryDate']?.toDate(),
      notes: data['notes'],
      isPriority: data['isPriority'] ?? false,
      createdBy: data['createdBy'],
      createdAt: data['createdAt'].toDate(),
      updatedAt: data['updatedAt'].toDate(),
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'clientNameSnapshot': clientNameSnapshot,
      'orderNumber': orderNumber,
      'itemId': itemId,
      'itemNameSnapshot': itemNameSnapshot,
      'bottleSize': bottleSize,
      'packSize': packSize,
      'orderedQuantity': orderedQuantity,
      'producedQuantity': producedQuantity,
      'deliveredQuantity': deliveredQuantity,
      'remainingQuantity': remainingQuantity,
      'ratePerBottle': ratePerBottle,
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'dueAmount': dueAmount,
      'orderStatus': orderStatus,
      'productionStatus': productionStatus,
      'deliveryStatus': deliveryStatus,
      'expectedProductionStartDate': expectedProductionStartDate,
      'expectedDeliveryDate': expectedDeliveryDate,
      'nextDeliveryDate': nextDeliveryDate,
      'notes': notes,
      'isPriority': isPriority,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive,
    };
  }

  OrderModel copyWith({
    int? producedQuantity,
    int? deliveredQuantity,
    int? remainingQuantity,
    double? paidAmount,
    double? dueAmount,
    String? orderStatus,
    String? productionStatus,
    String? deliveryStatus,
    DateTime? expectedDeliveryDate,
    DateTime? nextDeliveryDate,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return OrderModel(
      id: id,
      clientId: clientId,
      clientNameSnapshot: clientNameSnapshot,
      orderNumber: orderNumber,
      itemId: itemId,
      itemNameSnapshot: itemNameSnapshot,
      bottleSize: bottleSize,
      packSize: packSize,
      orderedQuantity: orderedQuantity,
      producedQuantity: producedQuantity ?? this.producedQuantity,
      deliveredQuantity: deliveredQuantity ?? this.deliveredQuantity,
      remainingQuantity: remainingQuantity ?? this.remainingQuantity,
      ratePerBottle: ratePerBottle,
      totalAmount: totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      dueAmount: dueAmount ?? this.dueAmount,
      orderStatus: orderStatus ?? this.orderStatus,
      productionStatus: productionStatus ?? this.productionStatus,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      expectedProductionStartDate: expectedProductionStartDate,
      expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
      nextDeliveryDate: nextDeliveryDate ?? this.nextDeliveryDate,
      notes: notes,
      isPriority: isPriority,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
