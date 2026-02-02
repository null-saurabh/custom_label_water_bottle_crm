import 'dart:math' as math;

import 'package:clwb_crm/core/utils/responsive.dart';
import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/inventory_detail_panel_screen/widgets/detail_panel_header.dart';
import 'package:clwb_crm/screens/inventory/inventory_detail_panel_screen/widgets/detail_panel_tab_switcher.dart';
import 'package:clwb_crm/screens/inventory/inventory_detail_panel_screen/widgets/overview_tab/detail_overview_tab.dart';
import 'package:clwb_crm/screens/inventory/inventory_detail_panel_screen/widgets/overview_tab/overview_recent_flow_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InventoryDetailPanel extends GetView<InventoryController> {
  final bool isVisible;
  final VoidCallback onClose;

  const InventoryDetailPanel({
    super.key,
    required this.isVisible,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double panelWidth =
    math.max(360.0, screenWidth * 0.38).toDouble();

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

            final detail = controller.selectedItemDetail.value;

            if (detail == null) {
              return const SizedBox.shrink();
            }

            final item = detail.item;


            return Column(
              children: [
                InventoryDetailPanelHeader(item: item, onClose: onClose),

                const InventoryDetailPanelTabSwitcher(),

                const Divider(height: 1),

                Expanded(
                  child: Obx(() {
                    final tab = controller.activeDetailTab.value;

                    switch (tab) {
                      case InventoryDetailTab.overview:
                        return SingleChildScrollView(
                          padding:  EdgeInsets.all( context.isMobile? 2 :20),
                          child: InventoryOverviewTab(detail: detail),
                        );

                      case InventoryDetailTab.transactions:
                        return SingleChildScrollView(
                          padding:  EdgeInsets.all(context.isMobile? 2 :20),
                          child: OverviewStockFlowTable(itemId: item.id),
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
