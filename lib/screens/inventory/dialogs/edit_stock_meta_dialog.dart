import 'package:clwb_crm/core/widgets/premium_button.dart';
import 'package:clwb_crm/screens/inventory/dialogs/base_dialog.dart';
import 'package:clwb_crm/screens/inventory/dialogs/edit_item_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:clwb_crm/screens/inventory/model/inventory_stock_add_model.dart';
import 'controller/edit_stock_meta_controller.dart';

class EditStockMetaDialog extends StatelessWidget {
  final InventoryStockAddModel entry;
  const EditStockMetaDialog({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditStockMetaController>(
      init: EditStockMetaController(entry),
      builder: (c) {
        return BaseDialog(
          footer: Obx(
                () => PremiumButton(
              onTap: c.submit,
              text: "Save Correction",
              isLoading: c.isSaving.value,
            ),
          ),
          title: 'Edit Stock Entry (Admin)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditField(label: 'Ordered Quantity', controller: c.orderedCtrl),
              EditField(label: 'Rate Per Unit', controller: c.rateCtrl),
              EditField(label: 'Due Date (yyyy-mm-dd or blank)', controller: c.dueCtrl),
              EditField(label: 'Next Delivery Date (yyyy-mm-dd or blank)', controller: c.nextDeliveryCtrl),
              EditField(label: 'Reference No (optional)', controller: c.refCtrl),
              EditField(label: 'Correction Note (required)', controller: c.noteCtrl, maxLines: 2),

              // Obx(() =>
                  Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'New Total: ₹${c.newTotal.toStringAsFixed(0)}  |  New Due: ₹${c.newDue.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                // ),
              )),


            ],
          ),
        );
      },
    );
  }
}
