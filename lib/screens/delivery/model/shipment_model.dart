// lib/features/orders/models/shipment.dart
class ShipmentModel {
  final String orderId;
  final String skuId;
  final int quantity;
  final DateTime date;
  final String courier;
  final String deliveryNote;

  ShipmentModel({
    required this.orderId,
    required this.skuId,
    required this.quantity,
    required this.date,
    required this.courier,
    required this.deliveryNote,
  });
}
