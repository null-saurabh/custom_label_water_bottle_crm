import 'package:clwb_crm/screens/inventory/widgets/items_table/inventory_item_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../inventory_controller.dart';

class InventorySuppliersMobileList extends GetView<InventoryController> {
  const InventorySuppliersMobileList({super.key});

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
              const Text('Manufacturers',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
          
              SearchBox(
                controller: controller.supplierSearchCtrl,
                hintText: 'Search Manufacturers...',
                onChanged: controller.supplierSearchQuery.call,
              ),
          
              const SizedBox(height: 12),
          
              Obx(() {
                final list = controller.filteredSuppliers;
          
                if (list.isEmpty) {
                  return const Text('No suppliers found');
                }
          
                return Column(
                  children: list.map((s) {
                    final pending =
                    controller.supplierPendingAmount(s.id);
          
                    return ListTile(
                      title: Text(s.name,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text('Pending ₹${pending.toStringAsFixed(0)}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => controller.selectSupplier(s),
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
