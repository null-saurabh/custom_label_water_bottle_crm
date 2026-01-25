import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InventoryRow extends GetView<InventoryController> {
  final InventoryItemModel item;
  final VoidCallback onTap;

  const InventoryRow({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final inStock = controller.inStock(item.id);
    final dueWeek = controller.orderDueThisWeek(item.id);
    final dueMonth = controller.orderDueThisMonth(item.id);
    final currentValue = controller.currentStockValue(item.id);
    final soldValue = controller.soldStockValue(item.id);

    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          _itemCell(item.name, item.category.name, 2),
          _stockBadge(inStock, 1),
          _textCell(dueWeek.toString(), 1.2),
          _textCell(dueMonth.toString(), 1.4),
          _greenText('₹${currentValue.toStringAsFixed(0)}', 1.4),
          _textCell('₹${soldValue.toStringAsFixed(0)}', 1.4),
          const SizedBox(
            width: 32,
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _itemCell(String title, String sub, double flex) {
  return Expanded(
    flex: (flex * 10).toInt(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(
          sub,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    ),
  );
}

Widget _stockBadge(int inStock, double flex) {
  return Expanded(
    flex: (flex * 10).toInt(),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          inStock.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
    ),
  );
}

Widget _textCell(String text, double flex) {
  return Expanded(
    flex: (flex * 10).toInt(),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w500),
    ),
  );
}

Widget _greenText(String text, double flex) {
  return Expanded(
    flex: (flex * 10).toInt(),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.green,
      ),
    ),
  );
}
