import 'package:clwb_crm/screens/orders/widgets/orders_status_tabs.dart';
import 'package:flutter/material.dart';

class OrdersStatusTabsMobile extends StatelessWidget {
  const OrdersStatusTabsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: OrdersStatusTabs(), // ✅ exact desktop UI
    );
  }
}
