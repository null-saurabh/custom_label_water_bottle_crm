// lib/features/dashboard/widgets/orders_this_week_card.dart

import 'package:clwb_crm/screens/dashboard/dashboard_controller.dart';
import 'package:clwb_crm/screens/dashboard/widgets/dashboard_section_container.dart';
import 'package:clwb_crm/screens/dashboard/widgets/order_this_week_card/widgets/bar_stack.dart';
import 'package:clwb_crm/screens/dashboard/widgets/order_this_week_card/widgets/legend_row.dart';
import 'package:clwb_crm/screens/dashboard/widgets/order_this_week_card/widgets/order_weeks_pager.dart';
import 'package:clwb_crm/screens/dashboard/widgets/order_this_week_card/widgets/stats_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class OrdersThisWeekCard extends GetView<DashboardController> {
  const OrdersThisWeekCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardSectionContainer(
      width: 420,
      title: 'Orders This Week',
      trailing: const OrdersWeekPager(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StatsRow(),
          const SizedBox(height: 12),
          const _WeeklyBarChart(),
          const SizedBox(height: 10),
          const LegendRow(),
        ],
      ),
    );
  }
}
// lib/features/dashboard/widgets/_weekly_bar_chart.dart

class _WeeklyBarChart extends GetView<DashboardController> {
  const _WeeklyBarChart();

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => SizedBox(
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: controller.weeklyBars.map((b) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 32, // ✅ FIXED BAR WIDTH
                    child: BarStack(
                      delivered: b.delivered,
                      scheduled: b.scheduled,
                      maxTotal: controller.maxWeeklyTotal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(b.day, style: const TextStyle(fontSize: 14,color: Colors.grey)),
                ],
              ),
            );

          }).toList(),
        ),
      ),
    );
  }
}




