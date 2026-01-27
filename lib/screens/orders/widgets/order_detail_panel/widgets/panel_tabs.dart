import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/widgets/overview_tab/over_detail_tab_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PanelTabs extends GetView<OrderDetailTabsController> {
  const PanelTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tab = controller.selectedTab.value;

      return Row(
        children: [
          _TabButton(
            label: 'Overview',
            isActive: tab == OrderDetailTab.overview,
            onTap: () => controller.selectTab(OrderDetailTab.overview),
          ),
          _TabButton(
            label: 'Production',
            isActive: tab == OrderDetailTab.production,
            onTap: () => controller.selectTab(OrderDetailTab.production),
          ),
          _TabButton(
            label: 'Activity',
            isActive: tab == OrderDetailTab.activity,
            onTap: () => controller.selectTab(OrderDetailTab.activity),
          ),
        ],
      );
    });
  }
}


class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).primaryColor;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? activeColor : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? activeColor : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}
