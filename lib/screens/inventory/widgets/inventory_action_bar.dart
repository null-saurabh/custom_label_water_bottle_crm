
import 'package:clwb_crm/core/widgets/blue_action_button.dart';
import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class InventoryActionBar extends GetView<InventoryController> {
  const InventoryActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlueActionButton(
          icon: Icons.inventory_2_outlined,
          label: 'Add Stock',
          isPrimary: true,
          // onTap: () async {
          //   await seedDummyOrders();
          //   Get.snackbar(
          //     'Done',
          //     'Dummy inventory data added',
          //     snackPosition: SnackPosition.BOTTOM,
          //   );
          // },
          onTap: controller.openAddStockDialog,
        ),

        const SizedBox(width: 12),
        BlueActionButton(
          icon: Icons.factory_outlined,
          label: 'Add Supplier',
          onTap: controller.openAddSupplierDialog,
        ),
        const SizedBox(width: 12),
        BlueActionButton(
          icon: Icons.add_box_outlined,
          label: 'Add Item',
          onTap: controller.openAddItemDialog,
        ),
      ],
    );
  }
}


