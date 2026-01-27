import 'package:clwb_crm/core/widgets/premium_button.dart';
import 'package:clwb_crm/screens/inventory/dialogs/base_dialog.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/widgets/production_tab/order_production_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';class AddDeliveryDialog extends StatefulWidget {
  const AddDeliveryDialog({super.key});

  @override
  State<AddDeliveryDialog> createState() => _AddDeliveryDialogState();
}

class _AddDeliveryDialogState extends State<AddDeliveryDialog> {
  final qtyCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductionController>();

    return BaseDialog(
      title: 'Add Delivery',
      footer: PremiumButton(
        text: 'Save Delivery',
        onTap: () async {
          final qty = int.tryParse(qtyCtrl.text) ?? 0;
          if (qty <= 0) {
            Get.snackbar('Invalid', 'Enter valid quantity');
            return;
          }

          controller.deliveredToday.value = qty;
          controller.deliveryNotes.value = notesCtrl.text;

          await controller.submitDelivery();
          Get.back();
        },
      ),
      child: Column(
        children: [
          Field(
            label: 'Quantity Delivered',
            onChanged: (v) => qtyCtrl.text = v,
          ),
          Field(
            label: 'Notes',
            maxLines: 3,
            onChanged: (v) => notesCtrl.text = v,
          ),
        ],
      ),
    );
  }
}
