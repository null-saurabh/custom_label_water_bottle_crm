import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/core/utils/model_helpers.dart';


class LabelConfig {
  final String itemId;
  final double widthMm;
  final double heightMm;
  final String material;        // Paper / Plastic
  final bool isClientSpecific;  // true for custom branding

  LabelConfig({
    required this.itemId,
    required this.widthMm,
    required this.heightMm,
    required this.material,
    required this.isClientSpecific,
  });

  factory LabelConfig.fromMap(Map<String, dynamic> d) {
    return LabelConfig(
      itemId: (d['itemId'] ?? '').toString(),
      widthMm: asDouble(d['widthMm']),
      heightMm: asDouble(d['heightMm']),
      material: (d['material'] ?? '').toString(),
      isClientSpecific: d['isClientSpecific'] ?? false,
    );
  }

  factory LabelConfig.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return LabelConfig.fromMap({
      ...data,
      'itemId': data['itemId'] ?? doc.id,
    });
  }


  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'widthMm': widthMm,
      'heightMm': heightMm,
      'material': material,
      'isClientSpecific': isClientSpecific,
    };
  }

  LabelConfig copyWith({
    String? itemId,
    double? widthMm,
    double? heightMm,
    String? material,
    bool? isClientSpecific,
  }) {
    return LabelConfig(
      itemId: itemId ?? this.itemId,
      widthMm: widthMm ?? this.widthMm,
      heightMm: heightMm ?? this.heightMm,
      material: material ?? this.material,
      isClientSpecific: isClientSpecific ?? this.isClientSpecific,
    );
  }
}
