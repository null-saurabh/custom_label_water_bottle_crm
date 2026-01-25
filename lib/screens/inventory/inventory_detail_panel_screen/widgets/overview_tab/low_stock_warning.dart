import 'package:clwb_crm/screens/inventory/model/inventory_item_model.dart';
import 'package:flutter/material.dart';

class OverviewWarning extends StatelessWidget {
  final InventoryItemModel item;

  const OverviewWarning({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    if (item.stock >= item.reorderLevel) {
      return const SizedBox.shrink();
    }

    final shortage = item.reorderLevel - item.stock;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange.shade700,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Low Stock: Need $shortage units',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
