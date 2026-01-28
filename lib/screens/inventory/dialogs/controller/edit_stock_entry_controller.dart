// import 'package:clwb_crm/screens/inventory/repositories/inventory_stocks_repo.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'package:clwb_crm/screens/inventory/model/inventory_stock_add_model.dart';
// import 'package:clwb_crm/screens/inventory/repositories/inventory_item_repo.dart';
// import 'package:clwb_crm/screens/inventory/repositories/inventory_activity_repo.dart';
// import 'package:clwb_crm/screens/inventory/model/inventory_activity_model.dart';
//
// class EditStockEntryController extends GetxController {
//   final InventoryStockAddModel entry;
//   EditStockEntryController(this.entry);
//
//   final isSaving = false.obs;
//
//   // ======================
//   // TEXT CONTROLLERS
//   // ======================
//   late final TextEditingController addReceivedCtrl;
//   late final TextEditingController addPaidCtrl;
//
//   // ======================
//   // COMPUTED
//   // ======================
//   int get addReceived =>
//       int.tryParse(addReceivedCtrl.text.trim()) ?? 0;
//
//   double get addPaid =>
//       double.tryParse(addPaidCtrl.text.trim()) ?? 0;
//
//   int get newReceivedQuantity =>
//       entry.receivedQuantity + addReceived;
//
//   double get newPaidAmount =>
//       entry.paidAmount + addPaid;
//
//   double get newDueAmount =>
//       entry.totalAmount - newPaidAmount;
//
//   DeliveryStatus get newStatus {
//     final r = newReceivedQuantity;
//     if (r <= 0) return DeliveryStatus.pending;
//     if (r < entry.orderedQuantity) return DeliveryStatus.partial;
//     return DeliveryStatus.received;
//   }
//
//   final _stockRepo = InventoryStockRepository();
//   final _itemRepo = InventoryItemRepository();
//   final _activityRepo = InventoryActivityRepository();
//
//   @override
//   void onInit() {
//     super.onInit();
//     addReceivedCtrl = TextEditingController();
//     addPaidCtrl = TextEditingController();
//   }
//
//   Future<void> submit() async {
//     if (addReceived < 0 || addPaid < 0) {
//       Get.snackbar('Invalid', 'Values cannot be negative');
//       return;
//     }
//
//     if (newReceivedQuantity > entry.orderedQuantity) {
//       Get.snackbar('Invalid', 'Received cannot exceed ordered quantity');
//       return;
//     }
//
//     if (addReceived == 0 && addPaid == 0) {
//       Get.snackbar('Nothing to update', 'Enter received qty or payment');
//       return;
//     }
//
//     isSaving.value = true;
//     try {
//       final now = DateTime.now();
//
//       // 1️⃣ Update stock entry doc
//       await _stockRepo.updateStockEntry(entry.id, {
//         'receivedQuantity': newReceivedQuantity,
//         'paidAmount': newPaidAmount,
//         'dueAmount': newDueAmount,
//         'status': newStatus.name,
//         'updatedAt': now,
//       });
//
//       // 2️⃣ Increase inventory stock ONLY for delta received now
//       if (addReceived > 0) {
//         await _itemRepo.incrementStock(entry.itemId, addReceived);
//
//         // 3️⃣ Inventory activity log for received delta
//         final amount = addReceived * entry.ratePerUnit;
//
//         await _activityRepo.addActivity(
//           InventoryActivityModel(
//             id: '',
//             itemId: entry.itemId,
//             type: 'stock_in',
//             source: 'purchase_update',
//             title: 'Stock Received (Update)',
//             description:
//             'Received +$addReceived units against stock entry ${entry.id}',
//             stockDelta: addReceived,
//             amount: amount,
//             unitCost: entry.ratePerUnit,
//             referenceId: entry.id,
//             referenceType: 'inventory_stock',
//             createdBy: 'admin',
//             createdAt: now,
//             isActive: true,
//           ),
//         );
//       }
//
//       Get.back();
//       Get.snackbar('Saved', 'Stock entry updated');
//     } finally {
//       isSaving.value = false;
//     }
//   }
//
//   @override
//   void onClose() {
//     addReceivedCtrl.dispose();
//     addPaidCtrl.dispose();
//     super.onClose();
//   }
// }
