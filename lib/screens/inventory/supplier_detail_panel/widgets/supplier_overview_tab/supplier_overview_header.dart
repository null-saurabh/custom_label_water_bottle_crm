import 'package:clwb_crm/core/utils/responsive.dart';
import 'package:clwb_crm/screens/inventory/dialogs/edit_supplier_dialog.dart';
import 'package:clwb_crm/screens/inventory/model/supplier_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupplierOverviewHeader extends StatelessWidget {
  final SupplierModel item;
  // final BottleConfig? bottleConfig;

  const SupplierOverviewHeader({
    super.key,
    required this.item,
    // this.bottleConfig,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(!context.isMobile)
        Container(
          height: 120,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.blue.shade50,
          ),
          child: Image.asset(
            'assets/icons/main_logo.png',
            height: 42,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // const SizedBox(width: 6),
                  IconButton(
                    onPressed: () {
                      Get.dialog(
                        EditSupplierDialog(supplier: item),
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 12),
              _spec('Item ID', item.id),
              _spec('Name', item.contactPerson ?? "N/A"),
              _spec('Contact', item.phone ?? "N/A"),
              // if (bottleConfig != null) ...[
              //   _spec('Size', '${bottleConfig!.sizeMl} ML'),
              //   _spec('Pack Size', '${bottleConfig!.packSize} Bottles'),
              //   _spec('Shape', bottleConfig!.shape),
              //   _spec('Neck', bottleConfig!.neckType),
              // ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _spec(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
