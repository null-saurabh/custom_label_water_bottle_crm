// inventory/models/label_inventory.dart
class LabelInventory {
  final String skuId;
  final int available;
  final int weeklyDemand;
  final int monthlyDemand;

  LabelInventory({
    required this.skuId,
    required this.available,
    required this.weeklyDemand,
    required this.monthlyDemand,
  });
}
