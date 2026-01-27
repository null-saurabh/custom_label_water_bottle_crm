import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  // ======================
  // CORE IDENTITY
  // ======================

  final String id;
  final String orderNumber;

  // ======================
  // CLIENT SNAPSHOT
  // ======================

  final String clientId;
  final String clientNameSnapshot;

  // ======================
  // BOTTLE SNAPSHOT
  // ======================

  final String itemId;
  final String itemNameSnapshot;
  final String bottleSize;
  final int packSize;

  // ======================
  // MATERIAL SNAPSHOTS 🔥
  // ======================

  final String labelItemId;
  final String labelNameSnapshot;

  final String capItemId;
  final String capNameSnapshot;

  final String? packagingItemId;
  final String? packagingNameSnapshot;

  // ======================
  // QUANTITIES
  // ======================

  final int orderedQuantity;
  final int producedQuantity;
  final int deliveredQuantity;
  final int remainingQuantity;

  // ======================
  // FINANCIALS
  // ======================

  final double ratePerBottle;
  final double totalAmount;
  final double paidAmount;
  final double dueAmount;

  // ======================
  // STATUSES
  // ======================

  final String orderStatus;
  final String productionStatus;
  final String deliveryStatus;

  // ======================
  // DATES
  // ======================

  final DateTime? expectedProductionStartDate;
  final DateTime? expectedDeliveryDate;
  final DateTime? nextDeliveryDate;

  // ======================
  // RECURRING CONFIG 🔁
  // ======================

  final bool isRecurring;
  final int? recurringIntervalDays; // 15 / 30 / 40
  final DateTime? lastRecurringGeneratedAt;
  final DateTime? nextRecurringDate;
  final String? recurringParentOrderId; // chain history

  // ======================
  // META
  // ======================

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

  // ======================
  // FIREBASE MAPPING
  // ======================

  factory OrderModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;

    return OrderModel(
      id: doc.id,
      orderNumber: d['orderNumber'],

      clientId: d['clientId'],
      clientNameSnapshot: d['clientNameSnapshot'],

      itemId: d['itemId'],
      itemNameSnapshot: d['itemNameSnapshot'],
      bottleSize: d['bottleSize'],
      packSize: d['packSize'],

      labelItemId: d['labelItemId'],
      labelNameSnapshot: d['labelNameSnapshot'],
      capItemId: d['capItemId'],
      capNameSnapshot: d['capNameSnapshot'],
      packagingItemId: d['packagingItemId'],
      packagingNameSnapshot: d['packagingNameSnapshot'],

      orderedQuantity: d['orderedQuantity'],
      producedQuantity: d['producedQuantity'],
      deliveredQuantity: d['deliveredQuantity'],
      remainingQuantity: d['remainingQuantity'],

      ratePerBottle: (d['ratePerBottle'] ?? 0).toDouble(),
      totalAmount: (d['totalAmount'] ?? 0).toDouble(),
      paidAmount: (d['paidAmount'] ?? 0).toDouble(),
      dueAmount: (d['dueAmount'] ?? 0).toDouble(),

      orderStatus: d['orderStatus'],
      productionStatus: d['productionStatus'],
      deliveryStatus: d['deliveryStatus'],

      expectedProductionStartDate:
      d['expectedProductionStartDate']?.toDate(),
      expectedDeliveryDate:
      d['expectedDeliveryDate']?.toDate(),
      nextDeliveryDate:
      d['nextDeliveryDate']?.toDate(),

      isRecurring: d['isRecurring'] ?? false,
      recurringIntervalDays: d['recurringIntervalDays'],
      lastRecurringGeneratedAt:
      d['lastRecurringGeneratedAt']?.toDate(),
      nextRecurringDate:
      d['nextRecurringDate']?.toDate(),
      recurringParentOrderId:
      d['recurringParentOrderId'],

      notes: d['notes'],
      isPriority: d['isPriority'] ?? false,

      createdBy: d['createdBy'],
      createdAt: d['createdAt'].toDate(),
      updatedAt: d['updatedAt'].toDate(),
      isActive: d['isActive'] ?? true,
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

      'expectedProductionStartDate':
      expectedProductionStartDate,
      'expectedDeliveryDate': expectedDeliveryDate,
      'nextDeliveryDate': nextDeliveryDate,

      'isRecurring': isRecurring,
      'recurringIntervalDays':
      recurringIntervalDays,
      'lastRecurringGeneratedAt':
      lastRecurringGeneratedAt,
      'nextRecurringDate': nextRecurringDate,
      'recurringParentOrderId':
      recurringParentOrderId,

      'notes': notes,
      'isPriority': isPriority,

      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive,
    };
  }

  // ======================
  // IMMUTABLE COPY
  // ======================

  OrderModel copyWith({
    String? id,

    // 🔥 ORDER META
    int? orderedQuantity,
    double? ratePerBottle,
    double? totalAmount,

    // 🔥 MATERIAL SNAPSHOTS
    String? capItemId,
    String? capNameSnapshot,
    String? packagingItemId,
    String? packagingNameSnapshot,

    // 🔥 PROGRESS
    int? producedQuantity,
    int? deliveredQuantity,
    int? remainingQuantity,

    // 🔥 FINANCE
    double? paidAmount,
    double? dueAmount,

    // 🔥 STATUS
    String? orderStatus,
    String? productionStatus,
    String? deliveryStatus,

    // 🔥 DATES
    DateTime? expectedDeliveryDate,
    DateTime? nextDeliveryDate,

    // 🔥 RECURRING
    bool? isRecurring,
    int? recurringIntervalDays,
    DateTime? lastRecurringGeneratedAt,
    DateTime? nextRecurringDate,

    // 🔥 META
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

      packagingItemId:
      packagingItemId ?? this.packagingItemId,
      packagingNameSnapshot:
      packagingNameSnapshot ??
          this.packagingNameSnapshot,

      orderedQuantity:
      orderedQuantity ?? this.orderedQuantity,
      producedQuantity:
      producedQuantity ?? this.producedQuantity,
      deliveredQuantity:
      deliveredQuantity ?? this.deliveredQuantity,
      remainingQuantity:
      remainingQuantity ?? this.remainingQuantity,

      ratePerBottle:
      ratePerBottle ?? this.ratePerBottle,
      totalAmount:
      totalAmount ?? this.totalAmount,
      paidAmount:
      paidAmount ?? this.paidAmount,
      dueAmount:
      dueAmount ?? this.dueAmount,

      orderStatus:
      orderStatus ?? this.orderStatus,
      productionStatus:
      productionStatus ?? this.productionStatus,
      deliveryStatus:
      deliveryStatus ?? this.deliveryStatus,

      expectedProductionStartDate:
      expectedProductionStartDate,
      expectedDeliveryDate:
      expectedDeliveryDate ?? this.expectedDeliveryDate,
      nextDeliveryDate:
      nextDeliveryDate ?? this.nextDeliveryDate,

      isRecurring:
      isRecurring ?? this.isRecurring,
      recurringIntervalDays:
      recurringIntervalDays ??
          this.recurringIntervalDays,
      lastRecurringGeneratedAt:
      lastRecurringGeneratedAt ??
          this.lastRecurringGeneratedAt,
      nextRecurringDate:
      nextRecurringDate ??
          this.nextRecurringDate,
      recurringParentOrderId:
      recurringParentOrderId,

      notes: notes ?? this.notes,
      isPriority:
      isPriority ?? this.isPriority,

      createdBy: createdBy,
      createdAt:
      createdAt ?? this.createdAt,
      updatedAt:
      updatedAt ?? this.updatedAt,
      isActive:
      isActive ?? this.isActive,
    );
  }


  // OrderModel copyWith({
  //   String? id,
  //
  //   int? producedQuantity,
  //   int? deliveredQuantity,
  //   int? remainingQuantity,
  //
  //   double? paidAmount,
  //   double? dueAmount,
  //
  //   String? orderStatus,
  //   String? productionStatus,
  //   String? deliveryStatus,
  //
  //   DateTime? expectedDeliveryDate,
  //   DateTime? nextDeliveryDate,
  //
  //   bool? isRecurring,
  //   int? recurringIntervalDays,
  //   DateTime? lastRecurringGeneratedAt,
  //   DateTime? nextRecurringDate,
  //
  //   DateTime? createdAt,
  //   DateTime? updatedAt,
  //   bool? isActive,
  // }) {
  //   return OrderModel(
  //     id: id ?? this.id,
  //     orderNumber: orderNumber,
  //
  //     clientId: clientId,
  //     clientNameSnapshot: clientNameSnapshot,
  //
  //     itemId: itemId,
  //     itemNameSnapshot: itemNameSnapshot,
  //     bottleSize: bottleSize,
  //     packSize: packSize,
  //
  //     labelItemId: labelItemId,
  //     labelNameSnapshot: labelNameSnapshot,
  //     capItemId: capItemId,
  //     capNameSnapshot: capNameSnapshot,
  //     packagingItemId: packagingItemId,
  //     packagingNameSnapshot: packagingNameSnapshot,
  //
  //     orderedQuantity: orderedQuantity,
  //     producedQuantity:
  //     producedQuantity ?? this.producedQuantity,
  //     deliveredQuantity:
  //     deliveredQuantity ?? this.deliveredQuantity,
  //     remainingQuantity:
  //     remainingQuantity ?? this.remainingQuantity,
  //
  //     ratePerBottle: ratePerBottle,
  //     totalAmount: totalAmount,
  //     paidAmount: paidAmount ?? this.paidAmount,
  //     dueAmount: dueAmount ?? this.dueAmount,
  //
  //     orderStatus: orderStatus ?? this.orderStatus,
  //     productionStatus:
  //     productionStatus ?? this.productionStatus,
  //     deliveryStatus:
  //     deliveryStatus ?? this.deliveryStatus,
  //
  //     expectedProductionStartDate:
  //     expectedProductionStartDate,
  //     expectedDeliveryDate:
  //     expectedDeliveryDate ?? this.expectedDeliveryDate,
  //     nextDeliveryDate:
  //     nextDeliveryDate ?? this.nextDeliveryDate,
  //
  //     isRecurring: isRecurring ?? this.isRecurring,
  //     recurringIntervalDays:
  //     recurringIntervalDays ??
  //         this.recurringIntervalDays,
  //     lastRecurringGeneratedAt:
  //     lastRecurringGeneratedAt ??
  //         this.lastRecurringGeneratedAt,
  //     nextRecurringDate:
  //     nextRecurringDate ??
  //         this.nextRecurringDate,
  //     recurringParentOrderId:
  //     recurringParentOrderId,
  //
  //     notes: notes,
  //     isPriority: isPriority,
  //
  //     createdBy: createdBy,
  //     createdAt: createdAt  ?? this.createdAt,
  //     updatedAt: updatedAt ?? this.updatedAt,
  //     isActive: isActive ?? this.isActive,
  //   );
  // }

  // ======================
  // 🔁 RECURRING CLONE HELPER
  // ======================

  OrderModel cloneForNextRecurring({
    required String newOrderNumber,
  }) {
    final now = DateTime.now();
    final nextDate =
    now.add(Duration(days: recurringIntervalDays!));

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
      recurringParentOrderId:
      recurringParentOrderId ?? id,

      notes: notes,
      isPriority: isPriority,

      createdBy: createdBy,
      createdAt: now,
      updatedAt: now,
      isActive: true,
    );
  }
}
