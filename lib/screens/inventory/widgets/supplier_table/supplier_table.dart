import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/widgets/items_table/inventory_item_table.dart';
import 'package:clwb_crm/screens/inventory/widgets/supplier_table/widgets/supplier_header.dart';
import 'package:clwb_crm/screens/inventory/widgets/supplier_table/widgets/supplier_row.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class InventorySupplierTable extends GetView<InventoryController> {
  const InventorySupplierTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Manufacturers",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          SearchBox(
            hintText: 'Search Manufacturers...',
            onChanged: controller.supplierSearchQuery.call,
          ),



          const SizedBox(height: 16),

      Obx(() {
        final list = controller.filteredSuppliers;

        if (controller.isLoading.value) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }


        if (list.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('No suppliers found')),
          );
        }

        return Column(
          children: [
            const SupplierHeader(),
            const Divider(height: 1),

            ...list.map((supplier) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 20,
                    ),
                    child: SupplierRow(supplier: supplier,
                      onTap: () => controller.selectSupplier(supplier),
                    ),
                  ),
                  const Divider(height: 1),
                ],
              );
            }),
          ],
        );
      })

      ],
      ),
    );
  }
}

