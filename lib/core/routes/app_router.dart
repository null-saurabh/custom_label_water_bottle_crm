import 'package:clwb_crm/screens/client/client_controller.dart';
import 'package:clwb_crm/screens/client/client_split_screen.dart';
import 'package:clwb_crm/screens/dashboard/dashboard_screen.dart';
import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/inventory_screen.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_item_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_stocks_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/supplier_repo.dart';
import 'package:get/get.dart';

import '../../screens/dashboard/dashboard_controller.dart';
import '../../screens/leads/leads_controller.dart';
import '../../screens/leads/leads_screen.dart';
import '../layouts/shell_screen.dart';


abstract class AppRoutes {

  static const shell = '/';
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const inventory = '/inventory';
  static const orders = '/orders';
  static const leads = '/leads';
  static const clients = '/clients';
}




class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.shell,
      page: () => const ShellView(),
      participatesInRootNavigator: true,
      children: [
        GetPage(
          name: AppRoutes.dashboard,
          page: () => DashboardScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => DashboardController());
          }),
        ),

        GetPage(
          name: AppRoutes.leads,
          page: () => const LeadsView(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => LeadsController());
          }),
        ),

        GetPage(
          name: AppRoutes.clients,
          page: () => const ClientsSplitScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => ClientsController());
          }),
        ),


        GetPage(
          name: AppRoutes.inventory,
          page: () => InventoryScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => InventoryController(
              itemRepo: InventoryItemRepository(),
              supplierRepo: SupplierRepository(),
              stockRepo: InventoryStockRepository(),
            ),);
          }),
        ),
        // more pages...
      ],
    ),
  ];
}



