import 'package:clwb_crm/core/widgets/premium_button.dart';
import 'package:clwb_crm/screens/inventory/dialogs/base_dialog.dart';
import 'package:clwb_crm/screens/inventory/dialogs/controller/receive_stock_controller.dart';
import 'package:clwb_crm/screens/inventory/dialogs/edit_item_dialog.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_stock_add_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReceiveStockDialog extends StatelessWidget {
  final InventoryStockAddModel entry;
  const ReceiveStockDialog({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReceiveStockController>(
      init: ReceiveStockController(entry),
      builder: (c) {
        return BaseDialog(
          footer: Obx(
            () => PremiumButton(
              onTap: c.submit,
              text: "Save",
              isLoading: c.isSaving.value,
            ),
          ),
          title: 'Receive Stock',

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditField(
                label: 'Received Quantity (today)',
                controller: c.receivedCtrl,
              ),

              EditField(
                label: 'Next Delivery Date (yyyy-mm-dd) or blank',
                controller: c.nextDeliveryCtrl,
              ),

              // Obx(() =>
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'New Received: ${c.newReceivedQuantity} / ${entry.orderedQuantity}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),

              // Row(
              //   children: [
              //     Expanded(
              //       child:
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

//
//
