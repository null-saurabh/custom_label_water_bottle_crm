import 'package:clwb_crm/screens/client/client_controller.dart';
import 'package:clwb_crm/screens/dashboard/global_search/global_search_controller.dart';
import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_activity_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_item_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_stocks_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/supplier_item_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/supplier_repo.dart';
import 'package:clwb_crm/screens/leads/leads_controller.dart';
import 'package:clwb_crm/screens/orders/order_controller.dart';
import 'package:clwb_crm/screens/orders/repo/order_activity_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_delivery_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_expense_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_material_dispatch_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_production_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_repo.dart';
import 'package:get/get.dart';

import '../controllers/app_controller.dart';


class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Repositories (GLOBAL)
    Get.put(OrdersRepository(), permanent: true);
    Get.put(OrderMaterialDispatchRepository(), permanent: true);
    Get.put(OrderProductionRepository(), permanent: true);
    Get.put(OrderDeliveryRepository(), permanent: true);
    Get.put(OrderExpenseRepository(), permanent: true);
    Get.put(OrderActivityRepository(), permanent: true);
    Get.put(InventoryActivityRepository(), permanent: true);

    // Core Controllers
    Get.put(AppController(), permanent: true);
    Get.put(ClientsController(), permanent: true);
    Get.put(LeadsController(), permanent: true);

    Get.put(
      InventoryController(
        SupplierItemRepository(),
        Get.find<OrdersRepository>(),
        itemRepo: InventoryItemRepository(),
        supplierRepo: SupplierRepository(),
        stockRepo: InventoryStockRepository(),
        activityRepo: Get.find<InventoryActivityRepository>(),
      ),
      permanent: true,
    );

    Get.put(
      OrdersController(
        Get.find<OrdersRepository>(),
      ),
      permanent: true,
    );
    // Global search (depends on the above)
    Get.lazyPut(() => GlobalSearchController(), fenix: true);
  }
}


