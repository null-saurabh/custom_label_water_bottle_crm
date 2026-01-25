import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_item_model.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_stock_add_model.dart';
import 'package:clwb_crm/screens/inventory/model/supplier_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupplierItemsSection extends GetView<InventoryController> {
  final SupplierModel supplier;

  const SupplierItemsSection({
    super.key,
    required this.supplier,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.itemsForSupplier(supplier.id);

      if (items.isEmpty) {
        return const Text(
          'No items linked to this supplier',
          style: TextStyle(color: Colors.grey),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Items from this supplier',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          ...items.map(
                (item) => _ItemRow(
              item: item,
              supplierId: supplier.id,
            ),
          ),

        ],
      );
    });
  }
}


class _ItemRow extends GetView<InventoryController> {
  final InventoryItemModel item;
  final String supplierId;

  const _ItemRow({
    required this.item,
    required this.supplierId,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isExpanded =
          controller.expandedSupplierItemId.value == item.id;

      return Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              controller.toggleSupplierItemExpansion(item.id);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.category.name,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: isExpanded ? 0.5 : 0,
                    child: const Icon(
                      Icons.expand_more,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// 👇 EXPANDED CONTENT
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _StockHistory(
              supplierId: supplierId,
              itemId: item.id,
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      );
    });
  }
}



class _StockHistory extends GetView<InventoryController> {
  final String supplierId;
  final String itemId;

  const _StockHistory({
    required this.supplierId,
    required this.itemId,
  });

  @override
  Widget build(BuildContext context) {
    final history = controller.stockHistoryForSupplierItem(
      supplierId: supplierId,
      itemId: itemId,
    );

    if (history.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          'No purchase history',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: history.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${e.orderedQuantity} units',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  child: Text(
                    '₹${e.totalAmount.toStringAsFixed(0)}',
                  ),
                ),
                Expanded(
                  child: Text(
                    e.status.name,
                    style: TextStyle(
                      color: e.status == DeliveryStatus.received
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                ),
                Text(
                  _fmtDate(e.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.day}/${d.month}/${d.year}';
}

