import 'package:clwb_crm/core/widgets/premium_button.dart';
import 'package:clwb_crm/screens/client/client_controller.dart';
import 'package:clwb_crm/screens/inventory/dialogs/base_dialog.dart';
import 'package:clwb_crm/screens/inventory/dialogs/controller/add_inventory_item_controller.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class AddItemDialog extends StatelessWidget {
  const AddItemDialog({super.key});

  @override
  Widget build(BuildContext context) {

    final clientsController = Get.find<ClientsController>();

    final c = Get.put(
      AddInventoryItemController(
        clients: clientsController.clients,
      ),
    );

    return BaseDialog(
      title: 'Add New Item',
      footer: Obx(
            () => PremiumButton(
          text: c.isSaving.value ? 'Saving...' : 'Create Item',
          onTap: c.isValid && !c.isSaving.value ? c.submit : (){
            Get.snackbar(
              'Error',
              'Failed to Submit Item',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ===== BASIC =====
          Field(
            label: 'Item Name',
            onChanged: (v) => c.name.value = v,
          ),

          Dropdown(
            label: 'Category',
            items: InventoryCategory.values.map((e) => e.name).toList(),
            onChanged: (v) {
              if (v == null) return;
              c.category.value =
                  InventoryCategory.values.firstWhere((e) => e.name == v);
            },
          ),


          const Divider(height: 32),

          /// ===== CATEGORY CONFIG =====
          Obx(() {
            // ---------- BOTTLE ----------
            if (c.isBottle) {
              return Column(
                children: [
                  Dropdown(
                    label: 'Bottle Size (ml)',
                    items: const ['200', '500', '1000'],
                    onChanged: (v) => c.bottleSize.value = v ?? '',
                  ),
                  Dropdown(
                    label: 'Bottle Shape',
                    items: const ['Round', 'Square', 'Custom'],
                    onChanged: (v) => c.bottleShape.value = v ?? '',
                  ),
                  Dropdown(
                    label: 'Neck Type',
                    items: const ['28mm', '30mm', 'Custom'],
                    onChanged: (v) => c.neckType.value = v ?? '',
                  ),
                ],
              );
            }

            // ---------- CAP ----------
            if (c.isCap) {
              return Column(
                children: [
                  Dropdown(
                    label: 'Cap Size',
                    items: const ['28mm', '30mm'],
                    onChanged: (v) => c.capSize.value = v ?? '',
                  ),
                  Dropdown(
                    label: 'Cap Color',
                    items: const ['White', 'Blue', 'Black'],
                    onChanged: (v) => c.capColor.value = v ?? '',
                  ),
                  Dropdown(
                    label: 'Cap Material',
                    items: const ['Plastic', 'Bio', 'Metal'],
                    onChanged: (v) => c.capMaterial.value = v ?? '',
                  ),
                ],
              );
            }

            // ---------- LABEL ----------
            if (c.isLabel) {
              return Column(
                children: [
                  Field(
                    label: 'Label Width (mm)',
                    onChanged: (v) => c.labelWidth.value = v,
                  ),
                  Field(
                    label: 'Label Height (mm)',
                    onChanged: (v) => c.labelHeight.value = v,
                  ),
                  Dropdown(
                    label: 'Label Material',
                    items: const ['Paper', 'Plastic'],
                    onChanged: (v) => c.labelMaterial.value = v ?? '',
                  ),

                  const SizedBox(height: 12),

                  /// Client specific toggle (dropdown instead of switch)
                  Dropdown(
                    label: 'Label Type',
                    items: const ['Generic', 'Client Specific'],
                    onChanged: (v) =>
                    c.isClientSpecific.value = v == 'Client Specific',
                  ),

                  Obx(() {
                    if (!c.isClientSpecific.value) {
                      return const SizedBox.shrink();
                    }

                    /// Client selection (ID-based, scalable)
                    return Dropdown(
                      label: 'Client',
                      items: c.clients.map((client) => client.businessName).toList(),
                      onChanged: (v) {
                        if (v == null) return;

                        final client =
                        c.clients.firstWhere((e) => e.businessName == v);

                        c.selectedClientId.value = client.id;
                      },
                    );

                  }),
                ],
              );
            }


            return const SizedBox.shrink();
          }),

          const Divider(height: 32),

          /// ===== INVENTORY POLICY =====
          Field(
            label: 'Reorder Level',
            onChanged: (v) =>
            c.reorderLevel.value = int.tryParse(v) ?? 0,
          ),
        ],
      ),
    );
  }
}





