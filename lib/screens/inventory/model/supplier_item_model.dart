import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/core/utils/model_helpers.dart';

class SupplierItemModel {
  final String id;

  final String supplierId;
  final String itemId;

  final String supplierSku;
  final double costPerUnit;

  final DateTime createdAt;

  SupplierItemModel({
    required this.id,
    required this.supplierId,
    required this.itemId,
    required this.supplierSku,
    required this.costPerUnit,
    required this.createdAt,
  });

  factory SupplierItemModel.fromMap(Map<String, dynamic> d, {String id = ''}) {
    return SupplierItemModel(
      id: (d['id'] ?? id).toString(),
      supplierId: (d['supplierId'] ?? '').toString(),
      itemId: (d['itemId'] ?? '').toString(),
      supplierSku: (d['supplierSku'] ?? '').toString(),
      costPerUnit: asDouble(d['costPerUnit']),
      createdAt: asDateTime(d['createdAt']),
    );
  }

  factory SupplierItemModel.fromDoc(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? {};

    return SupplierItemModel(
      id: doc.id,
      itemId: (data['itemId'] ?? '').toString(),
      supplierId: (data['supplierId'] ?? '').toString(),
      supplierSku: (data['supplierSku'] ?? '').toString(), // ✅ FIX
      costPerUnit: asDouble(data['costPerUnit']),
      createdAt: asDateTime(data['createdAt']), // ✅ null-safe
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'id': id, // optional
      'supplierId': supplierId,
      'itemId': itemId,
      'supplierSku': supplierSku,
      'costPerUnit': costPerUnit,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  SupplierItemModel copyWith({
    String? id,
    String? supplierId,
    String? itemId,
    String? supplierSku,
    double? costPerUnit,
    DateTime? createdAt,
  }) {
    return SupplierItemModel(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      itemId: itemId ?? this.itemId,
      supplierSku: supplierSku ?? this.supplierSku,
      costPerUnit: costPerUnit ?? this.costPerUnit,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
