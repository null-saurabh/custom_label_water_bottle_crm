import 'package:clwb_crm/screens/orders/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersHeader extends GetView<OrdersController> {
  const OrdersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Orders',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 16),

        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Obx(() {
              final hasText = controller.searchQuery.value.trim().isNotEmpty;

              return TextField(
                controller: controller.searchCtrl,
                onChanged: controller.setSearch,
                decoration: InputDecoration(
                  hintText: 'Search by order no / client / id',
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),

                  // ✅ trailing clear button
                  suffixIcon: hasText
                      ? IconButton(
                    tooltip: 'Clear',
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: controller.clearSearch,
                  )
                      : null,
                ),
              );
            }),

          ),
        ),
      ],
    );
  }
}
