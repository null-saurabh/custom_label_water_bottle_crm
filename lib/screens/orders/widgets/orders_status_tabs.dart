import 'package:clwb_crm/screens/orders/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersStatusTabs extends StatelessWidget {
  const OrdersStatusTabs({super.key});

  static const tabs = [
    'all',
    'in_production',
    'ready',
    'delivered',
  ];

  static const labels = [
    'All',
    'In Production',
    'Ready',
    'Delivered',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrdersController>();

    return Obx(() {
      final activeStatus = controller.statusFilter.value;

      return Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(labels.length, (i) {
            final status = tabs[i];
            final isActive = activeStatus == status;

            return GestureDetector(
              onTap: () => controller.setStatusFilter(status),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color:
                  isActive ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    if (i == 1) ...[
                      const Icon(Icons.trending_up, size: 16),
                      const SizedBox(width: 6),
                    ],
                    if (i == 2) ...[
                      const Icon(Icons.check_circle, size: 16),
                      const SizedBox(width: 6),
                    ],
                    if (i == 3) ...[
                      const Icon(Icons.local_shipping, size: 16),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      labels[i],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
