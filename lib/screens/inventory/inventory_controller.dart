// lib/features/inventory/inventory_controller.dart
import 'package:get/get.dart';

class InventoryController extends GetxController {
  final labelInventory = <LabelInventory>[].obs;
  final bottleInventory = <BottleInventory>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadInventory();
  }

  void loadInventory() {
    labelInventory.assignAll([
      LabelInventory(
        skuId: 'A-500-A1',
        available: 1200,
        weeklyDemand: 1800,
        monthlyDemand: 6200,
      ),
    ]);

    bottleInventory.assignAll([
      BottleInventory(
        size: '500ml',
        shape: 'Round',
        available: 3000,
        reserved: 1200,
        minimum: 1500,
      ),
    ]);
  }

  bool isLabelShortage(LabelInventory inv) {
    return inv.available < inv.weeklyDemand;
  }

  bool isBottleBelowMinimum(BottleInventory inv) {
    return inv.available < inv.minimum;
  }
}






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
class BottleInventory {
  final String size;
  final String shape;
  final int available;
  final int reserved;
  final int minimum;

  BottleInventory({
    required this.size,
    required this.shape,
    required this.available,
    required this.reserved,
    required this.minimum,
  });
}