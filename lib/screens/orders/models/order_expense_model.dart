import 'package:cloud_firestore/cloud_firestore.dart';

class OrderExpenseModel {
  final String id;
  final String orderId;

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

  factory OrderExpenseModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;

    return OrderExpenseModel(
      id: doc.id,
      orderId: d['orderId'],
      direction: d['direction'] ?? 'out', // 🔥
      stage: d['stage'],
      category: d['category'],
      description: d['description'],
      amount: (d['amount'] ?? 0).toDouble(),
      paidAmount: (d['paidAmount'] ?? 0).toDouble(),
      dueAmount: (d['dueAmount'] ?? 0).toDouble(),
      vendorName: d['vendorName'],
      referenceNo: d['referenceNo'],
      expenseDate: d['expenseDate'].toDate(),
      status: d['status'],
      createdBy: d['createdBy'],
      createdAt: d['createdAt'].toDate(),
      updatedAt: d['updatedAt'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
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
