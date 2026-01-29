import 'package:clwb_crm/screens/inventory/dialogs/base_dialog.dart';
import 'package:clwb_crm/screens/orders/dialog/controller/add_order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/premium_button.dart';
import '../../../core/widgets/date_picker_field.dart';

class AddOrderDialog extends GetView<AddOrderController> {
  const AddOrderDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'Add Order',

      footer: Obx(
            () => PremiumButton(
          text: controller.isSaving.value
              ? 'Creating...'
              : 'Create Order',
          isLoading: controller.isSaving.value,
          onTap: controller.isSaving.value
              ? () {}
              : controller.submit,
        ),
      ),

      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================
            // CLIENT
            // =====================
            Dropdown(
              label: 'Client',
              items: controller.clients
                  .map((c) => c.businessName)
                  .toList(),
              onChanged: controller.setClientByName,
            ),

            // =====================
            // BOTTLE
            // =====================
            Dropdown(
              label: 'Bottle',
              items: controller.bottleItems
                  .map((i) => i.name)
                  .toList(),
              onChanged: controller.setItemByName,
            ),

            Dropdown(
              label: 'Cap',
              items: controller.capItems
                  .map((c) => c.name)
                  .toList(),
              onChanged: controller.setCapByName,
            ),

            // =====================
            // AUTO-RESOLVED MATERIAL PREVIEW
            // =====================
        Obx(
        () =>
              _ResolvedRow(
                label: 'Label',
                value:
                controller.resolvedLabel.value != null ?controller.resolvedLabel.value!.name: "Not Selected",
              ),),


            if (controller.resolvedPackaging.value != null)
              _ResolvedRow(
                label: 'Packaging',
                value: controller
                    .resolvedPackaging.value!.name,
              ),

            const SizedBox(height: 16),

            // =====================
            // QUANTITY & RATE
            // =====================
            Field(
              label: 'Quantity (Bottles)',
              onChanged: controller.setQty,
            ),

            Field(
              label: 'Rate per Bottle',
              onChanged: controller.setRate,
            ),

            // =====================
            // ADVANCE PAYMENT 🔥
            // =====================
            Field(
              label: 'Advance Payment (₹)',
              onChanged: controller.setAdvancePaid,
            ),

            // =====================
            // DELIVERY DATE
            // =====================
            DatePickerField(
              label: 'Delivery Date',
              value: controller.deliveryDate.value,
              onChanged: controller.setDeliveryDate,
            ),

            // =====================
            // PRIORITY
            // =====================
            SwitchListTile(
              title: const Text('Priority Order'),
              value: controller.isPriority.value,
              onChanged: controller.togglePriority,
            ),

            // =====================
            // RECURRING 🔁
            // =====================
            SwitchListTile(
              title: const Text('Recurring Order'),
              value: controller.isRecurring.value,
              onChanged: controller.toggleRecurring,
            ),

            if (controller.isRecurring.value)
              Field(
                label: 'Repeat every (days)',
                onChanged:
                controller.setRecurringInterval,
              ),

            // =====================
            // NOTES 📝
            // =====================
            Field(
              label: 'Notes',
              maxLines: 3,
              onChanged: controller.setNotes,
            ),

            const SizedBox(height: 20),
          ],
        );
      }),
    );
  }
}

// =====================
// SMALL HELPER WIDGET
// =====================

class _ResolvedRow extends StatelessWidget {
  final String label;
  final String value;

  const _ResolvedRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
