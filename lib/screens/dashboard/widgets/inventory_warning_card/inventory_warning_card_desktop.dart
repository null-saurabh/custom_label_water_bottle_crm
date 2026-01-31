import 'package:clwb_crm/core/controllers/app_controller.dart';
import 'package:clwb_crm/screens/dashboard/widgets/dashboard_section_container.dart';
import 'package:clwb_crm/screens/dashboard/widgets/inventory_warning_card/inventory_warning_model.dart';
import 'package:clwb_crm/screens/dashboard/widgets/inventory_warning_card/widgets/inventory_warning_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'dart:math' as math;


class InventoryWarningCardDesktop extends GetView<InventoryController> {
  const InventoryWarningCardDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 220,
        maxHeight: 750,
      ),child:DashboardSectionContainer(
      title: 'Inventory Warnings',
      trailing: TextButton(
        onPressed: () {


          // 1) navigate using the same mechanism as sidebar
          Get.find<AppController>().selectMenu(SidebarMenu.inventory);

          // Get.rootDelegate.toNamed(AppRoutes.inventory);
        },
        child: const Text('View All >'),
      ),
      child: Obx(() {
        // InventoryController already computes warnings based on live items + orders
        final warnings = controller.inventoryWarnings;

        // Convert inventory warnings -> dashboard row model (due/stock/shortfall)
        final rows = warnings.map((w) {
          final item = w.item;
          final due = controller.orderDueThisWeek(item.id); // your “demand signal”
          final stock = item.stock;
          final shortfall = math.max(0, due - stock);

          return DashboardInventoryWarningRowModel(
            displayName: item.name,
            category: item.category,
            reOrderValue: item.reorderLevel,
            // sizeCode: _sizeCodeOfItem(item),
            due: due,
            stock: stock,
            shortfall: shortfall,
          );
        }).toList();

        final totalDue = rows.fold<int>(0, (s, e) => s + e.due);
        final totalStock = rows.fold<int>(0, (s, e) => s + e.stock);
        final totalShortfall = rows.fold<int>(0, (s, e) => s + e.shortfall);

        return Column(
          children: [
            _HeaderRow(),
            const SizedBox(height: 8),

            ...rows.map((r) => InventoryWarningRow(data: r)),

            const SizedBox(height: 12),
            _SummaryRow(
              totalDue: totalDue,
              totalStock: totalStock,
              totalShortfall: totalShortfall,
            ),
          ],
        );
      }),
    ),);
  }

/// 🔧 You MUST map this according to your InventoryItemModel fields.

}



// lib/features/dashboard/widgets/_inventory_helpers.dart

class _HeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: const [
          Expanded(flex: 5, child: Text('Item')),
          Expanded(flex: 2, child: Center(child: Text('Due'))),
          Expanded(flex: 2, child: Center(child: Text('Shortfall'))),
          Expanded(flex: 2, child: Center(child: Text('Stock'))),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final int totalDue;
  final int totalStock;
  final int totalShortfall;

  const _SummaryRow({
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
            color: const Color(0xFF6B7280),
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
