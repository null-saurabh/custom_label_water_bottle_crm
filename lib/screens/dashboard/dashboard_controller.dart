// lib/features/dashboard/dashboard_controller.dart
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


  // @override
  // void onInit() {
  //   super.onInit();
  // }


}
