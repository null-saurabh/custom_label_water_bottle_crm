import 'package:clwb_crm/screens/orders/dialog/open_order_detail_dialog.dart';
import 'package:clwb_crm/screens/orders/mobile_view_widgets/order_card_mobile.dart';
import 'package:clwb_crm/screens/orders/mobile_view_widgets/order_status_tab_mobile.dart';
import 'package:clwb_crm/screens/orders/mobile_view_widgets/orders_filters_row_mobile.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/order_controller.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/order_detail_panel.dart';
import 'package:clwb_crm/screens/orders/widgets/orders_header.dart';
import 'package:clwb_crm/screens/orders/widgets/orders_status_tabs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersMobileView extends GetView<OrdersController> {
  const OrdersMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
          children: [
            const OrdersHeader(),

            // const OrdersStatusTabsMobile(),
            const SizedBox(height: 12),
            const OrdersStatusTabsMobile(),

            const SizedBox(height: 12),

            const OrdersFiltersRowMobile(),
            const SizedBox(height: 16),

            ...controller.visibleOrders.map(
                  (order) => OrderMobileCard(
                order: order,
                onTap: () {
                  controller.selectOrder(order);
                  openOrderDetailDialog(context, order);
                },
              ),
            ),
          ],
        );
      }),

      // ➕ ADD ORDER FAB
      floatingActionButton: FloatingActionButton(
        onPressed: controller.openAddOrderDialog,
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}















