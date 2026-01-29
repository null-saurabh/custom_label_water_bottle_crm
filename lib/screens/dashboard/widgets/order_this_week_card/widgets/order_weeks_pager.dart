import 'package:clwb_crm/screens/dashboard/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersWeekPager extends GetView<DashboardController> {
  const OrdersWeekPager({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4FA),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            InkWell(onTap: controller.prevOrdersWeek, child: const Icon(Icons.chevron_left, size: 16)),
            const SizedBox(width: 8),
            Text(
              controller.ordersWeekLabel,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            InkWell(onTap: controller.nextOrdersWeek, child: const Icon(Icons.chevron_right, size: 16)),
          ],
        ),
      );
    });
  }
}
