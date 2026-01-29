// ✅ WEEKLY STANDING ORDERS CARD (NO LEAD CONTEXT, ONLY OPERATIONS)

import 'package:clwb_crm/screens/dashboard/dashboard_controller.dart';
import 'package:clwb_crm/screens/dashboard/widgets/dashboard_section_container.dart';
import 'package:clwb_crm/screens/dashboard/widgets/recurring_order_card/recurring_order_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RecurringOrdersCard extends GetView<DashboardController> {
  const RecurringOrdersCard({super.key});


  @override
  Widget build(BuildContext context) {
    return DashboardSectionContainer(
      title: 'Recurring Orders',
      trailing: Row(
        children: const [
          Icon(Icons.refresh, size: 18),
          SizedBox(width: 10),
          Icon(Icons.filter_alt_outlined, size: 18),
        ],
      ),
      child: Obx(
            () => Column(
          children: controller.weeklyStandingOrders.map((o) {
            return RecurringOrderRow(data: o);
          }).toList(),
        ),
      ),
    );
  }
}
