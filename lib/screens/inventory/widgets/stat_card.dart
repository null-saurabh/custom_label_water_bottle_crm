import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class InventoryStatCards extends GetView<InventoryController> {
  const InventoryStatCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final totalItems = controller.items.length;
      final totalSuppliers = controller.suppliers.length;


      return Row(
        children: [
          _StatCard(
            icon: Icons.inventory_2_outlined,
            value: totalItems.toString(),
            label: 'Total Items',
            bgColor: Color(0xffeef2f5),

          ),
          const SizedBox(width: 16),
          _StatCard(
            icon: Icons.factory_outlined,
            value: totalSuppliers.toString(),
            label: 'Suppliers',
            bgColor: Colors.green.shade50,



          ),
          const SizedBox(width: 16),
          _StatCard(
            icon: Icons.schedule_outlined,
            value: controller.ordersDueThisWeek.toString(),
            label: 'Orders Due This Week',
            bgColor: Color(0xffebe6fb),

          ),
          const SizedBox(width: 16),
          _StatCard(
            icon: Icons.account_balance_wallet_outlined,
            value: '₹${controller.totalStockValue.toStringAsFixed(0)}',
            label: 'Total Stock Value',
            bgColor: Color(0xfff7f1ec),

          ),
        ],
      );
    });
  }
}


class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? bgColor;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {


    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: bgColor ?? Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Icon(icon, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
