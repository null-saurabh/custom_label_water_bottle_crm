import 'package:clwb_crm/screens/inventory/dialogs/base_dialog.dart';
import 'package:flutter/material.dart';

class AddSupplierDialog extends StatelessWidget {
  const AddSupplierDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'Add Supplier',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          Field(label: 'Supplier Name'),
          Field(label: 'Contact Person'),
          Field(label: 'Phone Number'),
          Field(label: 'Email'),
          Field(label: 'Address', maxLines: 3),
        ],
      ),
    );
  }
}
