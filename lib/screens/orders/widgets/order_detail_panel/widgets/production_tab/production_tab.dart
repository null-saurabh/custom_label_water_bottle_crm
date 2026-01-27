import 'package:clwb_crm/core/widgets/premium_button.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/widgets/production_tab/dialogs/add_client_payment_dialog.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/widgets/production_tab/dialogs/add_delivery_dialog.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/widgets/production_tab/dialogs/add_expense_dialog.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/widgets/production_tab/dialogs/add_production_dialog.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/widgets/production_tab/order_production_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductionTab extends StatelessWidget {
  final OrderModel order;

  const ProductionTab({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductionController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.bindOrder(order);
    });

    return Obx(() {
      final o = controller.order.value;
      if (o == null) return const SizedBox();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// SUMMARY
          Obx(() {
            final o = controller.order.value!;
            final produced = o.producedQuantity;
            final delivered = o.deliveredQuantity;
            final ordered = o.orderedQuantity;

            final remainingToProduce = ordered - produced;
            final remainingToDeliver = ordered - delivered;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Produced: $produced / $ordered   '
                  'Delivered: $delivered / $ordered',
                  style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 14),
                ),

                const SizedBox(height: 4),

                Text(
                  'Remain Prod: $remainingToProduce   '
                  'Remain Del: $remainingToDeliver',
                ),

                const SizedBox(height: 8),

                Text(
                  'Revenue Earned: ₹${controller.revenueEarned.toStringAsFixed(2)}',
                ),
                Text(
                  'Revenue Collected: ₹${controller.revenueCollected.toStringAsFixed(2)}',
                ),

                const SizedBox(height: 4),

                Text(
                  'Expenses Incurred: ₹${controller.totalExpensesIncurred.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.redAccent),
                ),
                Text(
                  'Expenses Paid: ₹${controller.totalExpensesPaid.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.orange),
                ),

                const SizedBox(height: 6),

                Text(
                  'Profit (Accrual): ₹${controller.profitAccrual.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Cash Flow: ₹${controller.cashFlow.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: controller.cashFlow >= 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Client Due: ₹${o.dueAmount.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            );
          }),

          const SizedBox(height: 12),

          /// ACTION ROW 🔥
          Row(
            children: [
              actionButton(
                label: '+ Production',
                onTap: () => Get.dialog(AddProductionDialog()),
              ),

              const SizedBox(width: 8),
              actionButton(
                label: '+ Delivery',
                onTap: () => Get.dialog(AddDeliveryDialog()),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [

              actionButton(
                label: '+ Expense',
                onTap: () => Get.dialog(AddExpenseDialog()),
              ),
              const SizedBox(width: 8),
              actionButton(
                label: '+ Payment',
                onTap: () => Get.dialog(AddClientPaymentDialog()),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// UNIFIED TIMELINE 🔥
          Expanded(
            child: ListView.builder(
              itemCount: controller.timeline.length,
              itemBuilder: (_, i) {
                final item = controller.timeline[i];
                return ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.title),
                  subtitle: Text(item.subtitle),
                  trailing: Text(item.trailing),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

Widget actionButton({
  required String label,
  IconData? icon,
  required VoidCallback onTap,
}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11, // Small font for tight width
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
