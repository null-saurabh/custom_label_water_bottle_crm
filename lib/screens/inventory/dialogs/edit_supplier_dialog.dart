import 'package:clwb_crm/core/widgets/new_base_dialog.dart';
import 'package:clwb_crm/core/widgets/premium_button.dart';
import 'package:clwb_crm/screens/inventory/dialogs/base_dialog.dart';
import 'package:clwb_crm/screens/inventory/dialogs/controller/edit_supplier_controller.dart';
import 'package:clwb_crm/screens/inventory/dialogs/edit_item_dialog.dart';
import 'package:clwb_crm/screens/inventory/model/supplier_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditSupplierDialog extends StatelessWidget {
  final SupplierModel supplier;

  const EditSupplierDialog({
    super.key,
    required this.supplier,
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.put(EditSupplierController(supplier));

    return BaseDialog(
      title: 'Edit Supplier',
      footer: Obx(
            () => PremiumButton(
          text: c.isSaving.value ? 'Saving...' : 'Update Supplier',
          onTap: c.isValid && !c.isSaving.value ? c.submit : () {},
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EditField(
            label: 'Supplier Name',
            controller: c.nameCtrl,
          ),

          EditField(
            label: 'Contact Person',
            controller: c.contactPersonCtrl,
          ),

          EditField(
            label: 'Phone',
            controller: c.phoneCtrl,
          ),

          EditField(
            label: 'Email',
            controller: c.emailCtrl,
          ),

          EditField(
            label: 'Address',
            controller: c.addressCtrl,
            maxLines: 2,
          ),

          const SizedBox(height: 16),

          Obx(() {
            return SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Active Supplier'),
              value: c.isActive.value,
              onChanged: (v) => c.isActive.value = v,
            );
          }),
        ],
      ),
    );
  }
}
