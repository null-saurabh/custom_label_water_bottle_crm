import 'dart:async';
import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_activity_repo.dart';
import 'package:clwb_crm/screens/orders/dialog/add_order_dialog.dart';
import 'package:clwb_crm/screens/orders/dialog/cancel_order_dialog.dart';
import 'package:clwb_crm/screens/orders/dialog/controller/cancel_oder_controller.dart';
import 'package:clwb_crm/screens/orders/dialog/controller/edit_order_controller.dart';
import 'package:clwb_crm/screens/orders/dialog/edit_order_dialog.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/repo/order_activity_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_expense_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_repo.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/order_detail_controller.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/widgets/overview_tab/over_detail_tab_controller.dart';
import 'package:get/get.dart';


enum OrderSortMode {
  delivery,
  created,
}


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

  late Worker _searchDebounce;

  @override
  void onInit() {
    super.onInit();

    _bindOrdersStream();

    _searchDebounce = debounce(
      searchQuery,
          (_) => _applyFilters(),
      time: const Duration(milliseconds: 300),
    );

    everAll(
      [statusFilter, clientFilter, dateFilter,sortMode,],
          (_) => _applyFilters(),
    );
  }

  @override
  void onClose() {
    _ordersSub?.cancel();
    _searchDebounce.dispose();
    super.onClose();
  }




  // ======================
  // STREAMS
  // ======================

  void _bindOrdersStream() {
    _ordersSub = _repo.watchAllOrders().listen((list) {
      // print("🔥 STREAM EMIT: ${list.length}");

      allOrders.assignAll(list);
      // allOrders.value = list;


      // 🔥 FORCE RX NOTIFICATION
      visibleOrders.clear();
      _applyFilters();

      isLoading.value = false;
    });
  }







  // ======================
  // FILTERS
  // ======================

  final Rx<OrderSortMode> sortMode = OrderSortMode.delivery.obs;


  void _applyFilters() {
    var list = List<OrderModel>.from(allOrders);

    // ======================
    // FILTERS
    // ======================

    if (statusFilter.value == 'all') {
      list = list.where((o) => o.orderStatus != 'completed' && o.orderStatus != 'cancelled').toList();
    } else {
      list = list
          .where((o) => o.orderStatus == statusFilter.value)
          .toList();
    }

    if (clientFilter.value != 'all') {
      list = list
          .where((o) => o.clientNameSnapshot == clientFilter.value)
          .toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list.where((o) {
        return o.orderNumber.toLowerCase().contains(q) ||
            o.clientNameSnapshot.toLowerCase().contains(q);
      }).toList();
    }



    // ======================
// DATE FILTER (optional)
// ======================
//     final now = DateTime.now();
//
//     if (dateFilter.value == 'today') {
//       list = list.where((o) {
//         final d = o.createdAt;
//         return d.year == now.year && d.month == now.month && d.day == now.day;
//       }).toList();
//     }
//
//     if (dateFilter.value == 'this_week') {
//       final start = now.subtract(Duration(days: now.weekday - 1));
//       final end = start.add(const Duration(days: 7));
//       list = list.where((o) {
//         final d = o.createdAt;
//         return d.isAfter(start) && d.isBefore(end);
//       }).toList();
//     }
//
//     if (dateFilter.value == 'this_month') {
//       list = list.where((o) {
//         final d = o.createdAt;
//         return d.year == now.year && d.month == now.month;
//       }).toList();
//     }


    // ======================
    // 🔥 GROUP BY PRIORITY
    // ======================

    final priorityOrders = list.where((o) => o.isPriority).toList();
    final normalOrders = list.where((o) => !o.isPriority).toList();

    // ======================
    // 🔥 SORT FUNCTION
    // ======================

    int compare(OrderModel a, OrderModel b) {
      switch (sortMode.value) {
        case OrderSortMode.delivery:
          final ad = a.expectedDeliveryDate;
          final bd = b.expectedDeliveryDate;

          if (ad != null && bd != null) {
            final d = ad.compareTo(bd);
            if (d != 0) return d;
          } else if (ad != null) {
            return -1;
          } else if (bd != null) {
            return 1;
          }

          return b.createdAt.compareTo(a.createdAt);

        case OrderSortMode.created:
          return b.createdAt.compareTo(a.createdAt);

      }
    }

    priorityOrders.sort(compare);
    normalOrders.sort(compare);

    visibleOrders.assignAll([
      ...priorityOrders,
      ...normalOrders,
    ]);
  }


  void selectOrder(OrderModel order) {
    selectedOrderId.value = order.id;

    if (Get.isRegistered<OrderDetailTabsController>()) {
      Get.find<OrderDetailTabsController>().reset();
    }

    if (Get.isRegistered<OrderDetailController>()) {
      Get.find<OrderDetailController>().bindOrder(order.id);
    }
  }


  void clearSelection() {
    selectedOrderId.value = null;

    if (Get.isRegistered<OrderDetailTabsController>()) {
      Get.find<OrderDetailTabsController>().reset();
    }

    if (Get.isRegistered<OrderDetailController>()) {
      Get.find<OrderDetailController>().clear();
    }
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
  void setSortMode(OrderSortMode mode) {
    sortMode.value = mode;
  }


  void openAddOrderDialog() {
    Get.dialog(const AddOrderDialog());
  }


  void openEditOrderDialog(OrderModel order) {
    // 🔥 Ensure fresh controller each time
    if (Get.isRegistered<EditOrderController>()) {
      Get.delete<EditOrderController>();
    }

    Get.put(
      EditOrderController(
        Get.find<OrdersRepository>(),
        Get.find<InventoryController>(),
        Get.find<OrderActivityRepository>(),
        order,
      ),
    );

    Get.dialog(const EditOrderDialog());
  }

  void openCancelDialog(OrderModel order) {

    if (Get.isRegistered<CancelOrderController>()) {
      Get.delete<CancelOrderController>();
    }


        Get.put(
          CancelOrderController(
            Get.find<OrdersRepository>(),
            Get.find<InventoryController>(),
            Get.find<OrderExpenseRepository>(),
            Get.find<OrderActivityRepository>(),
            Get.find<InventoryActivityRepository>(),
            order,
          ),
        );

    Get.dialog(const CancelOrderDialog());


  }



}
