// orders/models/order_line.dart
class OrderLineModel {
  final String skuId;
  final int orderedQty;
  final int labelledQty;
  final int shippedQty;

  OrderLineModel({
    required this.skuId,
    required this.orderedQty,
    required this.labelledQty,
    required this.shippedQty,
  });

  int get remainingToLabel => orderedQty - labelledQty;
  int get remainingToShip => labelledQty - shippedQty;
}
