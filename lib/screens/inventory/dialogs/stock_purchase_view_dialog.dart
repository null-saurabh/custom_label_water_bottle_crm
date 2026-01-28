import 'package:clwb_crm/screens/inventory/dialogs/base_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:clwb_crm/screens/inventory/model/inventory_stock_add_model.dart';
import 'controller/stock_purchase_view_controller.dart';

class StockPurchaseViewDialog extends StatelessWidget {
  final InventoryStockAddModel entry;
  const StockPurchaseViewDialog({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StockPurchaseViewController>(
      init: StockPurchaseViewController(entry),
      builder: (c) {
        return BaseDialog(
          title: 'Stock Purchase Details',
          child: Obx(() {
            final df = DateFormat('d MMM yyyy, hh:mm a');

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== Summary Card =====
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 18,
                        runSpacing: 8,
                        children: [
                          _kv('Supplier', c.supplierName),
                          _kv('Purchased', c.itemName),
                          _kv('Status', entry.status.name),
                          _kv('Ordered', '${entry.orderedQuantity}'),
                          _kv('Received', '${entry.receivedQuantity}'),
                          _kv('Pending', '${entry.orderedQuantity - entry.receivedQuantity}'),
                          _kv('Rate', '₹${entry.ratePerUnit.toStringAsFixed(2)}'),
                          _kv('Total', '₹${entry.totalAmount.toStringAsFixed(0)}'),
                          _kv('Paid', '₹${entry.paidAmount.toStringAsFixed(0)}'),
                          _kv('Due', '₹${entry.dueAmount.toStringAsFixed(0)}'),
                          _kv(
                            'Next Delivery',
                            entry.deliveryDate == null
                                ? '—'
                                : DateFormat('d MMM yyyy').format(entry.deliveryDate!),
                          ),
                          _kv(
                            'Due Date',
                            entry.dueDate == null
                                ? '—'
                                : DateFormat('d MMM yyyy').format(entry.dueDate!),
                          ),
                          _kv('Created', df.format(entry.createdAt)),
                          _kv('Updated', df.format(entry.updatedAt)),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ===== Activity Header =====
                Row(
                  children: [
                    const Text(
                      'Activity',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                    const Spacer(),
                    if (c.isLoading.value)
                      const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                // ===== Activity List =====
                if (c.timeline.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.receipt_long_outlined, color: Color(0xFF6B7280)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'No activity found for this purchase yet.',
                            style: TextStyle(color: Color(0xFF6B7280)),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: c.timeline.length,
                      separatorBuilder: (_, __) =>
                      const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
                      itemBuilder: (_, i) {
                        // print("1212");
                        print(c.timeline.length);
                        final t = c.timeline[i];
                        return ListTile(
                          dense: true,
                          leading: Icon(t.icon, color: const Color(0xFF6D5EF6), size: 20),
                          title: Text(
                            t.title,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            '${DateFormat('d MMM, hh:mm a').format(t.at)}'
                                '${t.subtitle == null || t.subtitle!.isEmpty ? '' : '\n${t.subtitle}'}',
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          }),
        );
      },
    );
  }

  static Widget _kv(String k, String v) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(k, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
          const SizedBox(height: 2),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
