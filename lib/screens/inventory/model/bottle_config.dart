import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/core/utils/model_helpers.dart';

class BottleConfig {
  final String itemId;

  final int sizeMl;      // 200 / 500 / 1000
  final int packSize;    // derived: 40 / 24 / 12
  final String shape;    // Round / Square / Custom
  final String neckType; // 28mm / 30mm

  BottleConfig({
    required this.itemId,
    required this.sizeMl,
    required this.shape,
    required this.neckType,
  }) : packSize = _resolvePackSize(sizeMl);

  static int _resolvePackSize(int sizeMl) {
    switch (sizeMl) {
      case 200:
        return 40;
      case 500:
        return 24;
      case 1000:
        return 12;
      default:
        throw Exception('Unsupported bottle size: $sizeMl');
    }
  }

  factory BottleConfig.fromMap(Map<String, dynamic> d) {
    return BottleConfig(
      itemId: (d['itemId'] ?? '').toString(),
      sizeMl: asInt(d['sizeMl']),
      shape: (d['shape'] ?? '').toString(),
      neckType: (d['neckType'] ?? '').toString(),
    );
  }

  factory BottleConfig.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return BottleConfig.fromMap({
      ...data,
      'itemId': data['itemId'] ?? doc.id,
    });
  }


  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'sizeMl': sizeMl,
      'packSize': packSize,
      'shape': shape,
      'neckType': neckType,
    };
  }

  BottleConfig copyWith({
    String? itemId,
    int? sizeMl,
    String? shape,
    String? neckType,
  }) {
    return BottleConfig(
      itemId: itemId ?? this.itemId,
      sizeMl: sizeMl ?? this.sizeMl,
      shape: shape ?? this.shape,
      neckType: neckType ?? this.neckType,
    );
  }
}
