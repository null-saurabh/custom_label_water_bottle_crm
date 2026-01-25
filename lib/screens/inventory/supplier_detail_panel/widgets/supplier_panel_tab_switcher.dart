import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SupplierPanelTabSwitcher
    extends GetView<InventoryController> {
  const SupplierPanelTabSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffebe7f7),
      padding: const EdgeInsets.only(left: 16,right: 16, top: 12),
      child: Obx(() {
        final active = controller.activeSupplierDetailTab.value;

        return Row(
          children: [
            _TabItem(
              title: 'Overview',
              isActive: active == SupplierDetailTab.overview,
              width: 44,
              onTap: () => controller.switchSupplierDetailTab(
                SupplierDetailTab.overview,
              ),
            ),
            const SizedBox(width: 32),
            _TabItem(
              title: 'Recent Transactions',
              isActive: active == SupplierDetailTab.transactions,
              width: 96,
              onTap: () => controller.switchSupplierDetailTab(
                SupplierDetailTab.transactions,
              ),
            ),
          ],
        );
      }),
    );
  }
}


class _TabItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final double width;
  final VoidCallback onTap;

  const _TabItem({
    required this.title,
    required this.isActive,
    required this.width,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.blue : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: isActive ? width : 0,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

