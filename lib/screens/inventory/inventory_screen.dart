// inventory/inventory_screen.dart
import 'package:clwb_crm/core/utils/responsive.dart';
import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/inventory_detail_panel_screen/inventory_detail_panel.dart';
import 'package:clwb_crm/screens/inventory/inventory_mobile_view.dart';
import 'package:clwb_crm/screens/inventory/supplier_detail_panel/supplier_detail_panel.dart';
import 'package:clwb_crm/screens/inventory/widgets/inventory_header.dart';
import 'package:clwb_crm/screens/inventory/widgets/inventory_warnings_panel/inventory_warnings_panel.dart';
import 'package:clwb_crm/screens/inventory/widgets/items_table/inventory_item_table.dart';
import 'package:clwb_crm/screens/inventory/widgets/stat_card.dart';
import 'package:clwb_crm/screens/inventory/widgets/stock_purchases_panel/stock_purchases_panel.dart';
import 'package:clwb_crm/screens/inventory/widgets/supplier_table/supplier_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InventoryScreen extends GetView<InventoryController> {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: Stack(
        children: [
          context.isMobile
              ? const InventoryMobileView()
              : const _MainInventoryContent(),

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
      ),
      floatingActionButton: context.isMobile
          ? _InventoryFab()

      : null,
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
            const SizedBox(height: 16),

            /// NEW: Stock + Warnings Row
            const InventoryItemAndManufactureRow(),
          ],
        ),
      ),
    );
  }
}

class InventoryItemAndManufactureRow extends GetView<InventoryController> {
  const InventoryItemAndManufactureRow({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final isNarrow = c.maxWidth < 1100;

        if (isNarrow) {
          return const Column(
            children: [
              InventoryStockPurchasesPanel(),
              SizedBox(height: 16),
              InventoryWarningsPanel(),
              SizedBox(height: 16),
              InventoryItemsTable(),
              SizedBox(height: 16),
              InventorySupplierTable(),
              SizedBox(height: 16),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 16,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InventoryStockPurchasesPanel(),
                  SizedBox(height: 16),
                  InventoryItemsTable(),
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 10,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InventoryWarningsPanel(),
                  SizedBox(height: 16),
                  InventorySupplierTable(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}


class _InventoryFab extends StatefulWidget {
  @override
  State<_InventoryFab> createState() => _InventoryFabState();
}

class _InventoryFabState extends State<_InventoryFab>
    with SingleTickerProviderStateMixin {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final c = Get.find<InventoryController>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_open) ...[
          _FabItem(
            icon: Icons.inventory_2_outlined,
            label: 'Add Stock',
            onTap: () {
              _toggle();
              c.openAddStockDialog();
            },
          ),
          const SizedBox(height: 8),
          _FabItem(
            icon: Icons.factory_outlined,
            label: 'Add Supplier',
            onTap: () {
              _toggle();
              c.openAddSupplierDialog();
            },
          ),
          const SizedBox(height: 8),
          _FabItem(
            icon: Icons.add_box_outlined,
            label: 'Add Item',
            onTap: () {
              _toggle();
              c.openAddItemDialog();
            },
          ),
          const SizedBox(height: 12),
        ],

        FloatingActionButton(
          backgroundColor: const Color(0xFF4C6FFF),
          shape: const CircleBorder(),
          onPressed: _toggle,
          child: AnimatedRotation(
            duration: const Duration(milliseconds: 180),
            turns: _open ? 0.125 : 0, // + → × feel
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _toggle() {
    setState(() => _open = !_open);
  }
}


class _FabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FabItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: const Color(0xFF4C6FFF)),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
