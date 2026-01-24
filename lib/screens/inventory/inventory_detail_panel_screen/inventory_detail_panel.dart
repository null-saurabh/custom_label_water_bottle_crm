import 'package:clwb_crm/screens/inventory/inventory_detail_panel_screen/widgets/detail_panel_content.dart';
import 'package:clwb_crm/screens/inventory/inventory_detail_panel_screen/widgets/detail_panel_header.dart';
import 'package:flutter/material.dart';

class InventoryDetailPanel extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onClose;

  const InventoryDetailPanel({
    super.key,
    required this.isVisible,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final panelWidth = width * 0.38; // matches design

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      top: 0,
      bottom: 0,
      right: isVisible ? 0 : -panelWidth,
      width: panelWidth,
      child: Material(
        elevation: 20,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              bottomLeft: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            children: [
              InventoryDetailPanelHeader(onClose: onClose),
              const Divider(height: 1),
              const Expanded(child: InventoryPanelDetail()),
            ],
          ),
        ),
      ),
    );
  }
}
