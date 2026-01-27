import 'package:clwb_crm/core/widgets/premium_button.dart';
import 'package:clwb_crm/screens/inventory/dialogs/base_dialog.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/widgets/production_tab/order_production_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductionDialog extends StatefulWidget {
  final OrderModel order;
  const AddProductionDialog({super.key, required this.order});

  @override
  State<AddProductionDialog> createState() => _AddProductionDialogState();
}

class _AddProductionDialogState extends State<AddProductionDialog> {
  final qtyCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductionController>();

    return BaseDialog(
      title: "Add Production Entry",
      footer: PremiumButton(
        text: "Save",
        onTap: () async {
          final qty = int.tryParse(qtyCtrl.text) ?? 0;
          if (qty <= 0) return;

          await controller.submitProduction();
          Get.back();
        },
      ),
      child: Column(
        children: [
          Field(label: "Quantity", onChanged: (v) => qtyCtrl.text = v),
          Field(label: "Notes", maxLines: 3, onChanged: (v) => notesCtrl.text = v),
        ],
      ),
    );
  }
}
