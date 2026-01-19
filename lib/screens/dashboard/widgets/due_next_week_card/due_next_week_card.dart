// ✅ DUE NEXT WEEK CARD
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../dashboard_controller.dart';
import '../dashboard_section_container.dart';
import '../delivery_list_row.dart';

class DueNextWeekCard extends GetView<DashboardController> {
  const DueNextWeekCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardSectionContainer(
      title: 'Due Next Week',
      trailing: _RangeIndicator(),
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



// ✅ RANGE INDICATOR (TOP RIGHT)
class _RangeIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: const [
          Icon(Icons.chevron_left, size: 16),
          SizedBox(width: 6),
          _GradientBar(),
          SizedBox(width: 6),
          Icon(Icons.chevron_right, size: 16),
        ],
      ),
    );
  }
}

class _GradientBar extends StatelessWidget {
  const _GradientBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF7CBFA2),
            Color(0xFF4C6FFF),
            Color(0xFFAED581),
          ],
        ),
      ),
    );
  }
}
