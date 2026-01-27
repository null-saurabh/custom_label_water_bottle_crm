import 'package:clwb_crm/screens/orders/order_controller.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/order_detail_panel.dart';
import 'package:clwb_crm/screens/orders/widgets/orders_filters_bar.dart';
import 'package:clwb_crm/screens/orders/widgets/orders_header.dart';
import 'package:clwb_crm/screens/orders/widgets/orders_table/orders_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersPage extends GetView<OrdersController> {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final detail = Get.find<OrderDetailController>();
    return Obx(() {
      final hasDetail =
          controller.selectedOrderId.value != null;

      // final hasDetail = controller.selectedOrder != null;
      // print("has de");
      return Row(
        children: [
          // LEFT SIDE
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: 20,
                bottom: 20,
                left: !hasDetail ? 20 : 8,
                right: !hasDetail ? 20 : 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrdersHeader(
                    // onAdd: controller.openAddOrderDialog,
                  ),
                  const SizedBox(height: 16),
                  OrdersFiltersBar(
                    // onSearch: controller.setSearch,
                    // onStatus: controller.setStatusFilter,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return OrdersTable(
                        selectedId: controller.selectedOrderId.value,
                        onOrderTap: controller.selectOrder,
                      );

                    }),
                  ),
                ],
              ),
            ),
          ),

          // RIGHT PANEL

          Obx(() {
            final selected = controller.selectedOrder;

            if (selected == null) {
              return const SizedBox.shrink();
            }

            return OrdersDetailPanel(
              order: selected,
              onClose: controller.clearSelection,
            );
          }),


        ],
      );
    });
  }
}
