import 'package:clwb_crm/core/widgets/blue_action_button.dart';
import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_stock_add_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupplierRecentTable extends GetView<InventoryController> {
  final String supplierId;

  const SupplierRecentTable({
    super.key,
    required this.supplierId,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final entries = controller.stockEntries
          .where((e) => e.supplierId == supplierId)
          .take(5)
          .toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  'Recent Stock Entries',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                BlueActionButton(
                  icon: Icons.add,
                  label: "Add Stock",
                  isPrimary: true,
                  onTap: controller.openAddStockDialog,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (entries.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No stock entries yet'),
            )
          else ...[
            _Header(),
            const Divider(),
            ...entries.map((e) => _Row(entry: e)),
          ],
        ],
      );
    });
  }
}


class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle style =
    TextStyle(color: Colors.grey.shade600, fontSize: 13);

    return Row(
      children: [
        _col('Date', style),
        _col('Quantity', style),
        _col('Pending Balance', style),
        _col('Status', style),
      ],
    );
  }
}



class _Row extends StatelessWidget {
  final InventoryStockAddModel entry;

  const _Row({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _cell(_fmt(entry.createdAt)),
          _cell(entry.orderedQuantity.toString()),
          _cell('₹${entry.dueAmount.toStringAsFixed(0)}'),
          _statusChip(entry.status.name),
        ],
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.day}/${d.month}/${d.year}';

  Widget _cell(String t) =>
      Expanded(child: Text(t));

  Widget _statusChip(String s) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          s,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}


Widget _col(String t, TextStyle s) =>
    Expanded(child: Text(t, style: s));
