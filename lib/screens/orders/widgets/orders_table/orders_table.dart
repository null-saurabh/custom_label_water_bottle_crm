import 'package:clwb_crm/screens/orders/dummy_data.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/widgets/orders_table/widgets/orders_table_header.dart';
import 'package:clwb_crm/screens/orders/widgets/orders_table/widgets/orders_table_row.dart';
import 'package:flutter/material.dart';


class OrdersTable extends StatelessWidget {
  final Function(OrderModel) onOrderTap;
  const OrdersTable({super.key,required this.onOrderTap,});

  @override
  Widget build(BuildContext context) {
    final orders = OrdersDummyData.list;

    return Column(
      children: [
        const OrdersTableHeader(),
        Expanded(
          child: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (_, i) {
              return GestureDetector(
                onTap: () => onOrderTap(orders[i]),
                child: OrdersTableRow(order: orders[i]),
              );
            },
          ),
        ),
      ],
    );
  }
}
