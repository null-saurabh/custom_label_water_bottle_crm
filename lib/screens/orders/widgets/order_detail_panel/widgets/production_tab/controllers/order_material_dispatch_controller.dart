import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/orders/models/order_activity_model.dart';
import 'package:clwb_crm/screens/orders/models/order_material_dispatch_model.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/repo/order_activity_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_expense_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_material_dispatch_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_repo.dart';
import 'package:get/get.dart';

class MaterialDispatchController extends GetxController {
  final OrderMaterialDispatchRepository _dispatchRepo;
  final OrdersRepository _ordersRepo;
  final InventoryController _inventory;
  final OrderExpenseRepository _expenseRepo;
  final OrderActivityRepository _activityRepo;

  MaterialDispatchController(
      this._dispatchRepo,
      this._ordersRepo,
      this._inventory,
      this._expenseRepo,
      this._activityRepo,
      );

  final isSaving = false.obs;

  // UI fields
  final bottlesSent = 0.obs;
  final labelsSent = 0.obs;
  final capsSent = 0.obs;
  final packagingSent = 0.obs;

  final dispatchDate = DateTime.now().obs;
  final notes = ''.obs;

  Future<void> submitDispatch(OrderModel order) async {
    if (bottlesSent.value <= 0 &&
        labelsSent.value <= 0 &&
        capsSent.value <= 0 &&
        packagingSent.value <= 0) {
      Get.snackbar(
        'Invalid Input',
        'Please enter at least one material quantity',
      );
      return;
    }

    isSaving.value = true;

    try {
      // 1️⃣ Deduct inventory
      await _inventory.deductStock(
        itemId: order.itemId,
        quantity: bottlesSent.value,
      );

      await _inventory.deductStock(
        itemId: order.labelItemId,
        quantity: labelsSent.value,
      );

      await _inventory.deductStock(
        itemId: order.capItemId,
        quantity: capsSent.value,
      );

      if (order.packagingItemId != null &&
          packagingSent.value > 0) {
        await _inventory.deductStock(
          itemId: order.packagingItemId!,
          quantity: packagingSent.value,
        );
      }

      // 2️⃣ Create dispatch entry
      final dispatch = OrderMaterialDispatchModel(
        id: '',
        orderId: order.id,
        bottlesSent: bottlesSent.value,
        labelsSent: labelsSent.value,
        capsSent: capsSent.value,
        packagingSent: packagingSent.value,
        status: 'partial',
        dispatchDate: dispatchDate.value,
        createdBy: 'admin',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _dispatchRepo.addDispatch(dispatch);

      // 3️⃣ Update order status
      await _ordersRepo.updateOrder(
        order.id,
        order.copyWith(
          orderStatus: 'in_material_dispatch',
          updatedAt: DateTime.now(),
        ).toMap(),
      );


      // 4️⃣ (OPTIONAL, PLUGGED IN LATER)
      //  await _expenseRepo.addExpense(...);

      await _activityRepo.addActivity(
        OrderActivityModel(
          id: '',
          orderId: order.id,
          type: 'dispatch',
          title: 'Materials Dispatched',
          description:
          'Dispatched ${bottlesSent.value} bottles, '
              '${labelsSent.value} labels, '
              '${capsSent.value} caps',
          stage: 'dispatch',
          activityDate: DateTime.now(),
          createdBy: 'admin',
          createdAt: DateTime.now(),
        ),
      );


      Get.back();
      Get.snackbar('Success', 'Materials dispatched');
    } catch (e) {
      Get.snackbar('Error', 'Failed to dispatch materials');
    } finally {
      isSaving.value = false;
    }
  }
}
