import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_item_model.dart';
import 'package:clwb_crm/screens/orders/models/order_activity_model.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/repo/order_activity_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditOrderController extends GetxController {
  final OrdersRepository _ordersRepo;
  final InventoryController _inventory;
  final OrderActivityRepository _activityRepo;

  final OrderModel order;

  EditOrderController(
      this._ordersRepo,
      this._inventory,
      this._activityRepo,
      this.order,
      );

  // ======================
  // STATE
  // ======================

  final RxInt quantity = 0.obs;
  final RxDouble ratePerBottle = 0.0.obs;

  final RxBool isPriority = false.obs;
  final RxBool isRecurring = false.obs;
  final RxInt recurringIntervalDays = 0.obs;

  final Rxn<DateTime> deliveryDate = Rxn<DateTime>();

  final Rxn<InventoryItemModel> selectedCap = Rxn();
  final Rxn<InventoryItemModel> selectedPackaging = Rxn();

  final RxString notes = ''.obs;
  final RxBool isSaving = false.obs;


  // ======================
// TEXT CONTROLLERS 🔥
// ======================

  late final TextEditingController qtyCtrl;
  late final TextEditingController rateCtrl;
  late final TextEditingController recurringCtrl;
  late final TextEditingController notesCtrl;


  // ======================
  // DATA SOURCES
  // ======================

  List<InventoryItemModel> get capItems =>
      _inventory.items
          .where((i) => i.category == InventoryCategory.cap && i.isActive)
          .toList();

  List<InventoryItemModel> get packagingItems =>
      _inventory.items
          .where((i) => i.category == InventoryCategory.packaging && i.isActive)
          .toList();

  // ======================
  // INIT
  // ======================

  @override
  void onInit() {
    super.onInit();

    quantity.value = order.orderedQuantity;
    ratePerBottle.value = order.ratePerBottle;

    isPriority.value = order.isPriority;
    isRecurring.value = order.isRecurring;
    recurringIntervalDays.value = order.recurringIntervalDays ?? 0;

    deliveryDate.value = order.expectedDeliveryDate;

    selectedCap.value = _inventory.items
        .firstWhereOrNull((i) => i.id == order.capItemId);

    selectedPackaging.value = order.packagingItemId == null
        ? null
        : _inventory.items.firstWhereOrNull(
          (i) => i.id == order.packagingItemId,
    );

    notes.value = order.notes ?? '';

    // 🔥 TEXT PREFILL
    qtyCtrl = TextEditingController(
      text: order.orderedQuantity.toString(),
    );

    rateCtrl = TextEditingController(
      text: order.ratePerBottle.toStringAsFixed(2),
    );

    recurringCtrl = TextEditingController(
      text: order.recurringIntervalDays?.toString() ?? '',
    );

    notesCtrl = TextEditingController(
      text: order.notes ?? '',
    );
  }


  // ======================
  // SETTERS
  // ======================

  void setQty(String v) =>
      quantity.value = int.tryParse(v) ?? quantity.value;

  void setRate(String v) =>
      ratePerBottle.value = double.tryParse(v) ?? ratePerBottle.value;

  void togglePriority(bool v) => isPriority.value = v;

  void toggleRecurring(bool v) => isRecurring.value = v;

  void setRecurringInterval(String v) =>
      recurringIntervalDays.value = int.tryParse(v) ?? 0;

  void setDeliveryDate(DateTime d) => deliveryDate.value = d;

  void setNotes(String v) => notes.value = v;

  void setCapByName(String? name) {
    if (name == null) return;
    selectedCap.value =
        capItems.firstWhereOrNull((c) => c.name == name);
  }

  void setPackagingByName(String? name) {
    if (name == null) return;
    selectedPackaging.value =
        packagingItems.firstWhereOrNull((p) => p.name == name);
  }

  // ======================
  // SUBMIT
  // ======================

  Future<void> submit() async {
    if (quantity.value <= 0 || ratePerBottle.value <= 0) {
      Get.snackbar('Invalid', 'Quantity & rate required');
      return;
    }

    if (deliveryDate.value == null) {
      Get.snackbar('Invalid', 'Delivery date required');
      return;
    }

    if (isRecurring.value && recurringIntervalDays.value <= 0) {
      Get.snackbar('Invalid', 'Recurring days required');
      return;
    }

    isSaving.value = true;

    try {
      final newTotal = quantity.value * ratePerBottle.value;
      final newDue = newTotal - order.paidAmount;

      final updated = order.copyWith(
        orderedQuantity: quantity.value,
        ratePerBottle: ratePerBottle.value,
        totalAmount: newTotal,
        dueAmount: newDue,

        expectedDeliveryDate: deliveryDate.value,

        isPriority: isPriority.value,
        isRecurring: isRecurring.value,
        recurringIntervalDays:
        isRecurring.value ? recurringIntervalDays.value : null,

        capItemId: selectedCap.value?.id,
        capNameSnapshot: selectedCap.value?.name,

        packagingItemId: selectedPackaging.value?.id,
        packagingNameSnapshot: selectedPackaging.value?.name,

        notes: notes.value,
        updatedAt: DateTime.now(),
      );

      await _ordersRepo.updateOrder(
        order.id,
        updated.toMap(),
      );

      await _activityRepo.addActivity(
        OrderActivityModel(
          id: '',
          orderId: order.id,
          clientId: order.clientId,
          type: 'edit',
          title: 'Order Updated',
          description: 'Order details edited',
          stage: 'meta',
          activityDate: DateTime.now(),
          createdBy: 'admin',
          createdAt: DateTime.now(),
        ),
      );

      Get.back();
      Get.snackbar('Success', 'Order updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update order');
    } finally {
      isSaving.value = false;
    }
  }


  @override
  void onClose() {
    qtyCtrl.dispose();
    rateCtrl.dispose();
    recurringCtrl.dispose();
    notesCtrl.dispose();
    super.onClose();
  }


}
