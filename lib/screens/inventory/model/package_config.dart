import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/core/utils/model_helpers.dart';

class PackagingConfig {
  final String itemId;

  final String type;   // Carton / Shrink Wrap
  final int capacity;  // bottles per package

  PackagingConfig({
    required this.itemId,
    required this.type,
    required this.capacity,
  });

  factory PackagingConfig.fromMap(Map<String, dynamic> d) {
    return PackagingConfig(
      itemId: (d['itemId'] ?? '').toString(),
      type: (d['type'] ?? '').toString(),
      capacity: asInt(d['capacity']),
    );
  }

  factory PackagingConfig.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return PackagingConfig.fromMap({
      ...data,
      'itemId': data['itemId'] ?? doc.id,
    });
  }


  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'type': type,
      'capacity': capacity,
    };
  }

  PackagingConfig copyWith({
    String? itemId,
    String? type,
    int? capacity,
  }) {
    return PackagingConfig(
      itemId: itemId ?? this.itemId,
      type: type ?? this.type,
      capacity: capacity ?? this.capacity,
    );
  }
}
