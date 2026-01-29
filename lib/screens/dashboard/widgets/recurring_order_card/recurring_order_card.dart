// ✅ WEEKLY STANDING ORDERS CARD (NO LEAD CONTEXT, ONLY OPERATIONS)

import 'package:clwb_crm/core/controllers/app_controller.dart';
import 'package:clwb_crm/screens/dashboard/dashboard_controller.dart';
import 'package:clwb_crm/screens/dashboard/widgets/dashboard_section_container.dart';
import 'package:clwb_crm/screens/dashboard/widgets/recurring_order_card/recurring_order_row.dart';
import 'package:clwb_crm/screens/orders/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RecurringOrdersCard extends GetView<DashboardController> {
  const RecurringOrdersCard({super.key});


  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 220,
        maxHeight: 400,
      ),
      child: DashboardSectionContainer(
        title: 'Recurring Orders',
        trailing: Row(
          children: const [
            Icon(Icons.refresh, size: 18),
            SizedBox(width: 10),
            Icon(Icons.filter_alt_outlined, size: 18),
          ],
        ),
        child: Obx(() {
          final list = controller.weeklyStandingOrders;

          if (list.isEmpty) {
            return const Center(
              child: Text(
                'No standing orders this week',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            itemCount: list.length,
            shrinkWrap: true, // 🔥 important inside constrained layouts
            physics: const ClampingScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final o = list[index];

              return RecurringOrderRow(
                data: o,
                onTap: () {
                  // 1) navigate using the same mechanism as sidebar
                  Get.find<AppController>().selectMenu(SidebarMenu.orders);

                  // 2) after route builds, focus the order
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (Get.isRegistered<OrdersController>()) {
                      Get.find<OrdersController>()
                          .focusOrderById(o.orderId);
                    }
                  });
                },
              );
            },
          );
        })

      ),
    );
  }
}
