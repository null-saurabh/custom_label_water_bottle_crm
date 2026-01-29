import 'dart:async';
import 'package:clwb_crm/screens/orders/repo/order_expense_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_repo.dart';
import 'package:get/get.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';

class ClientOrdersSummaryController extends GetxController {
  final String clientId;
  ClientOrdersSummaryController(this.clientId);

  final isLoading = true.obs;

  final orders = <OrderModel>[].obs;

  // computed stats
  final totalOrders = 0.obs;
  final deliveredOrders = 0.obs;
  final dueOrders = 0.obs;
  final outstanding = 0.0.obs;

  final Rxn<OrderModel> lastOrder = Rxn<OrderModel>();
  final Rxn<OrderModel> nextDeliveryOrder = Rxn<OrderModel>();

  StreamSubscription? _sub;

  final OrdersRepository _ordersRepo = Get.find<OrdersRepository>();


  final maxOverdueDays = 0.obs;
  final Rxn<OrderModel> mostOverdueOrder = Rxn<OrderModel>();

  final lastDeliveredMarginPct = RxnDouble(); // 🔥 margin of last delivered order
  final lastDeliveredProfit = RxnDouble();    // optional: show profit ₹
  final lastDeliveredRevenue = RxnDouble();   // optional: show revenue ₹
  final lastDeliveredCost = RxnDouble();      // optional: show cost ₹

  final OrderExpenseRepository _expenseRepo = OrderExpenseRepository();
  StreamSubscription? _lastDeliveredExpenseSub;

  /// Earned revenue per order (last N orders)
  final RxList<double> revenueTrend = <double>[].obs;



  @override
  void onInit() {
    super.onInit();

    _sub = _ordersRepo
        .watchOrdersByClient(clientId)
        .listen(_handleOrdersUpdate);
  }


  final List<double> fallbackRevenueTrend = [
    18000,
    22000,
    26000,
    21000,
    26000,
    29000,
  ];


  void _handleOrdersUpdate(List<OrderModel> list) {
    orders.assignAll(list);

    _computeBasicStats(list);
    _computeCreditRisk(list);
    _resolveLastAndNextOrders(list);
    _bindLastDeliveredOrderMargin(list);
    _computeRevenueTrend(list);

    isLoading.value = false;
  }

  void _computeBasicStats(List<OrderModel> list) {
    totalOrders.value = list.length;

    deliveredOrders.value = list.where((o) {
      final fullyDelivered = o.deliveredQuantity >= o.orderedQuantity;
      return o.orderStatus == 'completed' || fullyDelivered;
    }).length;

    dueOrders.value =
        list.where((o) => o.orderStatus != 'completed').length;

    outstanding.value = list.fold<double>(
      0,
          (s, o) => s + (o.dueAmount > 0 ? o.dueAmount : 0),
    );
  }


  void _computeCreditRisk(List<OrderModel> list) {
    final unpaid = list.where((o) {
      return o.dueAmount > 0 && o.orderStatus != 'completed';
    }).toList();

    if (unpaid.isEmpty) {
      maxOverdueDays.value = 0;
      mostOverdueOrder.value = null;
      return;
    }

    unpaid.sort((a, b) {
      final ad = DateTime.now().difference(a.createdAt).inDays;
      final bd = DateTime.now().difference(b.createdAt).inDays;
      return bd.compareTo(ad);
    });

    final worst = unpaid.first;
    mostOverdueOrder.value = worst;
    maxOverdueDays.value =
        DateTime.now().difference(worst.createdAt).inDays;
  }


  void _resolveLastAndNextOrders(List<OrderModel> list) {
    // Last completed order
    final completed = list
        .where((o) => o.orderStatus == 'completed')
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    lastOrder.value = completed.isEmpty ? null : completed.first;

    // Next delivery order
    final pending = list
        .where((o) => o.orderStatus != 'completed')
        .toList()
      ..sort((a, b) {
        final ad = a.expectedDeliveryDate;
        final bd = b.expectedDeliveryDate;
        if (ad == null && bd == null) return 0;
        if (ad == null) return 1;
        if (bd == null) return -1;
        return ad.compareTo(bd);
      });

    nextDeliveryOrder.value =
    pending.isEmpty ? null : pending.first;
  }

  void _bindLastDeliveredOrderMargin(List<OrderModel> list) {
    final delivered = list.where((o) {
      return o.orderStatus == 'completed' ||
          o.deliveredQuantity >= o.orderedQuantity;
    }).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final lastDelivered = delivered.isEmpty ? null : delivered.first;

    _lastDeliveredExpenseSub?.cancel();

    if (lastDelivered == null) {
      lastDeliveredMarginPct.value = null;
      lastDeliveredProfit.value = null;
      lastDeliveredRevenue.value = null;
      lastDeliveredCost.value = null;
      return;
    }

    _lastDeliveredExpenseSub =
        _expenseRepo.watchByOrder(lastDelivered.id).listen((exp) {
          final revenue =
              lastDelivered.deliveredQuantity *
                  lastDelivered.ratePerBottle;

          final cost = exp
              .where((e) => e.direction == 'out')
              .fold<double>(0, (s, e) => s + e.amount);

          final profit = revenue - cost;

          lastDeliveredRevenue.value = revenue;
          lastDeliveredCost.value = cost;
          lastDeliveredProfit.value = profit;

          lastDeliveredMarginPct.value =
          revenue <= 0 ? null : (profit / revenue) * 100;
        });
  }




  void _computeRevenueTrend(List<OrderModel> list) {
    // Sort by creation time (old → new)
    final sorted = [...list]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    // Take last 6 orders (or fewer)
    final recent = sorted.length > 6
        ? sorted.sublist(sorted.length - 6)
        : sorted;

    revenueTrend.assignAll(
      recent.map((o) =>
      o.deliveredQuantity * o.ratePerBottle
      ),
    );
  }



  @override
  void onClose() {
    _sub?.cancel();
    _lastDeliveredExpenseSub?.cancel();

    super.onClose();
  }
}
