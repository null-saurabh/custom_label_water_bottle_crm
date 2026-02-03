import 'package:clwb_crm/core/widgets/date_picker_field.dart';
import 'package:clwb_crm/core/widgets/new_base_dialog.dart';
import 'package:clwb_crm/core/widgets/premium_button.dart';
import 'package:clwb_crm/screens/inventory/dialogs/base_dialog.dart';
import 'package:clwb_crm/screens/inventory/dialogs/controller/add_stock_controller.dart';
import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_stock_add_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddStockDialog extends StatelessWidget {
  const AddStockDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final inventoryController = Get.find<InventoryController>();
    // final supplierController = Get.find<SupplierController>();

    final c = Get.put(
      AddStockController(
        items: inventoryController.items,
        suppliers: inventoryController.suppliers,
      ),
    );

    return BaseDialog(
      title: 'Add Stock',
      footer: Obx(
            () => PremiumButton(
          text: c.isSaving.value ? 'Saving...' : 'Add Stock',
          onTap: c.isValid && !c.isSaving.value
              ? c.submit
              : () {
            Get.snackbar(
              'Error',
              'Please fill required fields',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ITEM
          Dropdown(
            label: 'Item',
            items: c.items.map((e) => e.name).toList(),
            onChanged: (v) {
              final item =
              c.items.firstWhere((e) => e.name == v);
              c.selectedItemId.value = item.id;
            },
          ),

          /// SUPPLIER
          Dropdown(
            label: 'Supplier',
            items: c.suppliers.map((e) => e.name).toList(),
            onChanged: (v) {
              final supplier =
              c.suppliers.firstWhere((e) => e.name == v);
              c.selectedSupplierId.value = supplier.id;
              c.selectedSupplier.value = supplier;
            },
          ),

          const Divider(height: 24),

          Field(
            label: 'Ordered Quantity',
            onChanged: (v) =>
            c.quantity.value = int.tryParse(v) ?? 0,
          ),
          Field(
            label: 'Rate per Unit',
            onChanged: (v) =>
            c.ratePerUnit.value = double.tryParse(v) ?? 0,
          ),

          Field(
            label: 'Received Quantity',
            onChanged: (v) =>
            c.receivedQuantity.value = int.tryParse(v) ?? 0,
          ),

        Obx(() {
          final status = c.resolveStatus(
            ordered: c.quantity.value,
            received: c.receivedQuantity.value,
          );

          return Text(
            status == DeliveryStatus.received
                ? 'Delivery Completed'
                : status == DeliveryStatus.partial
                ? 'Partial Delivery'
                : 'Delivery Pending',
            style: TextStyle(
              color: status == DeliveryStatus.received
                  ? Colors.green
                  : Colors.orange,
              fontWeight: FontWeight.w600,
            ),
          );
        }),

        Obx(() {
          final status = c.resolveStatus(
            ordered: c.quantity.value,
            received: c.receivedQuantity.value,
          );

          if (status == DeliveryStatus.received) {
            return const SizedBox.shrink();
          }

          return DatePickerField(
            label: 'Next Delivery Date',
            value: c.nextDeliveryDate.value, // ✅ shows selected date
            onChanged: (d) => c.nextDeliveryDate.value = d,
          );

        }),


        const Divider(height: 24),


          Field(
            label: 'Paid Amount',
            onChanged: (v) =>
            c.paidAmount.value = double.tryParse(v) ?? 0,
          ),
        ],
      ),
    );
  }
}
