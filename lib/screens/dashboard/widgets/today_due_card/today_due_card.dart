// lib/features/dashboard/widgets/due_deliveries_today_card.dart
import 'package:clwb_crm/screens/dashboard/widgets/today_due_card/widgets/pager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../dashboard_controller.dart';
import '../dashboard_section_container.dart';
import '../delivery_list_row.dart';

class DueDeliveriesTodayCard extends GetView<DashboardController> {
  const DueDeliveriesTodayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardSectionContainer(
      title: 'Due Deliveries Today',
      trailing: Pager(),
      child: Obx(
            () => Column(
          children: controller.dueDeliveriesToday.map((d) {
            return DeliveryListRow(
              title: d.client,
              subtitle: '${d.quantity} Bottles • ${d.timeLabel}',
              // for Today we don’t show weekday, we show status instead
              meta: d.completed ? 'Completed' : 'Deliver',
              chipBg: d.completed
                  ? const Color(0xFFE6F4EA)
                  : const Color(0xFF63B18F),
              chipText: d.completed
                  ? const Color(0xFF2E7D32)
                  : Colors.white,
            );
          }).toList(),
        ),
      ),
    );
  }
}
