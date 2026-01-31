import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/widgets/items_table/widgets/row_widget.dart';
import 'package:clwb_crm/screens/inventory/widgets/items_table/widgets/table_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InventoryItemsTable extends GetView<InventoryController> {
  const InventoryItemsTable({super.key});

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
            "Items",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          /// Search (UI-only for now)
          SearchBox(
            controller: controller.itemSearchCtrl,
            hintText: 'Search Items...',
            onChanged: controller.itemSearchQuery.call,
          ),


          const SizedBox(height: 16),

          /// Table
          ///


      Obx(() {
        final list = controller.filteredItems;

        if (controller.isLoading.value) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (list.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('No items found')),
          );
        }

        return Column(
          children: [
            const TableHeader(),
            const Divider(height: 1),

            ...list.map((item) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 20,
                    ),
                    child: InventoryRow(
                      item: item,
                      onTap: () => controller.selectItem(item),
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


class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  const SearchBox({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}



