import 'package:clwb_crm/screens/orders/widgets/orders_filters_row.dart';
import 'package:clwb_crm/screens/orders/widgets/orders_status_tabs.dart';
import 'package:flutter/material.dart';

class OrdersFiltersBar extends StatelessWidget {
  const OrdersFiltersBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        OrdersStatusTabs(),
        SizedBox(height: 12),
        OrdersFiltersRow(),
      ],
    );
  }
}
