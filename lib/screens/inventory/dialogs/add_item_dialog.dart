import 'package:clwb_crm/screens/inventory/dialogs/base_dialog.dart';
import 'package:flutter/material.dart';

class AddItemDialog extends StatelessWidget {
  const AddItemDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'Add New Item',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Field(label: 'Item Name'),
          Field(label: 'SKU (Auto / Editable)'),
          Dropdown(label: 'Category', items: [
            'Bottle',
            'Cap',
            'Label',
            'Packaging',
          ]),
          Divider(height: 32),
          SectionTitle('Item Configuration'),
          Field(label: 'Size / Dimension'),
          Field(label: 'Shape / Color / Material'),
          Divider(height: 32),
          Field(label: 'Reorder Level'),
        ],
      ),
    );
  }
}
