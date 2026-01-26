import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/widgets/overview_tab.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/widgets/panel_client_info.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/widgets/panel_header.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/widgets/panel_tabs.dart';
import 'package:flutter/material.dart';


class OrdersDetailPanel extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onClose;

  const OrdersDetailPanel({
    super.key,
    required this.order,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 299,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PanelHeader(
            orderNumber: order.orderNumber,
            onClose: onClose,
          ),
          const SizedBox(height: 16),
          PanelClientInfo(order: order),
          const SizedBox(height: 20),
          const PanelTabs(),
          const SizedBox(height: 16),
          Expanded(
            child: OverviewTab(order: order),
          ),
        ],
      ),
    );
  }
}
