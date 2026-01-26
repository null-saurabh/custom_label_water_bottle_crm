import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/order_detail_panel.dart';
import 'package:clwb_crm/screens/orders/widgets/orders_filters_bar.dart';
import 'package:clwb_crm/screens/orders/widgets/orders_header.dart';
import 'package:clwb_crm/screens/orders/widgets/orders_table/orders_table.dart';
import 'package:flutter/material.dart';


class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  OrderModel? selectedOrder;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // LEFT SIDE
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 20,bottom: 20,left: selectedOrder == null ? 20:12,right: selectedOrder == null ? 20:0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const OrdersHeader(),
                const SizedBox(height: 16),
                const OrdersFiltersBar(),
                const SizedBox(height: 16),
                Expanded(
                  child: OrdersTable(
                    onOrderTap: (order) {
                      setState(() => selectedOrder = order);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        // RIGHT PANEL
        if (selectedOrder != null)
          OrdersDetailPanel(
            order: selectedOrder!,
            onClose: () {
              setState(() => selectedOrder = null);
            },
          ),
      ],
    );
  }
}
