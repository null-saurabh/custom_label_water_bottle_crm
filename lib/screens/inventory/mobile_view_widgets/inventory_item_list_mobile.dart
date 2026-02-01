import 'package:clwb_crm/screens/inventory/widgets/items_table/inventory_item_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../inventory_controller.dart';

class InventoryItemsMobileList extends GetView<InventoryController> {
  const InventoryItemsMobileList({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 500),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Items',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
          
              SearchBox(
                controller: controller.itemSearchCtrl,
                hintText: 'Search Items...',
                onChanged: controller.itemSearchQuery.call,
              ),
          
              const SizedBox(height: 12),
          
              Obx(() {
                final list = controller.filteredItems;
          
                if (list.isEmpty) {
                  return const Text('No items found');
                }
          
                return Column(
                  children: list.map((item) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(item.name,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(
                          'Stock: ${item.stock} · Reorder: ${item.reorderLevel}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => controller.selectItem(item),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
