import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/supplier_detail_panel/widgets/supplier_overview_tab/supplier_overview_tab.dart';
import 'package:clwb_crm/screens/inventory/supplier_detail_panel/widgets/supplier_overview_tab/supplier_recent_table.dart';
import 'package:clwb_crm/screens/inventory/supplier_detail_panel/widgets/supplier_panel_header.dart';
import 'package:clwb_crm/screens/inventory/supplier_detail_panel/widgets/supplier_panel_tab_switcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupplierDetailPanel extends GetView<InventoryController> {
  final bool isVisible;
  final VoidCallback onClose;

  const SupplierDetailPanel({
    super.key,
    required this.isVisible,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final panelWidth = width * 0.38;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      top: 0,
      bottom: 0,
      right: isVisible ? 0 : -panelWidth,
      width: panelWidth,
      child: Material(
        elevation: 20,
        color: Colors.transparent,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              bottomLeft: Radius.circular(24),
            ),
          ),
          child: Obx(() {
            final supplier = controller.selectedSupplier.value;

            if (supplier == null) {
              return const SizedBox.shrink();
            }

            return Column(
              children: [
                SupplierPanelHeader(item: supplier, onClose: onClose),

                const SupplierPanelTabSwitcher(),

                const Divider(height: 1),

                Expanded(
                  child: Obx(() {
                    final tab = controller.activeSupplierDetailTab.value;

                    switch (tab) {
                      case SupplierDetailTab.overview:
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: SupplierOverviewTab(item: supplier),
                        );

                      case SupplierDetailTab.transactions:
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: SupplierRecentTable(supplierId: supplier.id),
                        );
                    }
                  }),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
