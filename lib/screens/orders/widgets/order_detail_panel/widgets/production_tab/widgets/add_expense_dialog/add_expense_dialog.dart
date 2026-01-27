import 'package:clwb_crm/core/widgets/premium_button.dart';
import 'package:clwb_crm/screens/inventory/dialogs/base_dialog.dart';
import 'package:clwb_crm/screens/orders/models/order_expense_model.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/widgets/production_tab/order_production_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddExpenseDialog extends StatefulWidget {
  final OrderModel order;
  const AddExpenseDialog({super.key, required this.order});

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final amountCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final vendorCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  String stage = 'production';
  String category = 'plant_charge';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductionController>();

    return BaseDialog(
      title: "Add Expense",
      footer: PremiumButton(
        text: "Save",
        onTap: () async {
          final amt = double.tryParse(amountCtrl.text) ?? 0;
          if (amt <= 0) return;

          final expense = OrderExpenseModel(
            id: '',
            orderId: widget.order.id,
            stage: stage,
            category: category,
            description: descCtrl.text,
            amount: amt,
            paidAmount: amt,
            dueAmount: 0,
            vendorName: vendorCtrl.text,
            referenceNo: null,
            expenseDate: DateTime.now(),
            status: 'paid',
            createdBy: 'admin',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          await controller.addExpense(
            amount: double.parse(amountCtrl.text),
            category: "production",
            vendor: vendorCtrl.text,
            description: notesCtrl.text,
          );

          Get.back();
        },
      ),
      child: Column(
        children: [
          Field(label: "Amount", onChanged: (v) => amountCtrl.text = v),
          Field(label: "Vendor", onChanged: (v) => vendorCtrl.text = v),
          Field(label: "Description", onChanged: (v) => descCtrl.text = v),
        ],
      ),
    );
  }
}
