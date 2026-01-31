import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/core/utils/model_helpers.dart';

enum InventoryCategory {
  bottle,
  cap,
  label,
  packaging,
}

class InventoryItemModel {
  final String id;

  /// Classification
  final InventoryCategory category;

  /// Display
  final String name;
  final String? description;

  /// Stock
  final int stock;
  final int reorderLevel;

  /// Status
  final bool isActive;

  /// Metadata
  final DateTime createdAt;
  final DateTime updatedAt;

  InventoryItemModel({
    required this.id,
    required this.category,
    required this.name,
    this.description,
    required this.stock,
    required this.reorderLevel,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InventoryItemModel.fromMap(Map<String, dynamic> d, {String id = ''}) {
    return InventoryItemModel(
      id: (d['id'] ?? id).toString(),
      category: enumFromName(
        InventoryCategory.values,
        d['category'],
        InventoryCategory.bottle,
      ),
      name: (d['name'] ?? '').toString(),
      description: d['description']?.toString(),
      stock: asInt(d['stock']),
      reorderLevel: asInt(d['reorderLevel']),
      isActive: (d['isActive'] as bool?) ?? true,
      createdAt: asDateTime(d['createdAt']),
      updatedAt: asDateTime(d['updatedAt']),
    );
  }
  factory InventoryItemModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return InventoryItemModel(
      id: doc.id,
      category: InventoryCategory.values.byName(data['category']),
      name: data['name'],
      description: data['description'],
      stock: asInt(data['stock']),
      reorderLevel: asInt(data['reorderLevel']),
      isActive: data['isActive'] ?? true,
      createdAt: asDateTime(data['createdAt']),
      updatedAt: asDateTime(data['updatedAt']),

    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id, // optional but useful
      'category': category.name,
      'name': name,
      'description': description,
      'stock': stock,
      'reorderLevel': reorderLevel,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  InventoryItemModel copyWith({
    String? id,
    InventoryCategory? category,
    String? name,
    String? description,
    int? stock,
    int? reorderLevel,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InventoryItemModel(
      id: id ?? this.id,
      category: category ?? this.category,
      name: name ?? this.name,
      description: description ?? this.description,
      stock: stock ?? this.stock,
      reorderLevel: reorderLevel ?? this.reorderLevel,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isLowStock => stock <= reorderLevel;
}
