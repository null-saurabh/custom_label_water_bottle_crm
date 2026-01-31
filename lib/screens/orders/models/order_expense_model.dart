import 'package:cloud_firestore/cloud_firestore.dart';

class OrderExpenseModel {
  final String id;
  final String orderId;
  final String clientId;

  final String direction;

  final String stage;
  final String category;

  final String description;

  final double amount;
  final double paidAmount;
  final double dueAmount;

  final String? vendorName;
  final String? referenceNo;

  final DateTime expenseDate;
  final String status;

  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderExpenseModel({
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

  factory OrderExpenseModel.fromDoc(DocumentSnapshot d) {
    final data = (d.data() as Map<String, dynamic>? ?? {});

    final createdAt = _dtReq(data['createdAt']);
    final updatedAt = _dtReq(data['updatedAt'], fallback: createdAt);

    return OrderExpenseModel(
      id: d.id,
      orderId: (data['orderId'] ?? '').toString(),
      clientId: (data['clientId'] ?? '').toString(),

      direction: (data['direction'] ?? 'out').toString(),
      stage: (data['stage'] ?? 'unknown').toString(),
      category: (data['category'] ?? 'unknown').toString(),

      description: (data['description'] ?? '').toString(),

      amount: _asDouble(data['amount']),
      paidAmount: _asDouble(data['paidAmount']),
      dueAmount: _asDouble(data['dueAmount']),

      vendorName: _asNullableString(data['vendorName']),
      referenceNo: _asNullableString(data['referenceNo']),

      expenseDate: _dtReq(data['expenseDate'], fallback: createdAt),

      status: (data['status'] ?? 'unknown').toString(),

      createdBy: (data['createdBy'] ?? data['createdByName'] ?? data['createdByEmail'] ?? 'system').toString(),
      createdAt: createdAt,
      updatedAt: updatedAt,
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
      'expenseDate': Timestamp.fromDate(expenseDate),
      'status': status,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
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
      id: id ?? this.id,
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
