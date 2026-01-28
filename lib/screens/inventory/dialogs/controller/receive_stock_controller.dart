import 'package:clwb_crm/screens/inventory/repositories/inventory_stocks_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:clwb_crm/screens/inventory/model/inventory_stock_add_model.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_item_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_activity_repo.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_activity_model.dart';

class ReceiveStockController extends GetxController {
  final InventoryStockAddModel entry;
  ReceiveStockController(this.entry);

  final isSaving = false.obs;

  late final TextEditingController receivedCtrl;
  late final TextEditingController nextDeliveryCtrl;

  int get receivedToday =>
      int.tryParse(receivedCtrl.text.trim()) ?? 0;

  int get newReceivedQuantity =>
      entry.receivedQuantity + receivedToday;

  DateTime? get nextDeliveryDate {
    final t = nextDeliveryCtrl.text.trim();
    if (t.isEmpty) return null;
    try {
      // expects yyyy-mm-dd
      final parts = t.split('-');
      if (parts.length != 3) return null;
      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    } catch (_) {
      return null;
    }
  }

  DeliveryStatus get newStatus {
    final r = newReceivedQuantity;
    if (r <= 0) return DeliveryStatus.pending;
    if (r < entry.orderedQuantity) return DeliveryStatus.partial;
    return DeliveryStatus.received;
  }

  final _stockRepo = InventoryStockRepository();
  final _itemRepo = InventoryItemRepository();
  final _activityRepo = InventoryActivityRepository();

  @override
  void onInit() {
    super.onInit();
    receivedCtrl = TextEditingController();
    nextDeliveryCtrl = TextEditingController(
      text: entry.deliveryDate == null
          ? ''
          : '${entry.deliveryDate!.year.toString().padLeft(4, '0')}-${entry.deliveryDate!.month.toString().padLeft(2, '0')}-${entry.deliveryDate!.day.toString().padLeft(2, '0')}',
    );
  }

  Future<void> submit() async {
    if (receivedToday <= 0) {
      Get.snackbar('Invalid', 'Enter received quantity');
      return;
    }

    if (newReceivedQuantity > entry.orderedQuantity) {
      Get.snackbar('Invalid', 'Received cannot exceed ordered quantity');
      return;
    }

    // if still partial, next delivery date required
    if (newStatus != DeliveryStatus.received && nextDeliveryDate == null) {
      Get.snackbar('Required', 'Next delivery date required for partial receive');
      return;
    }

    isSaving.value = true;
    try {
      final now = DateTime.now();

      await _stockRepo.updateStockEntry(entry.id, {
        'receivedQuantity': newReceivedQuantity,
        'status': newStatus.name,
        'deliveryDate': nextDeliveryDate,
        'updatedAt': now,
      });

      // Increase inventory stock ONLY for delta received today
      await _itemRepo.incrementStock(entry.itemId, receivedToday);

      await _activityRepo.addActivity(
        InventoryActivityModel(
          id: '',
          itemId: entry.itemId,
          type: 'stock_in',
          source: 'purchase_receive',
          title: 'Stock Received',
          description: 'Received +$receivedToday units against stock entry ${entry.id}',
          stockDelta: receivedToday,
          amount: receivedToday * entry.ratePerUnit,
          unitCost: entry.ratePerUnit,
          referenceId: entry.id,
          referenceType: 'inventory_stock',
          createdBy: 'admin',
          createdAt: now,
          isActive: true,
        ),
      );

      Get.back();
      Get.snackbar('Saved', 'Stock received updated');
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    receivedCtrl.dispose();
    nextDeliveryCtrl.dispose();
    super.onClose();
  }
}
