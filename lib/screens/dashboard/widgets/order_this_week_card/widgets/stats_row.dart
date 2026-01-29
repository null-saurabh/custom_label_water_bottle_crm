
import 'package:clwb_crm/screens/dashboard/dashboard_controller.dart';
import 'package:clwb_crm/screens/dashboard/widgets/order_this_week_card/widgets/stat_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatsRow extends GetView<DashboardController> {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StatItem(
            icon: Icons.local_shipping_outlined,
            label: 'Delivered',
            value: controller.weekDelivered.value,
            color: const Color(0xFF4C6FFF),
          ),
          SizedBox(width: 20,),
          StatItem(
            icon: Icons.schedule_outlined,
            label: 'Scheduled',
            value: controller.weekScheduled.value,
            color: const Color(0xFF8AB4F8),
          ),
          SizedBox(width: 20,),
          StatItem(
            icon: Icons.trending_up,
            label: 'Total Order',
            value: controller.weekNewOrders.value,
            color: const Color(0xFF7CBFA2),
          ),
        ],
      ),
    );
  }
}
