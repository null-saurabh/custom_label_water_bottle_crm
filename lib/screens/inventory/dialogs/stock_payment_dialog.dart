import 'package:clwb_crm/core/widgets/premium_button.dart';
import 'package:clwb_crm/screens/inventory/dialogs/base_dialog.dart';
import 'package:clwb_crm/screens/inventory/dialogs/edit_item_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:clwb_crm/screens/inventory/model/inventory_stock_add_model.dart';
import 'controller/stock_payment_controller.dart';

class StockPaymentDialog extends StatelessWidget {
  final InventoryStockAddModel entry;
  const StockPaymentDialog({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StockPaymentController>(
      init: StockPaymentController(entry),
      builder: (c) {
        return BaseDialog(
          footer: Obx(
                () => PremiumButton(
              onTap: c.submit,
              text: "Save",
              isLoading: c.isSaving.value,
            ),
          ),
          title: 'Add Payment',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditField(
                label: 'Payment Amount (today)',
                controller: c.amountCtrl,
              ),
              EditField(
                label: 'Reference No (optional)',
                controller: c.refCtrl,
              ),
              EditField(
                label: 'Payment Date (yyyy-mm-dd) or blank for today',
                controller: c.dateCtrl,
              ),

              // Obx(() =>
                  Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'New Paid: ₹${c.newPaidAmount.toStringAsFixed(0)}  |  New Due: ₹${c.newDueAmount.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.w700),

              )),

              // Row(
              //   children: [
              //     Expanded(
              //       child: Obx(() => ElevatedButton(
              //         onPressed: c.isSaving.value ? null : c.submit,
              //         child: c.isSaving.value
              //             ? const SizedBox(
              //           height: 18,
              //           width: 18,
              //           child: CircularProgressIndicator(strokeWidth: 2),
              //         )
              //             : const Text('Save'),
              //       )),
              //     ),
              //   ],
              // ),
            ],
          ),
        );
      },
    );
  }
}
