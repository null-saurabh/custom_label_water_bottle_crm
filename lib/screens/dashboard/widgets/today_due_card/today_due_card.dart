// lib/features/dashboard/widgets/due_deliveries_today_card.dart
import 'package:clwb_crm/core/controllers/app_controller.dart';
import 'package:clwb_crm/screens/dashboard/dashboard_controller.dart';
import 'package:clwb_crm/screens/dashboard/widgets/dashboard_section_container.dart';
import 'package:clwb_crm/screens/dashboard/widgets/delivery_list_row.dart';
import 'package:clwb_crm/screens/dashboard/widgets/today_due_card/widgets/pager.dart';
import 'package:clwb_crm/screens/orders/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DueDeliveriesTodayCard extends GetView<DashboardController> {
  const DueDeliveriesTodayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 220,
        maxHeight: 500,
      ),
      child: DashboardSectionContainer(
        title: 'Due Deliveries Today',
        trailing: Pager(),
        child: Obx(() {
          final list = controller.dueDeliveriesToday;

          if (list.isEmpty) {
            return const Center(
              child: Text(
                'No deliveries due today',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            itemCount: list.length,
            shrinkWrap: true, // 🔥 important when inside another scroll / constrained box
            physics: const ClampingScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final d = list[index];

              return DeliveryListRow(
                title: d.client,
                subtitle: '${d.quantity} Bottles • ${d.timeLabel}',

                // For Today → show status instead of weekday
                meta: d.completed ? 'Completed' : 'Deliver',
                chipBg: d.completed
                    ? const Color(0xFFE6F4EA)
                    : const Color(0xFF63B18F),
                chipText: d.completed
                    ? const Color(0xFF2E7D32)
                    : Colors.white,

                onTap: () {
                  // 1) navigate using the same mechanism as sidebar
                  Get.find<AppController>().selectMenu(SidebarMenu.orders);

                  // 2) after route builds, focus the order
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (Get.isRegistered<OrdersController>()) {
                      Get.find<OrdersController>()
                          .focusOrderById(d.orderId);
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
