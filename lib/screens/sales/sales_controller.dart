import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/models/order_delivery_entry_model.dart';
import 'package:clwb_crm/screens/orders/repo/order_repo.dart';
import 'package:clwb_crm/screens/orders/repo/order_delivery_repository.dart';
import 'package:intl/intl.dart';
import 'package:clwb_crm/screens/orders/models/order_expense_model.dart';
import 'package:clwb_crm/screens/orders/repo/order_expense_repository.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

enum SalesRangePreset { thisMonth, last30Days, custom, all }
class SalesTrendPoint {
  final DateTime day;
  final double revenue;

  SalesTrendPoint({
    required this.day,
    required this.revenue,
  });
}

class SalesController extends GetxController {
  final OrdersRepository ordersRepo;
  final OrderDeliveryRepository deliveryRepo;
  final OrderExpenseRepository expenseRepo;

  SalesController(
      this.ordersRepo,
      this.deliveryRepo,
      this.expenseRepo,
      );

  // --------------------------------------------------
  // STREAMED DATA
  // --------------------------------------------------

  final orders = <OrderModel>[].obs;
  final deliveries = <OrderDeliveryEntryModel>[].obs;
  final expenses = <OrderExpenseModel>[].obs;

  StreamSubscription? _ordersSub;
  StreamSubscription? _deliverySub;
  StreamSubscription? _expenseSub;

  // --------------------------------------------------
  // DATE RANGE
  // --------------------------------------------------

  final preset = SalesRangePreset.thisMonth.obs;
  final customStart = Rxn<DateTime>();
  final customEnd = Rxn<DateTime>();

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  DateTimeRange get activeRange {
    final now = DateTime.now();

    switch (preset.value) {
      case SalesRangePreset.thisMonth:
        return DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: DateTime(now.year, now.month + 1, 0),
        );

      case SalesRangePreset.last30Days:
        final end = _dateOnly(now);
        return DateTimeRange(
          start: end.subtract(const Duration(days: 29)),
          end: end,
        );

      case SalesRangePreset.custom:
        return DateTimeRange(
          start: customStartDate ?? DateTime(now.year, now.month, 1),
          end: customEndDate ?? _dateOnly(now),
        );


      case SalesRangePreset.all:
        return DateTimeRange(
          start: DateTime(2020, 1, 1),
          end: _dateOnly(now),
        );
    }
  }

  bool _inRange(DateTime d) {
    final r = activeRange;
    final x = _dateOnly(d);
    return !x.isBefore(r.start) && !x.isAfter(r.end);
  }

  // --------------------------------------------------
  // LIFECYCLE
  // --------------------------------------------------

  @override
  void onInit() {
    super.onInit();

    _ordersSub =
        ordersRepo.watchAllOrders().listen(orders.assignAll);

    _deliverySub =
        deliveryRepo.watchAll().listen(deliveries.assignAll);

    _expenseSub =
        expenseRepo.ref.snapshots().map((s) =>
            s.docs.map((d) => OrderExpenseModel.fromDoc(d)).toList()
        ).listen(expenses.assignAll);
  }

  @override
  void onClose() {
    _ordersSub?.cancel();
    _deliverySub?.cancel();
    _expenseSub?.cancel();
    super.onClose();
  }

  // --------------------------------------------------
  // FILTERED DATA
  // --------------------------------------------------
  List<SalesTrendPoint> get trendPoints {
    final map = <DateTime, double>{};

    for (final d in deliveriesInRange) {
      final o = _orderById[d.orderId];
      if (o == null) continue;

      final day = DateTime(
        d.deliveryDate.year,
        d.deliveryDate.month,
        d.deliveryDate.day,
      );

      final revenue = d.quantityDeliveredToday * o.ratePerBottle;
      map[day] = (map[day] ?? 0) + revenue;
    }

    final points = map.entries
        .map((e) => SalesTrendPoint(day: e.key, revenue: e.value))
        .toList()
      ..sort((a, b) => a.day.compareTo(b.day));

    return points;
  }


  Map<String, double> get revenueByItem {
    final map = <String, double>{};

    for (final d in deliveriesInRange) {
      final o = _orderById[d.orderId];
      if (o == null) continue;

      final revenue = d.quantityDeliveredToday * o.ratePerBottle;
      map[o.itemId] = (map[o.itemId] ?? 0) + revenue;
    }

    return map;
  }
  String itemName(String itemId) {
    return orders
        .firstWhereOrNull((o) => o.itemId == itemId)
        ?.itemNameSnapshot
        ?? 'Unknown Item';
  }

  List<OrderDeliveryEntryModel> get deliveriesInRange =>
      deliveries.where((d) => _inRange(d.deliveryDate)).toList();

  List<OrderExpenseModel> get expensesInRange =>
      expenses.where((e) => _inRange(e.expenseDate)).toList();

  Map<String, OrderModel> get _orderById =>
      {for (final o in orders) o.id: o};

  // --------------------------------------------------
  // REVENUE
  // --------------------------------------------------

  double get revenue {
    double total = 0;

    for (final d in deliveriesInRange) {
      final o = _orderById[d.orderId];
      if (o == null) continue;

      total += d.quantityDeliveredToday * o.ratePerBottle;
    }
    return total;
  }

  // --------------------------------------------------
  // COGS (🔥 authoritative)
  // --------------------------------------------------

  double get cogs {
    return expensesInRange
        .where((e) => e.category == 'cogs_inventory')
        .fold(0, (s, e) => s + e.amount);
  }

  // --------------------------------------------------
  // OPERATING EXPENSES (excluding COGS)
  // --------------------------------------------------

  double get operatingExpenses {
    return expensesInRange
        .where((e) =>
    e.direction == 'out' &&
        e.category != 'cogs_inventory')
        .fold(0, (s, e) => s + e.amount);
  }

  // --------------------------------------------------
  // PAYMENTS / CASH FLOW
  // --------------------------------------------------

  double get cashIn {
    return expensesInRange
        .where((e) => e.direction == 'in')
        .fold(0, (s, e) => s + e.amount);
  }

  double get cashOut {
    return expensesInRange
        .where((e) => e.direction == 'out')
        .fold(0, (s, e) => s + e.paidAmount);
  }

  // --------------------------------------------------
  // PROFIT
  // --------------------------------------------------

  double get grossProfit => revenue - cogs;

  double get netProfit => revenue - cogs - operatingExpenses;

  double get profitMarginPct =>
      revenue <= 0 ? 0 : (netProfit / revenue) * 100;

  // --------------------------------------------------
  // GROUPING (for tables / rankings)
  // --------------------------------------------------

  Map<String, double> get revenueByClient {
    final map = <String, double>{};

    for (final d in deliveriesInRange) {
      final o = _orderById[d.orderId];
      if (o == null) continue;

      final v = d.quantityDeliveredToday * o.ratePerBottle;
      map[o.clientNameSnapshot] =
          (map[o.clientNameSnapshot] ?? 0) + v;
    }
    return map;
  }

  Map<String, double> get revenueByOrder {
    final map = <String, double>{};

    for (final d in deliveriesInRange) {
      final o = _orderById[d.orderId];
      if (o == null) continue;

      final v = d.quantityDeliveredToday * o.ratePerBottle;
      map[o.id] = (map[o.id] ?? 0) + v;
    }
    return map;
  }

  // --------------------------------------------------
  // UI HELPERS
  // --------------------------------------------------

  String get rangeLabel {
    final f = DateFormat('dd MMM yyyy');
    final r = activeRange;

    switch (preset.value) {
      case SalesRangePreset.thisMonth:
        return 'This Month';
      case SalesRangePreset.last30Days:
        return 'Last 30 Days';
      case SalesRangePreset.custom:
        return '${f.format(r.start)} → ${f.format(r.end)}';
      case SalesRangePreset.all:
        return 'All Time';
    }
  }

  void setPreset(SalesRangePreset p) {
    preset.value = p;
  }

  void setCustomRange(DateTime s, DateTime e) {
    customStart.value = _dateOnly(s);
    customEnd.value = _dateOnly(e);
    preset.value = SalesRangePreset.custom;
  }



  // ---- Custom range (same pattern as OrdersController) ----
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
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
                        initialSelectedRange:
                        (pickedStart != null && pickedEnd != null)
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F4FA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _rangeLabel(pickedStart, pickedEnd),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF374151),
                            ),
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
    );

    if (result == true && pickedStart != null && pickedEnd != null) {
      customStartDate =
          DateTime(pickedStart!.year, pickedStart!.month, pickedStart!.day);
      customEndDate =
          DateTime(pickedEnd!.year, pickedEnd!.month, pickedEnd!.day);

      preset.value = SalesRangePreset.custom;
    }
  }


  String _rangeLabel(DateTime? s, DateTime? e) {
    if (s == null || e == null) return 'No range selected';
    final f = DateFormat('dd MMM yyyy');
    return '${f.format(s)}  →  ${f.format(e)}';
  }


}












































