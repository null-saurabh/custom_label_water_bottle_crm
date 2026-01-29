// ✅ DUE NEXT WEEK CARD
import 'package:clwb_crm/core/controllers/app_controller.dart';
import 'package:clwb_crm/screens/dashboard/dashboard_controller.dart';
import 'package:clwb_crm/screens/dashboard/widgets/dashboard_section_container.dart';
import 'package:clwb_crm/screens/dashboard/widgets/delivery_list_row.dart';
import 'package:clwb_crm/screens/dashboard/widgets/due_next_week_card/widgets/range_indicator.dart';
import 'package:clwb_crm/screens/orders/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DueNextWeekCard extends GetView<DashboardController> {
  const DueNextWeekCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 220,
        maxHeight: 650,
      ),
      child: DashboardSectionContainer(
        // height: 500,
        title: 'Due Week',
        trailing: RangeIndicator(),
        child: Obx(() {
          final list = controller.dueNextWeek;

          if (list.isEmpty) {
            return const Center(
              child: Text(
                'No upcoming dues',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            itemCount: list.length,
            shrinkWrap: true, // 🔥 IMPORTANT
            physics: const ClampingScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final d = list[index];
              return DeliveryListRow(
                title: d.client,
                subtitle: '${d.quantity} Bottles',
                meta: d.dayLabel,
                chipBg: d.dayBg,
                chipText: d.dayText,
                onTap: () {
                  Get.find<AppController>()
                      .selectMenu(SidebarMenu.orders);

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
        }),
      ),
    );
  }
}




