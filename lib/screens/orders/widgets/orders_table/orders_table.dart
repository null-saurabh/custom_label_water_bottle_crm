import 'package:clwb_crm/screens/orders/dummy_data.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/widgets/orders_table/widgets/orders_table_header.dart';
import 'package:clwb_crm/screens/orders/widgets/orders_table/widgets/orders_table_row.dart';
import 'package:flutter/material.dart';

class OrdersTable extends StatelessWidget {
  final List<OrderModel> dummyOrders;
  final List<OrderModel> orders;
  final String? selectedId;
  final Function(OrderModel) onOrderTap;
  const OrdersTable({
    super.key,
    required this.orders,
    required this.selectedId,
    required this.onOrderTap, required this.dummyOrders,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        const OrdersTableHeader(),
        Expanded(
          child: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (_, i) {
              final order = orders[i];
              final isSelected = order.id == selectedId;
              return GestureDetector(
                onTap: () => onOrderTap(order),
                child: OrdersTableRow(order: order,isSelected: isSelected,),
              );
            },
          ),
        ),
      ],
    );
  }
}
