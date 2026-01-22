import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../routes/app_router.dart';

class AppController extends GetxController {


  // App Side Bar

  final selectedMenu = SidebarMenu.dashboard.obs;

  void selectMenu(SidebarMenu menu) {


    if (selectedMenu.value == menu) return;

    selectedMenu.value = menu;

    Get.rootDelegate.toNamed(menu.route); // ✅ FIX
    //
    // selectedMenu.value = menu;
    // Get.rootDelegate.offNamed(
    //   menu.route,
    // );

  }



  // Dashboard Header
  final userName = 'John'.obs;

  String get todayFormatted =>
      DateFormat('EEEE, MMMM d').format(DateTime.now());

}

enum SidebarMenu {
  dashboard,
  orders,
  deliveries,
  clients,
  leads,
  inventory,
  sales,
}

extension SidebarMenuRoute on SidebarMenu {
  String get route {
    switch (this) {
      case SidebarMenu.dashboard:
        return AppRoutes.dashboard;
      case SidebarMenu.orders:
        return AppRoutes.orders;
      case SidebarMenu.deliveries:
        return AppRoutes.dashboard;
      case SidebarMenu.clients:
        return AppRoutes.clients;
      case SidebarMenu.leads:
        return AppRoutes.leads;
      case SidebarMenu.inventory:
        return AppRoutes.inventory;
      case SidebarMenu.sales:
        return AppRoutes.dashboard;
    }
  }
}







