import 'package:clwb_crm/core/widgets/premium_button.dart';
import 'package:clwb_crm/screens/inventory/dialogs/base_dialog.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/widgets/production_tab/order_production_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class AddExpenseDialog extends GetView<ProductionController> {
  const AddExpenseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return OldBaseDialog(
      title: 'Add Expense',

      footer: Obx(() {
        return PremiumButton(
          text: controller.isSaving.value
              ? 'Saving...'
              : 'Add Expense',
          isLoading: controller.isSaving.value,
          onTap: controller.isSaving.value
              ? () {}
              : controller.submitExpense,
        );
      }),

      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Dropdown(
              label: 'Stage',
              items: const ['production', 'delivery', 'dispatch'],
              onChanged: controller.setExpenseStage,
            ),

            Dropdown(
              label: 'Category',
              items: const [
                'transport',
                'plant_fee',
                'labour',
                'packaging',
                'misc',
              ],
              onChanged: controller.setExpenseCategory,
            ),

            Field(
              label: 'Vendor Name',
              onChanged: controller.setVendor,
            ),

            Field(
              label: 'Total Amount',
              onChanged: controller.setExpenseAmount,
            ),

            Field(
              label: 'Paid Amount',
              onChanged: controller.setPaidAmount,
            ),

            // Obx(() {
            //   return
                Text(
                'Due: ₹${controller.expenseDue.value.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            // }),

            Field(
              label: 'Reference No (optional)',
              onChanged: controller.setReferenceNo,
            ),

            Field(
              label: 'Notes',
              maxLines: 2,
              onChanged: controller.setExpenseNotes,
            ),
          ],
        );
      }),
    );
  }
}



