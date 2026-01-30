import 'package:cloud_firestore/cloud_firestore.dart';

class OrderExpenseModel {
  final String id;
  final String orderId;
  final String clientId;

  final String direction;

  final String stage;       // dispatch / production / delivery / misc
  final String category;    // transport / plant_fee / labor / fuel / other

  final String description;

  final double amount;
  final double paidAmount;
  final double dueAmount;

  final String? vendorName;
  final String? referenceNo;

  final DateTime expenseDate;
  final String status;      // pending / partial / paid

  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderExpenseModel( {
    required this.id,
    required this.orderId,
    required this.clientId,
  required this.direction,
    required this.stage,
    required this.category,
    required this.description,
    required this.amount,
    required this.paidAmount,
    required this.dueAmount,
    required this.vendorName,
    required this.referenceNo,
    required this.expenseDate,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  // factory OrderExpenseModel.fromDoc(DocumentSnapshot doc) {
  //   final d = doc.data() as Map<String, dynamic>;
  //
  //   return OrderExpenseModel(
  //     id: doc.id,
  //     orderId: d['orderId'],
  //     clientId: d['clientId'],
  //     direction: d['direction'] ?? 'out', // 🔥
  //     stage: d['stage'],
  //     category: d['category'],
  //     description: d['description'],
  //     amount: (d['amount'] ?? 0).toDouble(),
  //     paidAmount: (d['paidAmount'] ?? 0).toDouble(),
  //     dueAmount: (d['dueAmount'] ?? 0).toDouble(),
  //     vendorName: d['vendorName'],
  //     referenceNo: d['referenceNo'],
  //     expenseDate: d['expenseDate'].toDate(),
  //     status: d['status'],
  //     createdBy: d['createdBy'],
  //     createdAt: d['createdAt'].toDate(),
  //     updatedAt: d['updatedAt'].toDate(),
  //   );
  // }
  factory OrderExpenseModel.fromDoc(DocumentSnapshot d) {
    final data = d.data() as Map<String, dynamic>? ?? {};

    return OrderExpenseModel(
      id: d.id,
      orderId: data['orderId'] ?? '',
      clientId: data['clientId'] ?? '',

      direction: data['direction'] ?? 'out',

      stage: data['stage'] ?? 'unknown',
      category: data['category'] ?? 'unknown',

      description: data['description'] ?? '',

      amount: (data['amount'] ?? 0).toDouble(),
      paidAmount: (data['paidAmount'] ?? 0).toDouble(),
      dueAmount: (data['dueAmount'] ?? 0).toDouble(),

      vendorName: data['vendorName'], // nullable ✔
      referenceNo: data['referenceNo'], // nullable ✔

      expenseDate: (data['expenseDate'] as Timestamp?)?.toDate()
          ?? DateTime.now(),

      status: data['status'] ?? 'unknown',

      createdBy: data['createdBy'] ?? 'system',

      createdAt: (data['createdAt'] as Timestamp?)?.toDate()
          ?? DateTime.now(),

      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate()
          ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'clientId': clientId,
      'stage': stage,
      'direction': direction,
      'category': category,
      'description': description,
      'amount': amount,
      'paidAmount': paidAmount,
      'dueAmount': dueAmount,
      'vendorName': vendorName,
      'referenceNo': referenceNo,
      'expenseDate': expenseDate,
      'status': status,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  OrderExpenseModel copyWith({

    String? id,
    double? paidAmount,
    double? dueAmount,
    String? status,
    DateTime? updatedAt,
  }) {
    return OrderExpenseModel(
      id: id?? this.id,
      orderId: orderId,
      clientId: clientId,
      direction: direction,
      stage: stage,
      category: category,
      description: description,
      amount: amount,
      paidAmount: paidAmount ?? this.paidAmount,
      dueAmount: dueAmount ?? this.dueAmount,
      vendorName: vendorName,
      referenceNo: referenceNo,
      expenseDate: expenseDate,
      status: status ?? this.status,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
