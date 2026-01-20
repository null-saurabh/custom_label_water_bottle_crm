// lib/features/dashboard/dashboard_controller.dart
import 'dart:ui';

import 'package:clwb_crm/screens/dashboard/dashboard_controller.dart';
import 'package:clwb_crm/screens/dashboard/widgets/inventory_warning_card/inventory_warning_model.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {

  // lib/features/dashboard/dashboard_controller.dart (ADD THESE)
  final totalBottles = 12450.obs;
  final newOrdersCount = 580.obs;
  final weeklySalesAmount = 8920.0.obs;
  final newLeadsCount = 24.obs;
  final lowStockSkuCount = 6.obs;
  final ordersDueToday = 4.obs;
  final ordersDueThisWeek = 17.obs;


// Due Delivery Today CArd
  final dueDeliveriesToday = <DueDeliveryToday>[
    DueDeliveryToday(
      client: 'The Green Garden',
      quantity: 350,
      timeLabel: '10:00 AM',
      completed: false,
    ),
    DueDeliveryToday(
      client: 'Hotel LuxStay',
      quantity: 500,
      timeLabel: '11:30 AM',
      completed: false,
    ),
    DueDeliveryToday(
      client: 'Sunrise Eatery',
      quantity: 300,
      timeLabel: '1:00 PM',
      completed: false,
    ),
    DueDeliveryToday(
      client: 'Elite Dine',
      quantity: 450,
      timeLabel: '',
      completed: true,
    ),
  ].obs;



  // ✅ DASHBOARD CONTROLLER DATA


  final dueNextWeek = <DueNextWeek>[
  DueNextWeek(
  client: 'Ocean Breeze',
  quantity: 1200,
  dayLabel: 'Monday',
  dayBg: const Color(0xFFE8F5E9),
  dayText: const Color(0xFF388E3C),
  ),
  DueNextWeek(
  client: 'Royal Palms Hotel',
  quantity: 1200,
  dayLabel: 'Tuesday',
  dayBg: const Color(0xFFE3F2FD),
  dayText: const Color(0xFF1E88E5),
  ),
  DueNextWeek(
  client: 'Metropolitan Café',
  quantity: 1200,
  dayLabel: 'Wednesday',
  dayBg: const Color(0xFFE0F2F1),
  dayText: const Color(0xFF00796B),
  ),
  DueNextWeek(
  client: 'Golden Spoon',
  quantity: 1200,
  dayLabel: 'Thursday',
  dayBg: const Color(0xFFFFF3E0),
  dayText: const Color(0xFFF57C00),
  ),
  ].obs;





  //week order

// ✅ DASHBOARD CONTROLLER DATA (FUNCTIONALLY CORRECT)
  final weeklyStandingOrders = <StandingOrderSummary>[
    StandingOrderSummary(
      client: 'Hotel Luxtay',
      cycle: RecurringCycle.weekly,
      committedQty: 500,
      fulfilledQty: 250,
      isActive: true,
    ),

    StandingOrderSummary(
      client: 'Bella Cucina',
      cycle: RecurringCycle.monthly,
      committedQty: 300,
      fulfilledQty: 400,
      isActive: true,
    ),
  ].obs;



  // inventory warning
// lib/features/dashboard/dashboard_controller.dart (ADD)



  final inventoryWarnings = <InventoryWarning>[
  InventoryWarning(
  displayName: 'Round Bottle',
  sizeCode: '500 ML',
  due: 1200,
  stock: 900,isBottle: true

  ),
  InventoryWarning(
  displayName: 'Round Bottle',
  sizeCode: '1L',
  due: 800,
  stock: 600,isBottle: true,
  ),InventoryWarning(
  displayName: 'Square Bottle',
  sizeCode: '1L',
  due: 800,
  stock: 600,isBottle: false,
  ),
  InventoryWarning(
  displayName: 'Hotel Luxtay Label',
  sizeCode: '1L',
  due: 450,
  stock: 150,isBottle: false,
  ),
  InventoryWarning(
  displayName: 'Elite Dine Label',
  sizeCode: '500 ML',
  due: 400,isBottle: false,
  stock: 250,
  ),
  InventoryWarning(
  displayName: 'Ocean Breeze Label',
  sizeCode: '500 ML',
  due: 300,isBottle: false,
  stock: 120,
  ),
  InventoryWarning(
  displayName: 'Cafe Venezia Label',
  sizeCode: 'L',
  due: 350,
  stock: 200, isBottle: false,
  ),
  ].obs;

  int get totalInventoryDue =>
  inventoryWarnings.fold(0, (s, e) => s + e.due);

  int get totalInventoryStock =>
  inventoryWarnings.fold(0, (s, e) => s + e.stock);

  int get totalInventoryShortfall =>
  inventoryWarnings.fold(0, (s, e) => s + e.shortfall);



  // gragh card
// lib/features/dashboard/dashboard_controller.dart (ADD)


  int get maxWeeklyTotal {
    return weeklyBars
        .map((e) => e.delivered + e.scheduled)
        .fold(0, (a, b) => a > b ? a : b);
  }


  final weekDelivered = 350.obs;
  final weekScheduled = 900.obs;
  final weekNewOrders = 1250.obs;

  final weeklyBars = <WeeklyBarData>[
  WeeklyBarData(day: 'Mon', delivered: 40, scheduled: 30, ),
  WeeklyBarData(day: 'Tue', delivered: 50, scheduled: 20, ),
  WeeklyBarData(day: 'Wed', delivered: 60, scheduled: 40, ),
  WeeklyBarData(day: 'Thu', delivered: 70, scheduled: 50, ),
  WeeklyBarData(day: 'Fri', delivered: 60, scheduled: 120, ),
  WeeklyBarData(day: 'Sat', delivered: 80, scheduled: 60, ),
  WeeklyBarData(day: 'Sun', delivered: 90, scheduled: 80, ),
  ].obs;

}





// ✅ DOMAIN MODEL (NOT UI-BASED, FUNCTIONAL MEANING FIXED)
enum RecurringCycle { weekly, monthly }



class WeeklyBarData {
  final String day;
  final int delivered;
  final int scheduled;

  WeeklyBarData({
    required this.day,
    required this.delivered,
    required this.scheduled,
  });
}



class StandingOrderSummary {
  final String client;
  final RecurringCycle cycle; // 🔥 weekly / monthly
  final int committedQty;     // total expected for the cycle
  final int fulfilledQty;     // shipped so far
  final bool isActive;

  StandingOrderSummary({
    required this.client,
    required this.cycle,
    required this.committedQty,
    required this.fulfilledQty,
    required this.isActive,
  });
}


class DueNextWeek {
  final String client;
  final int quantity;
  final String dayLabel;
  final Color dayBg;
  final Color dayText;

  DueNextWeek({
    required this.client,
    required this.quantity,
    required this.dayLabel,
    required this.dayBg,
    required this.dayText,
  });
}
class DueDeliveryToday {
  final String client;
  final int quantity;
  final String timeLabel;
  final bool completed;

  DueDeliveryToday({
    required this.client,
    required this.quantity,
    required this.timeLabel,
    required this.completed,
  });
}


