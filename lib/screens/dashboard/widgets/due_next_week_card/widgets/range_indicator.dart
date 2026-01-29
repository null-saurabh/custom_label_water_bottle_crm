import 'package:clwb_crm/screens/dashboard/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RangeIndicator extends GetView<DashboardController> {
  const RangeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4FA),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            InkWell(onTap: controller.prevDueWeek, child: const Icon(Icons.chevron_left, size: 16)),
            const SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _GradientBar(),
                const SizedBox(height: 4),
                Text(
                  controller.dueWeekLabel,
                  style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280), fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(width: 8),
            InkWell(onTap: controller.nextDueWeek, child: const Icon(Icons.chevron_right, size: 16)),
          ],
        ),
      );
    });
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
