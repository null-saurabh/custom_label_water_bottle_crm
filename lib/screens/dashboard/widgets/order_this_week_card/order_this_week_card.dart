// lib/features/dashboard/widgets/orders_this_week_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../dashboard_controller.dart';
import '../dashboard_section_container.dart';

class OrdersThisWeekCard extends GetView<DashboardController> {
  const OrdersThisWeekCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardSectionContainer(
      width: 420,
      title: 'Orders This Week',
      trailing: _WeekPager(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StatsRow(),
          const SizedBox(height: 12),
          const _WeeklyBarChart(),
          const SizedBox(height: 10),
          const _LegendRow(),
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
                    child: _BarStack(
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

// lib/features/dashboard/widgets/_orders_week_stats.dart


class _StatsRow extends GetView<DashboardController> {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StatItem(
            icon: Icons.local_shipping_outlined,
            label: 'Delivered',
            value: controller.weekDelivered.value,
            color: const Color(0xFF4C6FFF),
          ),
          SizedBox(width: 20,),
          _StatItem(
            icon: Icons.schedule_outlined,
            label: 'Scheduled',
            value: controller.weekScheduled.value,
            color: const Color(0xFF8AB4F8),
          ),
          SizedBox(width: 20,),
          _StatItem(
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

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: color.withOpacity(0.12),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}






class _BarStack extends StatelessWidget {
  final int delivered;
  final int scheduled;
  final int maxTotal;

  const _BarStack({
    required this.delivered,
    required this.scheduled,
    required this.maxTotal,
  });

  @override
  Widget build(BuildContext context) {
    const maxHeight = 90.0;
    final total = delivered + scheduled ;

    double h(int v) =>
        maxTotal == 0 ? 0 : (v / maxTotal) * maxHeight;

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(height: h(scheduled), color: const Color(0xFF8AB4F8)),
          Container(height: h(delivered), color: const Color(0xFF4C6FFF)),
        ],
      ),
    );
  }
}



// lib/features/dashboard/widgets/_orders_week_legend.dart

class _LegendRow extends StatelessWidget {
  const _LegendRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _LegendItem(color: Color(0xFF4C6FFF), label: 'Delivered'),
        SizedBox(width: 14),
        _LegendItem(color: Color(0xFF8AB4F8), label: 'Scheduled'),
        SizedBox(width: 14),
        _LegendItem(color: Color(0xFF7CBFA2), label: 'New Orders'),
        Spacer(),
        Text(
          'Due 05 gents 2 >',
          style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}


// lib/features/dashboard/widgets/_week_pager.dart

class _WeekPager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: const [
          Icon(Icons.chevron_left, size: 16),
          SizedBox(width: 4),
          Text('1', style: TextStyle(fontSize: 12)),
          SizedBox(width: 4),
          Icon(Icons.chevron_right, size: 16),
        ],
      ),
    );
  }
}
