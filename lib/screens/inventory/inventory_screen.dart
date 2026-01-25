// inventory/inventory_screen.dart
import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/inventory_detail_panel_screen/inventory_detail_panel.dart';
import 'package:clwb_crm/screens/inventory/supplier_detail_panel/supplier_detail_panel.dart';
import 'package:clwb_crm/screens/inventory/widgets/inventory_header.dart';
import 'package:clwb_crm/screens/inventory/widgets/items_table/inventory_item_table.dart';
import 'package:clwb_crm/screens/inventory/widgets/stat_card.dart';
import 'package:clwb_crm/screens/inventory/widgets/supplier_table/supplier_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class InventoryScreen extends GetView<InventoryController> {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body:Stack(
        children: [
          const _MainInventoryContent(),

          /// Inventory Item Detail Panel
          Obx(() {
            return InventoryDetailPanel(
              isVisible:
              controller.detailMode.value == InventoryDetailMode.item,
              onClose: controller.clearSelection,
            );
          }),

          /// Supplier Detail Panel
          Obx(() {
            return SupplierDetailPanel(
              isVisible:
              controller.detailMode.value == InventoryDetailMode.supplier,
              onClose: controller.clearSelection,
            );
          }),
        ],
      )
      ,
    );
  }
}


class _MainInventoryContent extends GetView<InventoryController> {
  const _MainInventoryContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InventoryHeader(),
            const SizedBox(height: 24),

            /// Stat cards
            InventoryStatCards(),
            // }),

            const SizedBox(height: 24),

            /// Items table
            const InventoryItemsTable(),

            const SizedBox(height: 24),

            /// Supplier table
            const InventorySupplierTable(),
          ],
        ),
      ),
    );
  }
}


