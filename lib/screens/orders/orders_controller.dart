// lib/features/orders/orders_controller.dart
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/models/orderline_model.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {
  final orders = <OrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  void loadOrders() {
    orders.assignAll([
      OrderModel(
        id: 'ORD-001',
        clientId: 'HOTEL_01',
        dueDate: DateTime.now(),
        lines: [
          OrderLineModel(
            skuId: 'A-500-A1',
            orderedQty: 1000,
            labelledQty: 600,
            shippedQty: 400,
          ),
        ],
      ),
    ]);
  }

  int totalRemainingToLabel(OrderModel order) {
    return order.lines.fold(
      0,
          (sum, l) => sum + l.remainingToLabel,
    );
  }

  int totalRemainingToShip(OrderModel order) {
    return order.lines.fold(
      0,
          (sum, l) => sum + l.remainingToShip,
    );
  }
}
