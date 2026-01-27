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
            child: TextField(
              onChanged: controller.setSearch, // 🔥 LIVE BIND
              decoration: const InputDecoration(
                hintText: 'Search by order no or client',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
