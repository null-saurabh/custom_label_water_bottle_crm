import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/dashboard/dashboard_controller.dart';
import 'package:clwb_crm/screens/dashboard/repo/dashboard_repo.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardRepository(FirebaseFirestore.instance), fenix: true);
    Get.put(DashboardController(Get.find()));
  }
}
