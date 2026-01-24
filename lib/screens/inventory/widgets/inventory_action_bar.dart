import 'package:clwb_crm/core/widgets/blue_action_button.dart';
import 'package:clwb_crm/screens/inventory/dialogs/add_item_dialog.dart';
import 'package:clwb_crm/screens/inventory/dialogs/add_stock_dialog.dart';
import 'package:clwb_crm/screens/inventory/dialogs/add_supplier_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InventoryActionBar extends StatelessWidget {
  const InventoryActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlueActionButton(
          icon: Icons.inventory_2_outlined,
          label: 'Add Stock',
          isPrimary: true,
          onTap: () {
            Get.dialog(const AddStockDialog());
          },
        ),
        const SizedBox(width: 12),
        BlueActionButton(
          icon: Icons.add_box_outlined,
          label: 'Add Item',
          onTap: () {
            Get.dialog(const AddItemDialog());
          },
        ),

        const SizedBox(width: 12),
        BlueActionButton(
          icon: Icons.factory_outlined,
          label: 'Add Supplier',
          onTap: () {
            Get.dialog(const AddSupplierDialog());
          },
        ),

      ],
    );
  }
}

