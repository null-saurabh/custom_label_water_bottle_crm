import 'package:clwb_crm/core/utils/pack_type.dart';

class ClientProductSKU {
  final String skuId;
  final PackType packType; // 500ml(24) / 1L(12)
  final String bottleDesignId;
  final String labelDesignId;
  final bool isActive;

  const ClientProductSKU({
    required this.skuId,
    required this.packType,
    required this.bottleDesignId,
    required this.labelDesignId,
    required this.isActive,
  });

  /// For Firestore writes
  Map<String, dynamic> toMap() => {
    'skuId': skuId,
    'packType': packType.name,
    'bottleDesignId': bottleDesignId,
    'labelDesignId': labelDesignId,
    'isActive': isActive,
  };

  /// For Firestore reads
  factory ClientProductSKU.fromMap(Map<String, dynamic> map) {
    final rawPackType = map['packType']?.toString();

    PackType resolvedPackType = PackType.values.firstWhere(
          (e) => e.name == rawPackType,
      orElse: () => PackType.values.first, // safe fallback
    );

    return ClientProductSKU(
      skuId: (map['skuId'] ?? '') as String,
      packType: resolvedPackType,
      bottleDesignId: (map['bottleDesignId'] ?? '') as String,
      labelDesignId: (map['labelDesignId'] ?? '') as String,
      isActive: (map['isActive'] ?? false) as bool,
    );
  }
}
