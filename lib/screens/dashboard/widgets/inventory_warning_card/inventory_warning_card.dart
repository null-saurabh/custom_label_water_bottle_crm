// lib/features/dashboard/widgets/inventory_warning_card.dart



import 'package:clwb_crm/screens/dashboard/widgets/inventory_warning_card/widgets/inventory_warning_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../dashboard_controller.dart';
import '../dashboard_section_container.dart';

class InventoryWarningCard extends GetView<DashboardController> {
  const InventoryWarningCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardSectionContainer(
      title: 'Inventory Warnings',
      trailing: TextButton(
        onPressed: () {},
        child: const Text('View All >'),
      ),
      child:
      // Obx(
      //       () =>
                Column(
          children: [
            _HeaderRow(),
            const SizedBox(height: 8),
            // ...controller.inventoryWarnings.map(
            //       (w) => InventoryWarningRow(data:w ),
            // ),
            // const SizedBox(height: 12),
            // _SummaryRow(z
            //   totalDue: controller.totalInventoryDue,
            //   totalStock: controller.totalInventoryStock,
            //   totalShortfall: controller.totalInventoryShortfall,
            // ),
          ],
        ),

      // ),
    );
  }
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
          Expanded(flex: 2,child: Center(child: Text('Due'))),
          Expanded(flex: 2,child: Center(child: Text('Shortfall'))),
          Expanded(flex: 2,child: Center(child: Text('Stock'))),
        ],
      ),
    );
  }
}



// class _SummaryRow extends StatelessWidget {
//   final int totalDue;
//   final int totalStock;
//   final int totalShortfall;
//
//   const _SummaryRow({
//     required this.totalDue,
//     required this.totalStock,
//     required this.totalShortfall,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF1F4FA),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           _SummaryItem(
//             label: 'Order',
//             value: totalDue.toString(),
//             color: const Color(0xFF6B7280),
//           ),
//           _SummaryDivider(),
//           _SummaryItem(
//             label: 'Stock',
//             value: totalStock.toString(),
//             color: const Color(0xFF4C6FFF),
//           ),
//           _SummaryDivider(),
//           _SummaryItem(
//             label: 'Shortfall',
//             value: totalShortfall.toString(),
//             color: const Color(0xFFD32F2F),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SummaryItem extends StatelessWidget {
//   final String label;
//   final String value;
//   final Color color;
//
//   const _SummaryItem({
//     required this.label,
//     required this.value,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             '$value ',
//             style: TextStyle(fontWeight: FontWeight.w600, color: color),
//           ),
//           Text(
//             label,
//             style: const TextStyle(fontSize: 12),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SummaryDivider extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 1,
//       height: 20,
//       color: const Color(0xFFE5E7EB),
//     );
//   }
// }
