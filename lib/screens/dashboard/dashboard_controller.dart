// lib/features/dashboard/dashboard_controller.dart
import 'package:clwb_crm/core/models/sku_model.dart';
import 'package:get/get.dart';
import '../inventory/models/label_inventory.dart';

class DashboardController extends GetxController {
  final skus = <SkuModel>[].obs;
  final labelInventory = <LabelInventory>[].obs;

  final ordersDueToday = 0.obs;
  final ordersDueWeek = 0.obs;
  final productionLoadToday = 0.obs;
  final outstandingPayments = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  void loadDashboardData() {
    // Firestore fetch hooks (real implementation)
    ordersDueToday.value = 5;
    ordersDueWeek.value = 18;
    productionLoadToday.value = 3200;
    outstandingPayments.value = 184500;
  }

  int availableLabelsForSku(String skuId) {
    return labelInventory
        .firstWhere((e) => e.skuId == skuId)
        .available;
  }
}
