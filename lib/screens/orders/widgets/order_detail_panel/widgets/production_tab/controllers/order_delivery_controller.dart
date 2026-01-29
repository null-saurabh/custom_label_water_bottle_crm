import 'package:clwb_crm/screens/orders/models/order_activity_model.dart';
import 'package:clwb_crm/screens/orders/models/order_delivery_entry_model.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/repo/order_activity_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_delivery_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_repo.dart';
import 'package:get/get.dart';

class DeliveryController extends GetxController {
  final OrderDeliveryRepository _deliveryRepo;
  final OrdersRepository _ordersRepo;
  final  OrderActivityRepository _activityRepo;


  DeliveryController(
      this._deliveryRepo,
      this._ordersRepo,
      this._activityRepo,

      );

  final isSaving = false.obs;

  // UI fields
  final deliveredToday = 0.obs;
  final deliveryDate = DateTime.now().obs;
  final notes = ''.obs;

  Future<void> submitDelivery(
      OrderModel order,
      ) async {
    if (deliveredToday.value <= 0) {
      Get.snackbar(
        'Invalid Input',
        'Enter delivered quantity',
      );
      return;
    }

    final newTotal =
        order.deliveredQuantity + deliveredToday.value;

    if (newTotal > order.orderedQuantity) {
      Get.snackbar(
        'Invalid Quantity',
        'Delivery exceeds order quantity',
      );
      return;
    }

    isSaving.value = true;

    try {
      final entry = OrderDeliveryEntryModel(
        id: '',
        orderId: order.id,
        quantityDeliveredToday: deliveredToday.value,
        cumulativeDelivered: newTotal,
        deliveryDate: deliveryDate.value,
        notes: notes.value,
        createdBy: 'admin',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _deliveryRepo.addDeliveryEntry(entry);

      final isComplete =
          newTotal >= order.orderedQuantity;

      final updatedOrder = order.copyWith(
        deliveredQuantity: newTotal,
        remainingQuantity:
        order.orderedQuantity - newTotal,
        deliveryStatus:
        isComplete ? 'completed' : 'partial',
        orderStatus:
        isComplete
            ? 'completed'
            : 'partially_delivered',
        updatedAt: DateTime.now(),
      );

      await _ordersRepo.updateOrder(
        order.id,
        updatedOrder.toMap(),
      );

// 🔁 RECURRING TRIGGER
      if (isComplete &&
          order.isRecurring &&
          order.recurringIntervalDays != null) {

        final newOrderNo =
        await _ordersRepo.generateNextOrderNumber();

        final nextOrder =
        order.cloneForNextRecurring(
          newOrderNumber: newOrderNo,
        );

        await _ordersRepo.createOrder(nextOrder);

        await _ordersRepo.updateOrder(
          order.id,
          order.copyWith(
            lastRecurringGeneratedAt:
            DateTime.now(),
            nextRecurringDate:
            DateTime.now().add(
              Duration(
                days: order.recurringIntervalDays!,
              ),
            ),
            updatedAt: DateTime.now(),
          ).toMap(),
        );
      }
      // 4️⃣ (OPTIONAL, PLUGGED IN LATER)
      // await _expenseRepo.addExpense(...);

      await _activityRepo.addActivity(
        OrderActivityModel(
          id: '',
          orderId: order.id,
          clientId: order.clientId,
          type: 'delivery',
          title: 'Delivery Updated',
          description:
          'Delivered ${deliveredToday.value} bottles '
              '(Total: $newTotal)',
          stage: 'delivery',
          activityDate: DateTime.now(),
          createdBy: 'admin',
          createdAt: DateTime.now(),
        ),
      );


      Get.back();
      Get.snackbar('Success', 'Delivery updated');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update delivery',
      );
    } finally {
      isSaving.value = false;
    }
  }
}
