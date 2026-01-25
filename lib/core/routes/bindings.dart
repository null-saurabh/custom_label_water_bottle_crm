import 'package:clwb_crm/screens/client/client_controller.dart';
import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:get/get.dart';

import '../controllers/app_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Example: Auth, API, Storage
    // Get.put(ApiService());
    Get.put(AppController(), permanent: true);
    Get.put(ClientsController(), permanent: true);
  }
}