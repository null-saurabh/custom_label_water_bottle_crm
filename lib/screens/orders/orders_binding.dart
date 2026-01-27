import 'package:clwb_crm/screens/client/client_controller.dart';
import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/orders/dialog/controller/add_order_controller.dart';
import 'package:clwb_crm/screens/orders/order_controller.dart';
import 'package:clwb_crm/screens/orders/repo/order_activity_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_delivery_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_expense_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_material_dispatch_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_production_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_repo.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/order_detail_controller.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/widgets/overview_tab/over_detail_tab_controller.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/widgets/production_tab/controllers/order_delivery_controller.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/widgets/production_tab/controllers/order_material_dispatch_controller.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/widgets/production_tab/order_production_controller.dart';
import 'package:get/get.dart';

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OrdersRepository());
    Get.put(OrderMaterialDispatchRepository());
    Get.put(OrderProductionRepository());
    Get.put(OrderDeliveryRepository());
    Get.put(OrderExpenseRepository());
    Get.put(OrderActivityRepository());

    Get.put(OrdersController(Get.find()),permanent: true);
    Get.put(OrderDetailController(Get.find()));
    Get.put(OrderDetailTabsController(), permanent: true);





    Get.lazyPut(
          () => AddOrderController(
        Get.find<OrdersRepository>(),
        Get.find<ClientsController>(),
        Get.find<InventoryController>(),
        Get.find<OrderExpenseRepository>(),
        Get.find<OrderActivityRepository>()
      ),
      fenix: true,
    );

    Get.lazyPut(
          () => MaterialDispatchController(
        Get.find<OrderMaterialDispatchRepository>(),
        Get.find<OrdersRepository>(),
        Get.find<InventoryController>(),
        Get.find<OrderExpenseRepository>(),
        Get.find<OrderActivityRepository>()
      ),
    );


    Get.put( ProductionController(
              Get.find<OrderProductionRepository>(),
              Get.find<OrderDeliveryRepository>(),
              Get.find<OrdersRepository>(),
              Get.find<OrderExpenseRepository>(),
              Get.find<OrderActivityRepository>(),

      ),
    );

    Get.lazyPut(
          () => DeliveryController(
              Get.find<OrderDeliveryRepository>(),
              Get.find<OrdersRepository>(),
              Get.find<OrderActivityRepository>()
      ),
    );
  }
}
