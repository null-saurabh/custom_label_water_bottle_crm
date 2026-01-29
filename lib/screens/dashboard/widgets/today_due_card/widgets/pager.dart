// lib/features/dashboard/widgets/_pager.dart
import 'package:clwb_crm/screens/dashboard/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class Pager extends GetView<DashboardController> {
  const Pager({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          InkWell(onTap: controller.prevDay, child: const Icon(Icons.chevron_left, size: 16)),
          const SizedBox(width: 6),
          Text(controller.selectedDayLabel, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 6),
          InkWell(onTap: controller.nextDay, child: const Icon(Icons.chevron_right, size: 16)),
        ],
      ),
    ));
  }
}


