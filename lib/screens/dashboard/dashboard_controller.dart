import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/models/order_delivery_entry_model.dart';
import 'package:clwb_crm/screens/dashboard/repo/dashboard_repo.dart';
import 'package:clwb_crm/screens/dashboard/models.dart'; // DueDeliveryToday, DueNextWeek, WeeklyBarData, StandingOrderSummary, RecurringCycle

class DashboardController extends GetxController {
  final DashboardRepository repo;
  DashboardController(this.repo);

  // =========================
  // OUTPUT (used by widgets)
  // =========================
  final dueDeliveriesToday = <DueDeliveryToday>[].obs;   // day view
  final dueNextWeek = <DueNextWeek>[].obs;              // week view
  final weeklyStandingOrders = <StandingOrderSummary>[].obs;

  final weekDelivered = 0.obs;   // distinct orders delivered (any delivery entry) in ordersWeek
  final weekScheduled = 0.obs;   // orders due in ordersWeek
  final weekNewOrders = 0.obs;   // orders created in ordersWeek

  final weeklyBars = <WeeklyBarData>[].obs;
  int get maxWeeklyTotal =>
      weeklyBars.fold<int>(0, (m, e) => (e.delivered + e.scheduled) > m ? (e.delivered + e.scheduled) : m);

  // Optional: bar labels for showing number on top of bars in UI
  // (You can use b.delivered + b.scheduled, or show delivered/scheduled separately)
  int barTotal(WeeklyBarData b) => b.delivered + b.scheduled;

  // =========================
  // PAGING STATE (independent)
  // =========================
  final selectedDay = DateTime.now().obs;                 // DueDeliveriesToday pager
  final selectedDueWeekAnchor = DateTime.now().obs;       // DueNextWeek pager
  final selectedOrdersWeekAnchor = DateTime.now().obs;    // OrdersThisWeek pager

  void prevDay() => selectedDay.value = selectedDay.value.subtract(const Duration(days: 1));
  void nextDay() => selectedDay.value = selectedDay.value.add(const Duration(days: 1));

  void prevDueWeek() => selectedDueWeekAnchor.value = selectedDueWeekAnchor.value.subtract(const Duration(days: 7));
  void nextDueWeek() => selectedDueWeekAnchor.value = selectedDueWeekAnchor.value.add(const Duration(days: 7));

  void prevOrdersWeek() => selectedOrdersWeekAnchor.value = selectedOrdersWeekAnchor.value.subtract(const Duration(days: 7));
  void nextOrdersWeek() => selectedOrdersWeekAnchor.value = selectedOrdersWeekAnchor.value.add(const Duration(days: 7));

  void resetToToday() {
    final now = DateTime.now();
    selectedDay.value = now;
    selectedDueWeekAnchor.value = now;
    selectedOrdersWeekAnchor.value = now;
  }

  // Labels (for pagers)
  String get selectedDayLabel {
    final diff = _dayDiffFromToday(selectedDay.value);
    if (diff == -1) return 'Yesterday';
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    return _fmtDdMmm(selectedDay.value);
  }

  String get dueWeekLabel => _weekSmartLabel(selectedDueWeekAnchor.value);
  String get ordersWeekLabel => _weekSmartLabel(selectedOrdersWeekAnchor.value);

  // =========================
  // INTERNAL CACHES
  // =========================
// Orders due for each widget scope (independent)
  final _ordersDueDay = <OrderModel>[].obs;         // for DueDeliveriesToday
  final _ordersDueDueWeek = <OrderModel>[].obs;     // for DueNextWeek
  final _ordersDueOrdersWeek = <OrderModel>[].obs;  // for OrdersThisWeek scheduled

// Orders created in orders week (OrdersThisWeek)
  final _ordersCreatedWeek = <OrderModel>[].obs;

// Deliveries
  final _deliveriesOrdersWeek = <OrderDeliveryEntryModel>[].obs;
  final _deliveriesSelectedDay = <OrderDeliveryEntryModel>[].obs;


  StreamSubscription? _subOrdersDueDay;
  StreamSubscription? _subOrdersDueDueWeek;
  StreamSubscription? _subOrdersDueOrdersWeek;

  StreamSubscription? _subOrdersCreatedWeek;
  StreamSubscription? _subRecurring;
  StreamSubscription? _subDeliveriesOrdersWeek;
  StreamSubscription? _subDeliveriesSelectedDay;



  Worker? _pagingWorker;
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();

    // Rebind streams when pagers change
    _pagingWorker = everAll(
      [selectedDay, selectedDueWeekAnchor, selectedOrdersWeekAnchor],
          (_) => _bindStreams(),
    );

    _bindStreams(); // initial
  }

  void _bindStreams() {
    _subOrdersDueDay?.cancel();
    _subOrdersDueDueWeek?.cancel();
    _subOrdersDueOrdersWeek?.cancel();

    _subOrdersCreatedWeek?.cancel();
    _subRecurring?.cancel();
    _subDeliveriesOrdersWeek?.cancel();
    _subDeliveriesSelectedDay?.cancel();

    final day = _dayRange(selectedDay.value);
    final dueWeek = _weekRangeFromAnchor(selectedDueWeekAnchor.value);
    final ordersWeek = _weekRangeFromAnchor(selectedOrdersWeekAnchor.value);

    // 1) Orders due on selected day (ONLY for DueDeliveriesToday)
    _subOrdersDueDay = repo
        .watchOrdersDueBetween(start: day.start, end: day.end)
        .listen((list) {
      _ordersDueDay.assignAll(list);
      _recomputeDebounced(day: day, dueWeek: dueWeek, ordersWeek: ordersWeek);
    });

    // 2) Orders due in selected due-week (ONLY for DueNextWeek)
    _subOrdersDueDueWeek = repo
        .watchOrdersDueBetween(start: dueWeek.start, end: dueWeek.end)
        .listen((list) {
      _ordersDueDueWeek.assignAll(list);
      _recomputeDebounced(day: day, dueWeek: dueWeek, ordersWeek: ordersWeek);
    });

    // 3) Orders due in selected orders-week (ONLY for OrdersThisWeek scheduled)
    _subOrdersDueOrdersWeek = repo
        .watchOrdersDueBetween(start: ordersWeek.start, end: ordersWeek.end)
        .listen((list) {
      _ordersDueOrdersWeek.assignAll(list);
      _recomputeDebounced(day: day, dueWeek: dueWeek, ordersWeek: ordersWeek);
    });

    // 4) Orders CREATED in selected orders-week
    _subOrdersCreatedWeek = repo
        .watchOrdersCreatedBetween(start: ordersWeek.start, end: ordersWeek.end)
        .listen((list) {
      _ordersCreatedWeek.assignAll(list);
      _recomputeDebounced(day: day, dueWeek: dueWeek, ordersWeek: ordersWeek);
    });

    // 5) Recurring orders (not paged)
    _subRecurring = repo.watchRecurringOrders().listen((list) {
      final mapped = list.map(_mapRecurringSummary).toList()
        ..sort((a, b) => a.client.compareTo(b.client));
      weeklyStandingOrders.assignAll(mapped);
    });

    // 6) Deliveries in selected orders-week (bars + delivered stat)
    _subDeliveriesOrdersWeek = repo
        .watchDeliveriesBetween(start: ordersWeek.start, end: ordersWeek.end)
        .listen((list) {
      _deliveriesOrdersWeek.assignAll(list);
      _recomputeDebounced(day: day, dueWeek: dueWeek, ordersWeek: ordersWeek);
    });

    // 7) Deliveries in selected day (chip "Completed" signal)
    _subDeliveriesSelectedDay = repo
        .watchDeliveriesBetween(start: day.start, end: day.end)
        .listen((list) {
      _deliveriesSelectedDay.assignAll(list);
      _recomputeDebounced(day: day, dueWeek: dueWeek, ordersWeek: ordersWeek);
    });
  }


  void _recomputeDebounced({
    required DateSpan day,
    required DateSpan dueWeek,
    required DateSpan ordersWeek,
  }) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 120), () {
      _recompute(day: day, dueWeek: dueWeek, ordersWeek: ordersWeek);
    });
  }



  void _recompute({
    required DateSpan day,
    required DateSpan dueWeek,
    required DateSpan ordersWeek,
  }) {
    // =========================
    // 1) DueDeliveriesTodayCard
    // =========================

    final dueTodayOrders = _ordersDueDay.where((o) {
      if (o.isActive == false) return false;
      if (o.orderStatus == 'cancelled') return false;
      // repo query already narrowed by due date, but keep safe:
      return _inSpan(_dueDateOf(o), day);
    }).toList()
      ..sort((a, b) => (_dueDateOf(a) ?? DateTime(2100)).compareTo(_dueDateOf(b) ?? DateTime(2100)));

    final dueTodayById = {for (final o in dueTodayOrders) o.id: o};

    // Completed today (only relevant for orders shown today)
    final completedTodayIds = <String>{};
    for (final e in _deliveriesSelectedDay) {
      final o = dueTodayById[e.orderId];
      if (o == null) continue;
      if (e.cumulativeDelivered >= o.orderedQuantity) {
        completedTodayIds.add(o.id);
      }
    }

    dueDeliveriesToday.assignAll(
      dueTodayOrders.take(8).map((o) {
        final completed =
            o.orderStatus == 'completed' ||
                o.remainingQuantity <= 0 ||
                completedTodayIds.contains(o.id);

        return DueDeliveryToday(
          client: o.clientNameSnapshot,
          quantity: completed ? o.orderedQuantity : o.remainingQuantity,
          timeLabel: _formatTimeOrEmpty(_dueDateOf(o)),
          completed: completed,
        );
      }).toList(),
    );

    // =========================
    // 2) DueNextWeekCard (selected due week)
    // =========================

    final dueWeekOrders = _ordersDueDueWeek.where((o) {
      if (o.isActive == false) return false;
      if (o.orderStatus == 'cancelled') return false;
      if (o.remainingQuantity <= 0) return false;
      return _inSpan(_dueDateOf(o), dueWeek);
    }).toList()
      ..sort((a, b) => (_dueDateOf(a) ?? DateTime(2100)).compareTo(_dueDateOf(b) ?? DateTime(2100)));

    dueNextWeek.assignAll(
      dueWeekOrders.take(8).map((o) {
        final due = _dueDateOf(o);
        final weekday = due == null ? '' : _weekdayLabel(due);
        final style = _weekdayChipStyle(weekday);

        return DueNextWeek(
          client: o.clientNameSnapshot,
          quantity: o.remainingQuantity,
          dayLabel: weekday,
          dayBg: style.bg,
          dayText: style.fg,
        );
      }).toList(),
    );

    // =========================
    // 3) OrdersThisWeekCard (selected orders week)
    // =========================

    weekNewOrders.value = _ordersCreatedWeek.length;

    final scheduledOrdersWeek = _ordersDueOrdersWeek.where((o) {
      if (o.isActive == false) return false;
      if (o.orderStatus == 'cancelled') return false;
      if (o.remainingQuantity <= 0) return false;
      return _inSpan(_dueDateOf(o), ordersWeek);
    }).toList();

    weekScheduled.value = scheduledOrdersWeek.length;

    final deliveredOrderIdsWeek = _deliveriesOrdersWeek.map((e) => e.orderId).toSet();
    weekDelivered.value = deliveredOrderIdsWeek.length;

    weeklyBars.assignAll(_computeWeeklyBars(ordersWeek, scheduledOrdersWeek));
  }









  // Bars: counts per day in the selected orders week
  List<WeeklyBarData> _computeWeeklyBars(DateSpan week, List<OrderModel> scheduledOrdersWeek) {
    final days = _daysInSpan(week);

    // deliveries grouped by day -> set of orderIds delivered that day
    final deliveredByDay = <String, Set<String>>{};
    for (final e in _deliveriesOrdersWeek) {
      final key = _dayKey(e.deliveryDate);
      (deliveredByDay[key] ??= <String>{}).add(e.orderId);
    }

    return days.map((d) {
      final daySpan = _dayRange(d);
      final dayKey = _dayKey(d);

      final scheduled = scheduledOrdersWeek.where((o) => _inSpan(_dueDateOf(o), daySpan)).length;
      final delivered = deliveredByDay[dayKey]?.length ?? 0;

      return WeeklyBarData(
        day: _shortDay(d),
        delivered: delivered,
        scheduled: scheduled,
      );
    }).toList();
  }

  // =========================
  // RECURRING
  // =========================
  StandingOrderSummary _mapRecurringSummary(OrderModel o) {
    final d = (o.recurringIntervalDays ?? 0);

    final cycle =
    d <= 7 ? RecurringCycle.weekly
        : d <= 31 ? RecurringCycle.monthly
        : RecurringCycle.quarterly;

    return StandingOrderSummary(
      client: o.clientNameSnapshot,
      cycle: cycle,
      committedQty: o.orderedQuantity,      // ordered amount
      fulfilledQty: o.deliveredQuantity,    // delivered so far
      isActive: o.isActive,
    );
  }

  // Your rule: due date picks nextDeliveryDate first, else expectedDeliveryDate
  DateTime? _dueDateOf(OrderModel o) => o.nextDeliveryDate ?? o.expectedDeliveryDate;

  // =========================
  // HELPERS
  // =========================
  bool _inSpan(DateTime? dt, DateSpan r) {
    if (dt == null) return false;
    return !dt.isBefore(r.start) && dt.isBefore(r.end); // end exclusive
  }

  String _formatTimeOrEmpty(DateTime? dt) {
    if (dt == null) return '';
    if (dt.hour == 0 && dt.minute == 0) return ''; // date-only: hide 12:00 AM
    final h = dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final suffix = h >= 12 ? 'PM' : 'AM';
    final hour12 = (h % 12 == 0) ? 12 : (h % 12);
    return '$hour12:$m $suffix';
  }

  String _weekdayLabel(DateTime dt) {
    const names = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
    return names[dt.weekday - 1];
  }

  String _shortDay(DateTime dt) {
    const s = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    return s[dt.weekday - 1];
  }

  String _dayKey(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2,'0')}-${dt.day.toString().padLeft(2,'0')}';

  List<DateTime> _daysInSpan(DateSpan r) {
    final days = <DateTime>[];
    var d = r.start;
    while (d.isBefore(r.end)) {
      days.add(d);
      d = d.add(const Duration(days: 1));
    }
    return days;
  }

  ChipStyle _weekdayChipStyle(String weekday) {
    switch (weekday) {
      case 'Monday': return ChipStyle(const Color(0xFFE8F5E9), const Color(0xFF388E3C));
      case 'Tuesday': return ChipStyle(const Color(0xFFE3F2FD), const Color(0xFF1E88E5));
      case 'Wednesday': return ChipStyle(const Color(0xFFE0F2F1), const Color(0xFF00796B));
      case 'Thursday': return ChipStyle(const Color(0xFFFFF3E0), const Color(0xFFF57C00));
      default: return ChipStyle(const Color(0xFFF1F4FA), const Color(0xFF374151));
    }
  }

  // =========================
  // SMART LABELS
  // =========================
  String _weekSmartLabel(DateTime anchor) {
    final diff = _weekDiffFromThisWeek(anchor);
    if (diff == -1) return 'Last Week';
    if (diff == 0) return 'This Week';
    if (diff == 1) return 'Next Week';

    final r = _weekRangeFromAnchor(anchor);
    return _fmtWeekRange(r.start, r.end);
  }

  int _weekDiffFromThisWeek(DateTime anchor) {
    final thisStart = _weekRangeFromAnchor(DateTime.now()).start;
    final start = _weekRangeFromAnchor(anchor).start;
    return start.difference(thisStart).inDays ~/ 7;
  }

  @override
  void onClose() {
    _pagingWorker?.dispose();
    _debounce?.cancel();
    _subOrdersDueDay?.cancel();
    _subOrdersDueDueWeek?.cancel();
    _subOrdersDueOrdersWeek?.cancel();
    _subOrdersCreatedWeek?.cancel();
    _subRecurring?.cancel();
    _subDeliveriesOrdersWeek?.cancel();
    _subDeliveriesSelectedDay?.cancel();
    super.onClose();
  }
}

// =========================
// SMALL SUPPORT TYPES
// =========================

class DateSpan {
  final DateTime start; // inclusive
  final DateTime end;   // exclusive
  const DateSpan(this.start, this.end);
}

class ChipStyle {
  final Color bg;
  final Color fg;
  const ChipStyle(this.bg, this.fg);
}

// Day span (00:00 → +1 day)
DateSpan _dayRange(DateTime dt) {
  final start = DateTime(dt.year, dt.month, dt.day);
  final end = start.add(const Duration(days: 1));
  return DateSpan(start, end);
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

// Week span (Mon 00:00 → next Mon 00:00)
DateSpan _weekRangeFromAnchor(DateTime anchor) {
  final a = _dateOnly(anchor);
  final start = a.subtract(Duration(days: a.weekday - 1));
  final end = start.add(const Duration(days: 7));
  return DateSpan(start, end);
}

int _dayDiffFromToday(DateTime d) {
  final today = _dateOnly(DateTime.now());
  final x = _dateOnly(d);
  return x.difference(today).inDays;
}

String _fmtDdMmm(DateTime d) {
  const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  final dd = d.day.toString().padLeft(2, '0');
  return '$dd ${m[d.month - 1]}';
}

String _fmtWeekRange(DateTime start, DateTime endExclusive) {
  final end = endExclusive.subtract(const Duration(days: 1));
  return '${_fmtDdMmm(start)} - ${_fmtDdMmm(end)}';
}
