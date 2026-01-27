import 'package:clwb_crm/screens/client/client_controller.dart';
import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_item_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_stocks_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/supplier_item_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/supplier_repo.dart';
import 'package:clwb_crm/screens/orders/repo/order_repo.dart';
import 'package:get/get.dart';

import '../controllers/app_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppController(), permanent: true);
    Get.put(ClientsController(), permanent: true);

    // 🔥 MAKE INVENTORY GLOBAL
    Get.put(
      InventoryController(
        SupplierItemRepository(),
        OrdersRepository(),
        itemRepo: InventoryItemRepository(),
        supplierRepo: SupplierRepository(),
        stockRepo: InventoryStockRepository(),
      ),
      permanent: true,
    );
  }
}
