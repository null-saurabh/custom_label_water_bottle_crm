import 'dart:async';
import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_activity_model.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_activity_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/packaging_config_repo.dart';
import 'package:clwb_crm/screens/orders/models/order_activity_model.dart';
import 'package:clwb_crm/screens/orders/models/order_expense_model.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/repo/order_activity_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_expense_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_repo.dart';
import 'package:get/get.dart';

class CancelOrderController extends GetxController {
  final OrdersRepository _ordersRepo;
  final InventoryController _inventory;
  final OrderExpenseRepository _expenseRepo;
  final OrderActivityRepository _activityRepo;
  final InventoryActivityRepository _inventoryActivityRepo;


  final OrderModel order;

  CancelOrderController(
    this._ordersRepo,
    this._inventory,
    this._expenseRepo,
    this._activityRepo,
    this._inventoryActivityRepo,this.order,
      );

  final isSaving = false.obs;

  // ======================
  // FORM STATE
  // ======================

  final reason = ''.obs;
  final refundAmount = 0.0.obs;

  final restockMaterials = true.obs;
  final writeOffProduced = false.obs;

  // Auto-calculated available quantities
  late final int availableProduced =
      order.producedQuantity - order.deliveredQuantity;

  // Editable restock fields
  late final RxInt restockBottles = availableProduced.obs;
  late final RxInt restockCaps = availableProduced.obs;
  late final RxInt restockLabels = availableProduced.obs;
  late final RxInt restockPackaging = availableProduced.obs;

  final _packagingConfigRepo = PackagingConfigRepository();


  // ======================
  // SETTERS
  // ======================

  void setReason(String v) => reason.value = v;
  void setRefund(String v) => refundAmount.value = double.tryParse(v) ?? 0;

  void toggleRestock(bool v) => restockMaterials.value = v;
  void toggleWriteOff(bool v) => writeOffProduced.value = v;

  void setRestockBottles(String v) =>
      restockBottles.value = int.tryParse(v) ?? 0;

  void setRestockCaps(String v) => restockCaps.value = int.tryParse(v) ?? 0;

  void setRestockLabels(String v) => restockLabels.value = int.tryParse(v) ?? 0;

  void setRestockPackaging(String v) =>
      restockPackaging.value = int.tryParse(v) ?? 0;

  // ======================
  // SUBMIT
  // ======================

  Future<void> submitCancel() async {

    int maxPackagingUnits = availableProduced;

    if (order.packagingItemId != null) {
      final cfg = await _packagingConfigRepo.getConfig(order.packagingItemId!);
      final cap = cfg?.capacity;
      if (cap != null && cap > 0) {
        maxPackagingUnits = (availableProduced / cap).ceil();
      }
    }


    if (reason.value.isEmpty) {
      Get.snackbar('Required', 'Enter cancellation reason');
      return;
    }

    if (refundAmount.value > order.paidAmount) {
      Get.snackbar('Invalid', 'Refund exceeds paid amount');
      return;
    }

    if (restockBottles.value < 0 ||
        restockCaps.value < 0 ||
        restockLabels.value < 0 ||
        restockPackaging.value < 0) {
      Get.snackbar('Invalid', 'Restock qty cannot be negative');
      return;
    }

    if (restockBottles.value > availableProduced ||
        restockCaps.value > availableProduced ||
        restockLabels.value > availableProduced ||
        restockPackaging.value > maxPackagingUnits) {
      Get.snackbar('Invalid', 'Restock qty exceeds available limits');
      return;
    }


    isSaving.value = true;

    try {
      final now = DateTime.now();

      // ======================
      // 1️⃣ INVENTORY RESTOCK
      // ======================

      if (restockMaterials.value) {
        if (order.itemId.isNotEmpty) {
          await _inventory.addStock(itemId: order.itemId, quantity: restockBottles.value);


          await _logRestock(
            itemId: order.itemId,
            qty: restockBottles.value,
            itemLabel: 'bottles',
            now: now,
          );
        }

        if (order.capItemId != null) {
          await _inventory.addStock(itemId: order.capItemId!, quantity: restockCaps.value);

          await _logRestock(
            itemId: order.capItemId!,
            qty: restockCaps.value,
            itemLabel: 'caps',
            now: now,
          );
        }

        if (order.labelItemId != null) {
          await _inventory.addStock( itemId: order.labelItemId, quantity: restockLabels.value);

          await _logRestock(
            itemId: order.labelItemId!,
            qty: restockLabels.value,
            itemLabel: 'labels',
            now: now,
          );
        }

        if (order.packagingItemId != null) {
          await _inventory.addStock( itemId:order.packagingItemId!, quantity: restockPackaging.value);

          await _logRestock(
            itemId: order.packagingItemId!,
            qty: restockPackaging.value,
            itemLabel: 'packaging',
            now: now,
          );
        }
      }


      // ======================
      // 2️⃣ WRITE-OFF EXPENSE
      // ======================

      if (!writeOffProduced.value) {
        // no write-off entry
      } else {
        final restockedFinishedUnits = restockMaterials.value ? restockBottles.value : 0;
        final scrappedQty = availableProduced - restockedFinishedUnits;


        if (scrappedQty > 0) {
          await _expenseRepo.addExpense(
            OrderExpenseModel(
              id: '',
              orderId: order.id,
              clientId: order.clientId,
              stage: 'production',
              direction: 'out',
              category: 'wip_writeoff',
              description: 'Scrapped $scrappedQty bottles after cancellation',
              amount: 0, // optional: cost calc later
              paidAmount: 0,
              dueAmount: 0,
              vendorName: 'Internal',
              referenceNo: null,
              expenseDate: now,
              status: 'written_off',
              createdBy: 'admin',
              createdAt: now,
              updatedAt: now,
            ),
          );
        }
      }

      // ======================
      // 3️⃣ CLIENT REFUND
      // ======================

      if (refundAmount.value > 0) {
        await _expenseRepo.addExpense(
          OrderExpenseModel(
            id: '',
            orderId: order.id,
            clientId: order.clientId,
            stage: 'finance',
            direction: 'out',
            category: 'client_refund',
            description: 'Refund for cancelled order',
            amount: refundAmount.value,
            paidAmount: refundAmount.value,
            dueAmount: 0,
            vendorName: order.clientNameSnapshot,
            referenceNo: null,
            expenseDate: now,
            status: 'paid',
            createdBy: 'admin',
            createdAt: now,
            updatedAt: now,
          ),
        );
      }

      // ======================
      // 4️⃣ UPDATE ORDER
      // ======================

      final newPaid = order.paidAmount - refundAmount.value;

      await _ordersRepo.updateOrder(
        order.id,
        order
            .copyWith(
              paidAmount: newPaid,
              dueAmount: 0,
              orderStatus: 'cancelled',
              productionStatus: 'cancelled',
              deliveryStatus: order.deliveredQuantity > 0
                  ? 'partial_cancelled'
                  : 'cancelled',
              isActive: false,
              updatedAt: now,
            )
            .toMap(),
      );

      // ======================
      // 5️⃣ ACTIVITY LOG
      // ======================

      await _activityRepo.addActivity(
        OrderActivityModel(
          id: '',
          orderId: order.id,
          clientId: order.clientId,
          type: 'cancellation',
          title: 'Order Cancelled',
          description:
              '''
Reason: ${reason.value}
Produced: ${order.producedQuantity}
Delivered: ${order.deliveredQuantity}
Restocked: ${restockBottles.value}
Write-off: ${availableProduced - restockBottles.value}
Refund: ₹${refundAmount.value}
''',
          stage: 'cancellation',
          activityDate: now,
          createdBy: 'admin',
          createdAt: now,
        ),
      );

      Get.back();
      Get.snackbar('Success', 'Order cancelled');
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Failed to cancel order');
    } finally {
      isSaving.value = false;
    }
  }



  Future<void> _logRestock({
    required String itemId,
    required int qty,
    required String itemLabel,
    required DateTime now,
  }) async {
    if (qty <= 0) return;

    await _inventoryActivityRepo.addActivity(
      InventoryActivityModel(
        id: '',
        itemId: itemId,
        type: 'cancel_restock',
        source: 'order_cancel',
        title: 'Order Cancellation Restock',
        description:
        'Restocked $qty $itemLabel from cancelled Order ${order.orderNumber}',
        stockDelta: qty,
        amount: null,
        unitCost: null,
        referenceId: order.id,
        referenceType: 'order_cancel',
        createdBy: 'admin',
        createdAt: now,
        isActive: true,
      ),
    );
  }

}
