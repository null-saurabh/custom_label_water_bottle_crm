import 'package:clwb_crm/core/widgets/date_picker_field.dart';
import 'package:clwb_crm/core/widgets/new_base_dialog.dart';
import 'package:clwb_crm/core/widgets/premium_button.dart';
import 'package:clwb_crm/screens/inventory/dialogs/base_dialog.dart';
import 'package:clwb_crm/screens/orders/dialog/controller/edit_order_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class EditOrderDialog extends GetView<EditOrderController> {
  const EditOrderDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final order = controller.order;

    return BaseDialog(
      title: 'Edit Order',

      footer: Obx(
            () => PremiumButton(
          text: controller.isSaving.value
              ? 'Saving...'
              : 'Save Changes',
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
            // CLIENT (LOCKED)
            // =====================
            Field(
              label: 'Client',
              controller: TextEditingController(
                text: order.clientNameSnapshot,
              ),
              enabled: false,
            ),

// =====================
// BOTTLE (LOCKED)
// =====================
            Field(
              label: 'Bottle',
              controller: TextEditingController(
                text: order.itemNameSnapshot,
              ),
              enabled: false,
            ),

            // =====================
            // CAP (EDITABLE)
            // =====================
            Dropdown(
              label: 'Cap',
              items: controller.capItems
                  .map((c) => c.name)
                  .toList(),
              value: controller.selectedCap.value?.name,
              onChanged: controller.setCapByName,
            ),

            // =====================
            // PACKAGING (EDITABLE)
            // =====================
            if (controller.packagingItems.isNotEmpty)
              Dropdown(
                label: 'Packaging',
                items: controller.packagingItems
                    .map((p) => p.name)
                    .toList(),
                value: controller.selectedPackaging.value?.name,
                onChanged: controller.setPackagingByName,
              ),

            // =====================
            // AUTO MATERIAL PREVIEW
            // =====================
            _ResolvedRow(
              label: 'Label',
              value: order.labelNameSnapshot,
            ),

            if (order.packagingNameSnapshot != null)
              _ResolvedRow(
                label: 'Packaging',
                value: order.packagingNameSnapshot!,
              ),

            const SizedBox(height: 16),

            // =====================
            // QUANTITY
            // =====================
            Field(
              label: 'Quantity (Bottles)',
              controller: controller.qtyCtrl, // 🔥
              onChanged: controller.setQty,
            ),
            // =====================
            // RATE
            // =====================
            Field(
              label: 'Rate per Bottle',
              controller: controller.rateCtrl, // 🔥
              onChanged: controller.setRate,
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
            // RECURRING
            // =====================
            SwitchListTile(
              title: const Text('Recurring Order'),
              value: controller.isRecurring.value,
              onChanged: controller.toggleRecurring,
            ),

            if (controller.isRecurring.value)
              Field(
                label: 'Repeat every (days)',
                controller: controller.recurringCtrl, // 🔥
                onChanged: controller.setRecurringInterval,
              ),

            // =====================
            // NOTES
            // =====================
            Field(
              label: 'Notes',
              maxLines: 3,
              controller: controller.notesCtrl, // 🔥
              onChanged: controller.setNotes,
            ),

            const SizedBox(height: 20),
          ],
        );
      }),
    );
  }
}



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

