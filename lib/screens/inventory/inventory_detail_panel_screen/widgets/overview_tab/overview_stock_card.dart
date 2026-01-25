import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverviewStockCards extends GetView<InventoryController> {
  final InventoryItemModel item;

  const OverviewStockCards({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final stockEntries =
      controller.stockEntries.where((e) => e.itemId == item.id);

      final totalPurchased = stockEntries.fold<double>(
        0,
            (sum, e) => sum + e.totalAmount,
      );

      final totalPaid = stockEntries.fold<double>(
        0,
            (sum, e) => sum + e.paidAmount,
      );

      final due = totalPurchased - totalPaid;

      return Column(
        children: [
          Row(
            children: [
              _ValueCard(
                title: 'Current Stock',
                value: item.stock.toString(),
                sub: 'Units Available',
              ),
              const SizedBox(width: 16),
              _ValueCard(
                title: 'Total Purchased',
                value: '₹${totalPurchased.toStringAsFixed(0)}',
                sub: 'Lifetime',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _ValueCard(
                title: 'Paid Amount',
                value: '₹${totalPaid.toStringAsFixed(0)}',
                sub: 'To Suppliers',
              ),
              const SizedBox(width: 16),
              _ValueCard(
                title: 'Payment Due',
                value: '₹${due.toStringAsFixed(0)}',
                sub: 'Outstanding',
              ),
            ],
          ),
        ],
      );
    });
  }
}


class _ValueCard extends StatelessWidget {
  final String title;
  final String value;
  final String sub;
  final bool editable;

  const _ValueCard({
    required this.title,
    required this.value,
    required this.sub,
    this.editable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.shade50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title,
                    style: TextStyle(color: Colors.grey.shade600)),
                if (editable) ...[
                  const Spacer(),
                  const Icon(Icons.edit, size: 16),
                ]
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(sub, style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}
