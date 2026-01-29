// ✅ DUE NEXT WEEK CARD
import 'package:clwb_crm/screens/dashboard/dashboard_controller.dart';
import 'package:clwb_crm/screens/dashboard/widgets/dashboard_section_container.dart';
import 'package:clwb_crm/screens/dashboard/widgets/delivery_list_row.dart';
import 'package:clwb_crm/screens/dashboard/widgets/due_next_week_card/widgets/range_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DueNextWeekCard extends GetView<DashboardController> {
  const DueNextWeekCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardSectionContainer(
      title: 'Due Week',
      trailing: RangeIndicator(),
      child: Obx(
            () => Column(
          children: controller.dueNextWeek.map((d) {
            return DeliveryListRow(
              title: d.client,
              subtitle: '${d.quantity} Bottles',
              meta: d.dayLabel,
              chipBg: d.dayBg,
              chipText: d.dayText,
            );
          }).toList(),
        ),
      ),
    );
  }
}




