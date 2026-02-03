import 'package:clwb_crm/core/widgets/premium_button.dart';
import 'package:clwb_crm/screens/inventory/dialogs/base_dialog.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/widgets/production_tab/order_production_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddClientPaymentDialog
    extends GetView<ProductionController> {

  const AddClientPaymentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return OldBaseDialog(
      title: 'Add Client Payment',

      footer: Obx(() {
        return PremiumButton(
          text: controller.isSaving.value
              ? 'Saving...'
              : 'Add Payment',
          isLoading: controller.isSaving.value,
          onTap: controller.isSaving.value
              ? () {}
              : controller.submitClientPayment,
        );
      }),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Field(
            label: 'Amount Received',
            onChanged: controller.setPaymentAmount,
          ),

          Field(
            label: 'Reference No (optional)',
            onChanged: controller.setPaymentRef,
          ),

          Field(
            label: 'Notes',
            maxLines: 2,
            onChanged: controller.setPaymentNotes,
          ),

          const SizedBox(height: 8),

          Obx(() {
            final o = controller.order.value!;
            final newPaid =
                o.paidAmount + controller.paymentAmount.value;
            final newDue =
                o.totalAmount - newPaid;

            return Text(
              'After Payment → Paid: ₹${newPaid.toStringAsFixed(2)}   '
                  'Due: ₹${newDue.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            );
          }),
        ],
      ),
    );
  }
}
