import 'package:clwb_crm/core/widgets/premium_button.dart';
import 'package:clwb_crm/screens/inventory/dialogs/base_dialog.dart';
import 'package:clwb_crm/screens/orders/dialog/controller/cancel_oder_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CancelOrderDialog extends GetView<CancelOrderController> {
  const CancelOrderDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final o = controller.order;

    return BaseDialog(
      title: 'Cancel Order',

      footer: Obx(
            () => PremiumButton(
          text: controller.isSaving.value
              ? 'Cancelling...'
              : 'Confirm Cancel',
          isLoading: controller.isSaving.value,
          onTap: controller.isSaving.value
              ? () {}
              : controller.submitCancel,
        ),
      ),

      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order #${o.orderNumber}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Field(
              label: 'Reason *',
              maxLines: 2,
              onChanged: controller.setReason,
            ),

            Field(
              label: 'Refund Amount (₹)',
              onChanged: controller.setRefund,
            ),

            SwitchListTile(
              title: const Text('Restock Materials'),
              value: controller.restockMaterials.value,
              onChanged: controller.toggleRestock,
            ),

            if (controller.restockMaterials.value) ...[
              Field(
                label:
                'Restock Bottles (max ${controller.availableProduced})',
                onChanged: controller.setRestockBottles,
              ),
              Field(
                label: 'Restock Caps',
                onChanged: controller.setRestockCaps,
              ),
              Field(
                label: 'Restock Labels',
                onChanged: controller.setRestockLabels,
              ),
              Field(
                label: 'Restock Packaging',
                onChanged: controller.setRestockPackaging,
              ),
            ],

            SwitchListTile(
              title:
              const Text('Write-off produced units'),
              value: controller.writeOffProduced.value,
              onChanged: controller.toggleWriteOff,
            ),

            const SizedBox(height: 8),

            Text(
              'Available Produced: ${controller.availableProduced}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        );
      }),
    );
  }
}
