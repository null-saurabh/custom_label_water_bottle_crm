// lib/features/dashboard/dashboard_controller.dart
import 'dart:ui';

import 'package:get/get.dart';

class DashboardController extends GetxController {

  // lib/features/dashboard/dashboard_controller.dart (ADD THESE)
  final totalBottles = 12450.obs;
  final newOrdersCount = 8.obs;
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

// ✅ DOMAIN MODEL (NOT UI-BASED, FUNCTIONAL MEANING FIXED)
enum RecurringCycle { weekly, monthly }

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



