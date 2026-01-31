import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String orderNumber;

  final String clientId;
  final String clientNameSnapshot;

  final String itemId;
  final String itemNameSnapshot;
  final String bottleSize;
  final int packSize;

  final String labelItemId;
  final String labelNameSnapshot;

  final String capItemId;
  final String capNameSnapshot;

  final String? packagingItemId;
  final String? packagingNameSnapshot;

  final int orderedQuantity;
  final int producedQuantity;
  final int deliveredQuantity;
  final int remainingQuantity;

  final double ratePerBottle;
  final double totalAmount;
  final double paidAmount;
  final double dueAmount;

  final String orderStatus;
  final String productionStatus;
  final String deliveryStatus;

  final DateTime? expectedProductionStartDate;
  final DateTime? expectedDeliveryDate;
  final DateTime? nextDeliveryDate;

  final bool isRecurring;
  final int? recurringIntervalDays;
  final DateTime? lastRecurringGeneratedAt;
  final DateTime? nextRecurringDate;
  final String? recurringParentOrderId;

  final String? notes;
  final bool isPriority;

  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.clientId,
    required this.clientNameSnapshot,
    required this.itemId,
    required this.itemNameSnapshot,
    required this.bottleSize,
    required this.packSize,
    required this.labelItemId,
    required this.labelNameSnapshot,
    required this.capItemId,
    required this.capNameSnapshot,
    required this.packagingItemId,
    required this.packagingNameSnapshot,
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
    required this.isRecurring,
    required this.recurringIntervalDays,
    required this.lastRecurringGeneratedAt,
    required this.nextRecurringDate,
    required this.recurringParentOrderId,
    required this.notes,
    required this.isPriority,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  // ---------- helpers ----------
  static DateTime? _dtOpt(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is DateTime) return v;
    if (v is String) return DateTime.tryParse(v);
    if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
    return null;
  }

  static DateTime _dtReq(dynamic v, {DateTime? fallback}) {
    return _dtOpt(v) ?? fallback ?? DateTime.now();
  }

  static int _asInt(dynamic v, {int fallback = 0}) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? fallback;
  }

  static double _asDouble(dynamic v, {double fallback = 0}) {
    if (v is double) return v;
    if (v is num) return v.toDouble();
    return double.tryParse(v?.toString() ?? '') ?? fallback;
  }

  static String? _asNullableString(dynamic v) {
    if (v == null) return null;
    final s = v.toString();
    return s.isEmpty ? null : s;
  }

  factory OrderModel.fromDoc(DocumentSnapshot doc) {
    final d = (doc.data() as Map<String, dynamic>? ?? {});

    final createdAt = _dtReq(d['createdAt']);
    final updatedAt = _dtReq(d['updatedAt'], fallback: createdAt);

    return OrderModel(
      id: doc.id,
      orderNumber: (d['orderNumber'] ?? '').toString(),

      clientId: (d['clientId'] ?? '').toString(),
      clientNameSnapshot: (d['clientNameSnapshot'] ?? '').toString(),

      itemId: (d['itemId'] ?? '').toString(),
      itemNameSnapshot: (d['itemNameSnapshot'] ?? '').toString(),
      bottleSize: (d['bottleSize'] ?? '').toString(),
      packSize: _asInt(d['packSize']),

      labelItemId: (d['labelItemId'] ?? '').toString(),
      labelNameSnapshot: (d['labelNameSnapshot'] ?? '').toString(),

      capItemId: (d['capItemId'] ?? '').toString(),
      capNameSnapshot: (d['capNameSnapshot'] ?? '').toString(),

      packagingItemId: _asNullableString(d['packagingItemId']),
      packagingNameSnapshot: _asNullableString(d['packagingNameSnapshot']),

      orderedQuantity: _asInt(d['orderedQuantity']),
      producedQuantity: _asInt(d['producedQuantity']),
      deliveredQuantity: _asInt(d['deliveredQuantity']),
      remainingQuantity: _asInt(d['remainingQuantity']),

      ratePerBottle: _asDouble(d['ratePerBottle']),
      totalAmount: _asDouble(d['totalAmount']),
      paidAmount: _asDouble(d['paidAmount']),
      dueAmount: _asDouble(d['dueAmount']),

      orderStatus: (d['orderStatus'] ?? 'pending').toString(),
      productionStatus: (d['productionStatus'] ?? 'not_started').toString(),
      deliveryStatus: (d['deliveryStatus'] ?? 'pending').toString(),

      expectedProductionStartDate: _dtOpt(d['expectedProductionStartDate']),
      expectedDeliveryDate: _dtOpt(d['expectedDeliveryDate']),
      nextDeliveryDate: _dtOpt(d['nextDeliveryDate']),

      isRecurring: (d['isRecurring'] ?? false) == true,
      recurringIntervalDays: d['recurringIntervalDays'] == null
          ? null
          : _asInt(d['recurringIntervalDays']),
      lastRecurringGeneratedAt: _dtOpt(d['lastRecurringGeneratedAt']),
      nextRecurringDate: _dtOpt(d['nextRecurringDate']),
      recurringParentOrderId: _asNullableString(d['recurringParentOrderId']),

      notes: _asNullableString(d['notes']),
      isPriority: (d['isPriority'] ?? false) == true,

      createdBy: (d['createdBy'] ?? d['createdByName'] ?? d['createdByEmail'] ?? 'system').toString(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      isActive: (d['isActive'] ?? true) == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderNumber': orderNumber,

      'clientId': clientId,
      'clientNameSnapshot': clientNameSnapshot,

      'itemId': itemId,
      'itemNameSnapshot': itemNameSnapshot,
      'bottleSize': bottleSize,
      'packSize': packSize,

      'labelItemId': labelItemId,
      'labelNameSnapshot': labelNameSnapshot,
      'capItemId': capItemId,
      'capNameSnapshot': capNameSnapshot,
      'packagingItemId': packagingItemId,
      'packagingNameSnapshot': packagingNameSnapshot,

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

      'expectedProductionStartDate': expectedProductionStartDate == null
          ? null
          : Timestamp.fromDate(expectedProductionStartDate!),
      'expectedDeliveryDate': expectedDeliveryDate == null
          ? null
          : Timestamp.fromDate(expectedDeliveryDate!),
      'nextDeliveryDate': nextDeliveryDate == null
          ? null
          : Timestamp.fromDate(nextDeliveryDate!),

      'isRecurring': isRecurring,
      'recurringIntervalDays': recurringIntervalDays,
      'lastRecurringGeneratedAt': lastRecurringGeneratedAt == null
          ? null
          : Timestamp.fromDate(lastRecurringGeneratedAt!),
      'nextRecurringDate': nextRecurringDate == null
          ? null
          : Timestamp.fromDate(nextRecurringDate!),
      'recurringParentOrderId': recurringParentOrderId,

      'notes': notes,
      'isPriority': isPriority,

      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
    };
  }

  OrderModel copyWith({
    String? id,

    int? orderedQuantity,
    double? ratePerBottle,
    double? totalAmount,

    String? capItemId,
    String? capNameSnapshot,
    String? packagingItemId,
    String? packagingNameSnapshot,

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

    bool? isRecurring,
    int? recurringIntervalDays,
    DateTime? lastRecurringGeneratedAt,
    DateTime? nextRecurringDate,

    String? notes,
    bool? isPriority,

    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber,

      clientId: clientId,
      clientNameSnapshot: clientNameSnapshot,

      itemId: itemId,
      itemNameSnapshot: itemNameSnapshot,
      bottleSize: bottleSize,
      packSize: packSize,

      labelItemId: labelItemId,
      labelNameSnapshot: labelNameSnapshot,

      capItemId: capItemId ?? this.capItemId,
      capNameSnapshot: capNameSnapshot ?? this.capNameSnapshot,

      packagingItemId: packagingItemId ?? this.packagingItemId,
      packagingNameSnapshot: packagingNameSnapshot ?? this.packagingNameSnapshot,

      orderedQuantity: orderedQuantity ?? this.orderedQuantity,
      producedQuantity: producedQuantity ?? this.producedQuantity,
      deliveredQuantity: deliveredQuantity ?? this.deliveredQuantity,
      remainingQuantity: remainingQuantity ?? this.remainingQuantity,

      ratePerBottle: ratePerBottle ?? this.ratePerBottle,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      dueAmount: dueAmount ?? this.dueAmount,

      orderStatus: orderStatus ?? this.orderStatus,
      productionStatus: productionStatus ?? this.productionStatus,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,

      expectedProductionStartDate: expectedProductionStartDate,
      expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
      nextDeliveryDate: nextDeliveryDate ?? this.nextDeliveryDate,

      isRecurring: isRecurring ?? this.isRecurring,
      recurringIntervalDays: recurringIntervalDays ?? this.recurringIntervalDays,
      lastRecurringGeneratedAt: lastRecurringGeneratedAt ?? this.lastRecurringGeneratedAt,
      nextRecurringDate: nextRecurringDate ?? this.nextRecurringDate,
      recurringParentOrderId: recurringParentOrderId,

      notes: notes ?? this.notes,
      isPriority: isPriority ?? this.isPriority,

      createdBy: createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  OrderModel cloneForNextRecurring({
    required String newOrderNumber,
  }) {
    final now = DateTime.now();
    final nextDate = now.add(Duration(days: recurringIntervalDays!));

    return OrderModel(
      id: '',
      orderNumber: newOrderNumber,

      clientId: clientId,
      clientNameSnapshot: clientNameSnapshot,

      itemId: itemId,
      itemNameSnapshot: itemNameSnapshot,
      bottleSize: bottleSize,
      packSize: packSize,

      labelItemId: labelItemId,
      labelNameSnapshot: labelNameSnapshot,
      capItemId: capItemId,
      capNameSnapshot: capNameSnapshot,
      packagingItemId: packagingItemId,
      packagingNameSnapshot: packagingNameSnapshot,

      orderedQuantity: orderedQuantity,
      producedQuantity: 0,
      deliveredQuantity: 0,
      remainingQuantity: orderedQuantity,

      ratePerBottle: ratePerBottle,
      totalAmount: totalAmount,
      paidAmount: 0,
      dueAmount: totalAmount,

      orderStatus: 'pending',
      productionStatus: 'not_started',
      deliveryStatus: 'pending',

      expectedProductionStartDate: now,
      expectedDeliveryDate: nextDate,
      nextDeliveryDate: nextDate,

      isRecurring: true,
      recurringIntervalDays: recurringIntervalDays,
      lastRecurringGeneratedAt: now,
      nextRecurringDate: nextDate,
      recurringParentOrderId: recurringParentOrderId ?? id,

      notes: notes,
      isPriority: isPriority,

      createdBy: createdBy,
      createdAt: now,
      updatedAt: now,
      isActive: true,
    );
  }
}
