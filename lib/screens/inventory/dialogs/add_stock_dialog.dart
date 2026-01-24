import 'package:clwb_crm/screens/inventory/dialogs/base_dialog.dart';
import 'package:flutter/material.dart';

class AddStockDialog extends StatelessWidget {
  const AddStockDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'Add Stock',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Dropdown(label: 'Category', items: [
            'Bottle',
            'Cap',
            'Label',
            'Packaging',
          ]),
          Dropdown(label: 'Item', items: [
            'Round Bottle 500 ML',
            'Round Bottle 1 Liter',
          ]),
          Dropdown(label: 'Supplier', items: [
            'AquaFlex',
            'ClearSpring',
          ]),
          Divider(height: 32),
          SectionTitle('Stock Details'),
          Field(label: 'Ordered Quantity (Packs)'),
          Field(label: 'Received Quantity'),
          Field(label: 'Rate per Unit'),
          Divider(height: 32),
          SectionTitle('Payment & Delivery'),
          Field(label: 'Total Amount'),
          Field(label: 'Paid Amount'),
          Dropdown(label: 'Delivery Status', items: [
            'Pending',
            'Partial',
            'Received',
          ]),
          Field(label: 'Delivery / Due Date'),
        ],
      ),
    );
  }
}
