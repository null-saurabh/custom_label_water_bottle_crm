import 'dart:async';
import 'package:clwb_crm/screens/orders/dialog/add_order_dialog.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/repo/order_repo.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/order_detail_controller.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/widgets/overview_tab/over_detail_tab_controller.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {
  final OrdersRepository _repo;

  OrdersController(this._repo);

  // ======================
  // STATE
  // ======================

  final RxBool isLoading = true.obs;

  final RxList<OrderModel> allOrders = <OrderModel>[].obs;
  final RxList<OrderModel> visibleOrders = <OrderModel>[].obs;

  final RxnString selectedOrderId = RxnString();
  // final selectedOrder =  Rxn<OrderModel>();
  OrderModel? get selectedOrder =>
      allOrders.firstWhereOrNull(
            (o) => o.id == selectedOrderId.value,
      );

  final RxString statusFilter = 'all'.obs;
  final RxString clientFilter = 'all'.obs;
  final RxString dateFilter = 'all'.obs;
  final RxString searchQuery = ''.obs;

  StreamSubscription? _ordersSub;

  // ======================
  // LIFECYCLE
  // ======================

  @override
  void onInit() {
    super.onInit();
    _bindOrdersStream();
    everAll(
      [statusFilter, clientFilter, dateFilter, searchQuery],
          (_) {
        _applyFilters();
        visibleOrders.refresh(); // 🔥 FORCE UI REBUILD
      },
    );

  }

  @override
  void onClose() {
    _ordersSub?.cancel();
    super.onClose();
  }

  // ======================
  // STREAMS
  // ======================

  void _bindOrdersStream() {
    _ordersSub = _repo.watchAllOrders().listen((list) {
      // print("🔥 STREAM EMIT: ${list.length}");

      allOrders.assignAll(list);

      // 🔥 FORCE RX NOTIFICATION
      visibleOrders.clear();
      _applyFilters();

      isLoading.value = false;
    });
  }







  // ======================
  // FILTERS
  // ======================

  void _applyFilters() {
    var list = List<OrderModel>.from(allOrders);

    if (statusFilter.value != 'all') {
      list = list
          .where((o) => o.orderStatus == statusFilter.value)
          .toList();
    }

    if (clientFilter.value != 'all') {
      list = list
          .where((o) =>
      o.clientNameSnapshot == clientFilter.value)
          .toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list.where((o) {
        return o.orderNumber.toLowerCase().contains(q) ||
            o.clientNameSnapshot.toLowerCase().contains(q);
      }).toList();
    }

    visibleOrders.assignAll(list);
  }

  // ======================
  // UI ACTIONS
  // ======================

  void selectOrder(OrderModel order) {
    // selectedOrder.value = order;

    selectedOrderId.value = order.id;

    // // 🔥 NEW: bind tab controller
    // if (!Get.isRegistered<OrderDetailTabsController>()) {
    //   Get.put(OrderDetailTabsController());
    // } else {
      Get.find<OrderDetailTabsController>().reset();
    // }


    Get.find<OrderDetailController>()
        .bindOrder(order.id);
  }

  void clearSelection() {
    selectedOrderId.value = null;
    // print("clear");
    // if (Get.isRegistered<OrderDetailTabsController>()) {
    //   Get.delete<OrderDetailTabsController>();
    // }
    // 🔥 Reset tab instead of deleting controller
    Get.find<OrderDetailTabsController>().reset();


    Get.find<OrderDetailController>().clear();
    // update();
  }

  void setStatusFilter(String v) {
    statusFilter.value = v;
  }

  void setClientFilter(String v) {
    clientFilter.value = v;
  }

  void setSearch(String v) {
    searchQuery.value = v;
  }

  void setDateFilter(String v) {
    dateFilter.value = v;
  }

  void openAddOrderDialog() {
    Get.dialog(const AddOrderDialog());
  }
}
