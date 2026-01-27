import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/order_controller.dart';
import 'package:clwb_crm/screens/orders/widgets/orders_table/widgets/orders_table_header.dart';
import 'package:clwb_crm/screens/orders/widgets/orders_table/widgets/orders_table_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersTable extends GetView<OrdersController> {
  final String? selectedId;
  final Function(OrderModel) onOrderTap;

  const OrdersTable({
    super.key,
    required this.selectedId,
    required this.onOrderTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const OrdersTableHeader(),

        Expanded(
          child: Obx(() {
            final orders = controller.visibleOrders;

            if (orders.isEmpty) {
              return const Center(
                child: Text(
                  'No orders found',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              key: ValueKey(orders.length),
              itemCount: orders.length,
              itemBuilder: (_, i) {
                final order = orders[i];
                final isSelected = order.id == selectedId;

                return GestureDetector(
                  onTap: () => onOrderTap(order),
                  child: OrdersTableRow(
                    order: order,
                    isSelected: isSelected,
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
