import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_stock_add_model.dart';
import 'package:clwb_crm/screens/inventory/model/supplier_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemSuppliersSection extends GetView<InventoryController> {
  final String itemId;

  const ItemSuppliersSection({
    super.key,
    required this.itemId,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final suppliers = controller.suppliersForItem(itemId);

      if (suppliers.isEmpty) {
        return const Text(
          'No suppliers linked to this item',
          style: TextStyle(color: Colors.grey),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Suppliers for this item',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          ...suppliers.map(
                (s) => _SupplierRow(
              supplier: s,
              itemId: itemId,
            ),
          ),
        ],
      );
    });
  }
}




class _SupplierRow extends GetView<InventoryController> {
  final SupplierModel supplier;
  final String itemId;

  const _SupplierRow({
    required this.supplier,
    required this.itemId,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isExpanded =
          controller.expandedItemSupplierId.value == supplier.id;

      return Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              controller.toggleItemSupplierExpansion(supplier.id);
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
                          supplier.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          supplier.phone ?? '—',
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

          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: _ItemSupplierHistory(
              itemId: itemId,
              supplierId: supplier.id,
            ),
          ),
        ],
      );
    });
  }
}



class _ItemSupplierHistory extends GetView<InventoryController> {
  final String itemId;
  final String supplierId;

  const _ItemSupplierHistory({
    required this.itemId,
    required this.supplierId,
  });

  @override
  Widget build(BuildContext context) {
    final history = controller.stockHistoryForItemSupplier(
      itemId: itemId,
      supplierId: supplierId,
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
