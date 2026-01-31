import 'package:clwb_crm/core/controllers/app_controller.dart';
import 'package:clwb_crm/screens/dashboard/widgets/dashboard_section_container.dart';
import 'package:clwb_crm/screens/dashboard/widgets/inventory_warning_card/inventory_warning_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'dart:math' as math;


class InventoryWarningCardMobile extends GetView<InventoryController> {
  const InventoryWarningCardMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardSectionContainer(
      title: 'Inventory Warnings',
      trailing: TextButton(
        onPressed: () {
          Get.find<AppController>().selectMenu(SidebarMenu.inventory);
        },
        child: const Text('View All >'),
      ),
      child: Obx(() {
        final warnings = controller.inventoryWarnings;

        final rows = warnings.map((w) {
          final item = w.item;
          final due = controller.orderDueThisWeek(item.id);
          final stock = item.stock;
          final shortfall = math.max(0, due - stock);

          return DashboardInventoryWarningRowModel(
            displayName: item.name,
            category: item.category,
            reOrderValue: item.reorderLevel,
            due: due,
            stock: stock,
            shortfall: shortfall,
          );
        }).toList();

        final totalDue = rows.fold<int>(0, (s, e) => s + e.due);
        final totalStock = rows.fold<int>(0, (s, e) => s + e.stock);
        final totalShortfall =
        rows.fold<int>(0, (s, e) => s + e.shortfall);

        return Column(
          children: [
            ...rows.map((r) => _InventoryWarningItemCard(data: r)),
            const SizedBox(height: 12),
            _InventorySummaryRow(
              totalDue: totalDue,
              totalStock: totalStock,
              totalShortfall: totalShortfall,
            ),
          ],
        );
      }),
    );
  }
}



class _InventoryWarningItemCard extends StatelessWidget {
  final DashboardInventoryWarningRowModel data;

  const _InventoryWarningItemCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 🏷 ITEM NAME
          Text(
            data.displayName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          // 🔁 REORDER INFO
          Text(
            'Reorder Level: ${data.reOrderValue}',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),

          const SizedBox(height: 12),

          // 📊 METRICS
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MetricTile(
                label: 'Order',
                value: data.due.toString(),
                color: const Color(0xFF374151),
              ),
              _MetricTile(
                label: 'Shortfall',
                value: data.shortfall.toString(),
                color: const Color(0xFFD32F2F),
              ),
              _MetricTile(
                label: 'Stock',
                value: data.stock.toString(),
                color: const Color(0xFF4C6FFF),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

class _InventorySummaryRow extends StatelessWidget {
  final int totalDue;
  final int totalStock;
  final int totalShortfall;

  const _InventorySummaryRow({
    required this.totalDue,
    required this.totalStock,
    required this.totalShortfall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _SummaryItem(
            label: 'Order',
            value: totalDue.toString(),
            color: const Color(0xFF374151),
          ),
          _SummaryDivider(),
          _SummaryItem(
            label: 'Stock',
            value: totalStock.toString(),
            color: const Color(0xFF4C6FFF),
          ),
          _SummaryDivider(),
          _SummaryItem(
            label: 'Shortfall',
            value: totalShortfall.toString(),
            color: const Color(0xFFD32F2F),
          ),
        ],
      ),
    );
  }
}



class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$value ',
            style: TextStyle(fontWeight: FontWeight.w600, color: color),
          ),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _SummaryDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 20, color: const Color(0xFFE5E7EB));
  }
}
