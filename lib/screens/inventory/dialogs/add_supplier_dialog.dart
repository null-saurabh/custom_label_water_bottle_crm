import 'package:clwb_crm/core/widgets/premium_button.dart';
import 'package:clwb_crm/screens/inventory/dialogs/base_dialog.dart';
import 'package:clwb_crm/screens/inventory/dialogs/controller/add_supplier_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSupplierDialog extends StatelessWidget {
  const AddSupplierDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AddSupplierController());

    return BaseDialog(
      title: 'Add Supplier',
      footer: Obx(
            () => PremiumButton(
          text: c.isSaving.value ? 'Saving...' : 'Create Supplier',
          onTap: c.isValid && !c.isSaving.value
              ? c.submit
              : () {
            Get.snackbar(
              'Error',
              'Please fill required fields',
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
            label: 'Supplier Name *',
            onChanged: (v) => c.name.value = v,
          ),

          Field(
            label: 'Contact Person',
            onChanged: (v) => c.contactPerson.value = v,
          ),

          Field(
            label: 'Phone',
            onChanged: (v) => c.phone.value = v,
          ),

          Field(
            label: 'Email',
            onChanged: (v) => c.email.value = v,
          ),

          Field(
            label: 'Address',
            maxLines: 2,
            onChanged: (v) => c.address.value = v,
          ),
        ],
      ),
    );
  }
}

