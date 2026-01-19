import 'package:clwb_crm/screens/dashboard/dashboard_screen.dart';
import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/inventory_screen.dart';
import 'package:get/get.dart';

import '../../screens/dashboard/dashboard_controller.dart';


abstract class AppRoutes {


  static const login = '/login';
  static const dashboard = '/dashboard';
  static const inventory = '/inventory';
  static const orders = '/orders';
}





class AppPages {
  static final pages = [
    // GetPage(
    //   name: AppRoutes.login,
    //   page: () => LoginView(),
    //   binding: BindingsBuilder(() {
    //     Get.put(AuthController());
    //   }),
    // ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => DashboardController());


      }),
    ),
    GetPage(
      name: AppRoutes.inventory,
      page: () => InventoryScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => InventoryController());
      }),
    ),
  ];
}
