// shared/models/sku.dart
class SkuModel {
  final String id;
  final String client;
  final String bottleSize;
  final String bottleShape;
  final String labelDesign;

  const SkuModel({
    required this.id,
    required this.client,
    required this.bottleSize,
    required this.bottleShape,
    required this.labelDesign,
  });
}
