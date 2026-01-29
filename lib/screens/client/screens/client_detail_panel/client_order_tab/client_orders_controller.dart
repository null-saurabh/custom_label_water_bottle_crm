import 'dart:async';
import 'package:get/get.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/repo/order_repo.dart';

class ClientOrdersController extends GetxController {
  final String clientId;
  ClientOrdersController(this.clientId);

  final isLoading = true.obs;
  final orders = <OrderModel>[].obs;

  // quick stats
  final totalOrders = 0.obs;
  final activeOrders = 0.obs;
  final deliveredOrders = 0.obs;
  final totalBilled = 0.0.obs; // sum totalAmount
  final totalPaid = 0.0.obs;   // sum paidAmount
  final totalDue = 0.0.obs;    // sum dueAmount

  StreamSubscription? _sub;
  final OrdersRepository _ordersRepo = Get.find<OrdersRepository>();

  @override
  void onInit() {
    super.onInit();

    _sub = _ordersRepo.watchOrdersByClient(clientId).listen((list) {
      orders.assignAll(list);
      _recompute(list);
      isLoading.value = false;
    });
  }

  void _recompute(List<OrderModel> list) {
    totalOrders.value = list.length;

    deliveredOrders.value = list.where((o) {
      final fullyDelivered = o.deliveredQuantity >= o.orderedQuantity;
      return o.orderStatus == 'completed' || fullyDelivered;
    }).length;

    activeOrders.value = list.where((o) => o.orderStatus != 'completed').length;

    totalBilled.value = list.fold<double>(0, (s, o) => s + o.totalAmount);
    totalPaid.value = list.fold<double>(0, (s, o) => s + o.paidAmount);
    totalDue.value = list.fold<double>(0, (s, o) => s + (o.dueAmount > 0 ? o.dueAmount : 0));
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
