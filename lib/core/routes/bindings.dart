import 'package:get/get.dart';

import '../controllers/app_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Example: Auth, API, Storage
    // Get.put(ApiService());
    Get.put(AppController(), permanent: true);
  }
}