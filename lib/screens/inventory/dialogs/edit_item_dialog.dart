import 'package:clwb_crm/core/widgets/premium_button.dart';
import 'package:clwb_crm/screens/inventory/dialogs/base_dialog.dart';
import 'package:clwb_crm/screens/inventory/dialogs/controller/edit_inventory_item_controller.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_item_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditItemDialog extends StatelessWidget {
  final InventoryItemDetail detail;

  const EditItemDialog({
    super.key,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.put(EditInventoryItemController(detail));

    return BaseDialog(
      title: 'Edit Item',
      footer: Obx(
            () => PremiumButton(
          text: c.isSaving.value ? 'Saving...' : 'Update Item',
          onTap: c.isValid && !c.isSaving.value
              ? c.submit
              : () {},
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// BASIC
          EditField(
            label: 'Item Name',
            controller:  c.nameCtrl,
          ),

          const Divider(height: 32),

          /// CATEGORY CONFIG (LOCKED TYPE)
          if (c.isBottle) ...[
            EditDropdown(
              label: 'Bottle Size (ml)',
              items: const ['200', '500', '1000'],
              value: c.bottleSize.value,
              onChanged: (v) => c.bottleSize.value = v ?? '',
            ),
            EditDropdown(
              label: 'Bottle Shape',
              items: const ['Round', 'Square', 'Custom'],
              value: c.bottleShape.value,
              onChanged: (v) => c.bottleShape.value = v ?? '',
            ),
            EditDropdown(
              label: 'Neck Type',
              items: const ['28mm', '30mm'],
              value: c.neckType.value,
              onChanged: (v) => c.neckType.value = v ?? '',
            ),
          ],

          if (c.isCap) ...[
            EditDropdown(
              label: 'Cap Size',
              items: const ['28mm', '30mm'],
              value: c.capSize.value,
              onChanged: (v) => c.capSize.value = v ?? '',
            ),
            EditDropdown(
              label: 'Cap Color',
              items: const ['White', 'Blue', 'Black'],
              value: c.capColor.value,
              onChanged: (v) => c.capColor.value = v ?? '',
            ),
            EditDropdown(
              label: 'Cap Material',
              items: const ['Plastic', 'Bio', 'Metal'],
              value: c.capMaterial.value,
              onChanged: (v) => c.capMaterial.value = v ?? '',
            ),
          ],

          if (c.isLabel) ...[
            EditField(
              label: 'Label Width (mm)',
              controller: c.labelWidthCtrl
            ),
            EditField(
              label: 'Label Height (mm)',
              controller: c.labelHeightCtrl
            ),
            EditDropdown(
              label: 'Label Material',
              items: const ['Paper', 'Plastic'],
              value: c.labelMaterial.value,
              onChanged: (v) => c.labelMaterial.value = v ?? '',
            ),
          ],

          const Divider(height: 32),

          EditField(
            label: 'Reorder Level',
            controller: c.reorderCtrl

          ),
        ],
      ),
    );
  }
}










class EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;

  const EditField({
    super.key,
    required this.label,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}


class EditDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final String value;
  final ValueChanged<String?> onChanged;

  const EditDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: items.contains(value) ? value : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        items: items
            .map(
              (e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ),
        )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

