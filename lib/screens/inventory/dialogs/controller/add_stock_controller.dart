import 'package:clwb_crm/screens/inventory/model/inventory_activity_model.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_item_model.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_stock_add_model.dart';
import 'package:clwb_crm/screens/inventory/model/supplier_item_model.dart';
import 'package:clwb_crm/screens/inventory/model/supplier_model.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_activity_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_item_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_stocks_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/supplier_item_repo.dart';
import 'package:get/get.dart';

class AddStockController extends GetxController {
  final List<InventoryItemModel> items;
  final List<SupplierModel> suppliers;

  AddStockController({
    required this.items,
    required this.suppliers,
  });

  // ===============================
  // FORM STATE
  // ===============================
  final selectedItemId = RxnString();
  final selectedSupplierId = RxnString();
  final selectedSupplier = Rxn<SupplierModel>();

  final quantity = 0.obs;
  final receivedQuantity = 0.obs;
  final ratePerUnit = 0.0.obs;

  final paidAmount = 0.0.obs;

  // final status = DeliveryStatus.pending.obs;
  // final deliveryDate = Rxn<DateTime>();
  final dueDate = Rxn<DateTime>();

  final isSaving = false.obs;

  final nextDeliveryDate = Rxn<DateTime>();

  // ===============================
  // COMPUTED
  // ===============================
  double get totalAmountComputed =>
      ratePerUnit.value * quantity.value;

  double get dueAmount =>
      totalAmountComputed - paidAmount.value;

  DeliveryStatus resolveStatus({
    required int ordered,
    required int received,
  }) {
    if (received == 0) return DeliveryStatus.pending;
    if (received < ordered) return DeliveryStatus.partial;
    return DeliveryStatus.received;
  }




  bool get isValid {
    if (selectedItemId.value == null) return false;
    if (selectedSupplierId.value == null) return false;
    if (quantity.value <= 0) return false;
    if (ratePerUnit.value <= 0) return false;
    if (paidAmount.value < 0) return false;
    if (paidAmount.value > totalAmountComputed) return false;
    return true;
  }


  // ===============================
  // REPOS
  // ===============================
  final _stockRepo = InventoryStockRepository();
  final _itemRepo = InventoryItemRepository();
  final _activityRepo = InventoryActivityRepository();
  final _supplierItemRepo = SupplierItemRepository();

  // ===============================
  // SUBMIT
  // ===============================
  Future<void> submit() async {
    if (!isValid) return;

    try {
      isSaving.value = true;
      final now = DateTime.now();

      final statusResolved = resolveStatus(
        ordered: quantity.value,
        received: receivedQuantity.value,
      );

      if (statusResolved != DeliveryStatus.received &&
          nextDeliveryDate.value == null) {
        Get.snackbar(
          'Validation Error',
          'Next delivery date is required for partial delivery',
        );
        return; // ✅ just exit
      }



      final existing =
      await _supplierItemRepo.findSupplierItem(
        supplierId: selectedSupplierId.value!,
        itemId: selectedItemId.value!,
      );

      if (existing == null) {
        await _supplierItemRepo.addSupplierItem(
          SupplierItemModel(
            id: '',
            supplierId: selectedSupplierId.value!,
            itemId: selectedItemId.value!,
            supplierSku: '',
            costPerUnit: ratePerUnit.value,
            createdAt: now,
          ),
        );
      }



      final stock = InventoryStockAddModel(
        id: '',
        itemId: selectedItemId.value!,
        supplierId: selectedSupplierId.value!,
        orderedQuantity: quantity.value,
        receivedQuantity: receivedQuantity.value,
        totalAmount: totalAmountComputed,
        paidAmount: paidAmount.value,
        dueAmount: dueAmount,
        status: statusResolved,
        deliveryDate: nextDeliveryDate.value,
        dueDate: dueDate.value,
        createdAt: now,
        updatedAt: now,
        ratePerUnit: ratePerUnit.value,
      );

      await _stockRepo.addStock(stock);

      /// Increase item stock (simple version)
      await _itemRepo.incrementStock(
        selectedItemId.value!,
        receivedQuantity.value,
      );

      /// Activity
      final itemId = selectedItemId.value!;
      final qty = receivedQuantity.value;

// ✅ inventory movement should reflect received qty only
      final total = ratePerUnit.value * qty;
      final unitCost = qty > 0 ? ratePerUnit.value : null;


      await _activityRepo.addActivity(
        InventoryActivityModel(
          id: '',
          itemId: itemId,
          type: 'stock_in',
          source: 'purchase',
          title: 'Stock Added',
          description:
          '$qty units received from supplier ${selectedSupplier.value?.name ?? ''}',
          stockDelta: qty,
          amount: total,
          unitCost: unitCost,
          referenceId: selectedSupplierId.value,
          referenceType: 'supplier',
          createdBy: 'admin',
          createdAt: now,
          isActive: true,
        ),
      );


      Get.back();
      Get.delete<AddStockController>();

      Get.snackbar('Success', 'Stock added successfully');
    } finally {
      isSaving.value = false;
    }
  }
}
