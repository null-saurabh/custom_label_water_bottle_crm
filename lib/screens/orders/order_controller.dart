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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


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

  // --- Focus mode (dashboard -> orders) ---
  final RxBool forceShowAllStatuses = false.obs;

// So we can programmatically set the search box text
  late final TextEditingController searchCtrl;


  @override
  void onInit() {
    super.onInit();

    searchCtrl = TextEditingController(text: searchQuery.value);

    _bindOrdersStream();

    _searchDebounce = debounce(
      searchQuery,
          (_) => _applyFilters(),
      time: const Duration(milliseconds: 300),
    );

    everAll(
      [statusFilter, clientFilter, dateFilter,sortMode, forceShowAllStatuses],
          (_) => _applyFilters(),
    );
  }

  @override
  void onClose() {
    _ordersSub?.cancel();
    _searchDebounce.dispose();
    searchCtrl.dispose(); // ✅ add
    forceShowAllStatuses.value = false;

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


  void clearSearch() {
    setSearch('');
    // when user clears, go back to normal behavior
    if (forceShowAllStatuses.value) {
      forceShowAllStatuses.value = false;
    }
  }

  DateTime? customStartDate;
  DateTime? customEndDate;





  Future<void> openCustomDatePicker() async {
    final initialStart = customStartDate;
    final initialEnd = customEndDate;

    DateTime? pickedStart = initialStart;
    DateTime? pickedEnd = initialEnd;

    final pickerCtrl = DateRangePickerController();

    final result = await Get.dialog<bool>(
      StatefulBuilder(
        builder: (context, setState) {
          // these must live INSIDE the builder so UI updates work
          pickedStart ??= initialStart;
          pickedEnd ??= initialEnd;

          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(18),
            child: Container(
              width: 520,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 30,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Select Date Range',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Close',
                        onPressed: () => Get.back(result: false),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      color: const Color(0xFFF7F9FC),
                      child: SfDateRangePicker(
                        controller: pickerCtrl,
                        selectionMode: DateRangePickerSelectionMode.range,

                        // ✅ force it to reflect current values
                        initialSelectedRange: (pickedStart != null && pickedEnd != null)
                            ? PickerDateRange(pickedStart, pickedEnd)
                            : null,

                        onSelectionChanged: (args) {
                          final r = args.value;
                          if (r is PickerDateRange) {
                            setState(() {
                              pickedStart = r.startDate;
                              pickedEnd = r.endDate ?? r.startDate;
                            });
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F4FA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _rangeLabel(pickedStart, pickedEnd),
                            style: const TextStyle(fontSize: 12, color: Color(0xFF374151)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      TextButton(
                        onPressed: () {
                          setState(() {
                            pickedStart = null;
                            pickedEnd = null;
                            pickerCtrl.selectedRange = null;
                          });
                        },
                        child: const Text('Clear'),
                      ),

                      const SizedBox(width: 8),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4C6FFF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onPressed: () => Get.back(result: true),
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      barrierDismissible: true,
    );


    if (result == true && pickedStart != null && pickedEnd != null) {
      customStartDate = DateTime(pickedStart!.year, pickedStart!.month, pickedStart!.day);
      customEndDate = DateTime(pickedEnd!.year, pickedEnd!.month, pickedEnd!.day);

      dateFilter.value = 'custom';
      _applyFilters();
    }
  }

  String _rangeLabel(DateTime? s, DateTime? e) {
    if (s == null || e == null) return 'No range selected';
    final f = DateFormat('dd MMM yyyy');
    return '${f.format(s)}  →  ${f.format(e)}';
  }



  void _applyFilters() {
    var list = List<OrderModel>.from(allOrders);

    // ======================
    // FILTERS
    // ======================

    if (!forceShowAllStatuses.value) {
      // default behaviour: hide completed/cancelled
      if (statusFilter.value == 'all') {
        list = list.where((o) =>
        o.orderStatus != 'completed' && o.orderStatus != 'cancelled'
        ).toList();
      } else {
        list = list.where((o) => o.orderStatus == statusFilter.value).toList();
      }
    }
// else: focus mode => do not filter by status at all


    if (clientFilter.value != 'all') {
      list = list
          .where((o) => o.clientNameSnapshot == clientFilter.value)
          .toList();
    }


    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase().trim();
      list = list.where((o) {
        return o.id.toLowerCase().contains(q) ||                // ✅ add
            o.orderNumber.toLowerCase().contains(q) ||
            o.clientNameSnapshot.toLowerCase().contains(q);
      }).toList();
    }



//
//     ======================
// DATE FILTER (optional)
// ======================
    final now = DateTime.now();

    bool isSameDay(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;

    if (dateFilter.value != 'all') {
      list = list.where((o) {
        final d = o.expectedDeliveryDate;
        if (d == null) return false;

        switch (dateFilter.value) {
          case 'today':
            return isSameDay(d, now);

          case 'tomorrow':
            final t = now.add(const Duration(days: 1));
            return isSameDay(d, t);

          case 'next_7':
            final end = now.add(const Duration(days: 7));
            return d.isAfter(now.subtract(const Duration(days: 1))) &&
                d.isBefore(end.add(const Duration(days: 1)));

          case 'custom':
            if (customStartDate == null || customEndDate == null) return true;
            return d.isAfter(customStartDate!) &&
                d.isBefore(customEndDate!.add(const Duration(days: 1)));

          default:
            return true;
        }
      }).toList();
    }



    //
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

    // keep TextField in sync if text is set programmatically
    if (searchCtrl.text != v) {
      searchCtrl.value = searchCtrl.value.copyWith(
        text: v,
        selection: TextSelection.collapsed(offset: v.length),
        composing: TextRange.empty,
      );
    }

    if (forceShowAllStatuses.value && v.trim().isEmpty) {
      forceShowAllStatuses.value = false;
    }
  }

  void setDateFilter(String v) {
    dateFilter.value = v;
  }
  void setSortMode(OrderSortMode mode) {
    sortMode.value = mode;
  }
  void focusOrderById(String orderId) {
    // show even completed/cancelled while focusing
    forceShowAllStatuses.value = true;

    // clear other filters that might hide it
    clientFilter.value = 'all';
    dateFilter.value = 'all';

    // search by id
    setSearch(orderId);

    // optional: select it if already present in list
    final match = allOrders.firstWhereOrNull((o) => o.id == orderId);
    if (match != null) {
      selectOrder(match);
    }
  }

  void clearFocusAndShowOpenOrders() {
    forceShowAllStatuses.value = false;
    setSearch('');
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
