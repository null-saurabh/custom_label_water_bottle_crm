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
      // 1️⃣ Get stock entries for supplier
      final stocks = controller.stockEntries
          .where((e) => e.supplierId == supplierId)
          .toList();

      if (stocks.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Text('No supplier activity yet'),
        );
      }

      // 2️⃣ Build activity rows
      final rows = <_SupplierActivityRow>[];

      for (final s in stocks) {
        final itemName = controller.itemName(s.itemId);

        // 🔹 Stock order created
        rows.add(
          _SupplierActivityRow(
            date: s.createdAt,
            item: itemName,
            event: 'Stock Ordered',
            value: '${s.orderedQuantity} units',
            status: s.status.name,
          ),
        );

        // 🔹 Stock received (from activities)
        final receives = controller.inventoryActivitiesForItem(s.itemId)
            .where((a) =>
        a.referenceId == s.id &&
            a.referenceType == 'inventory_stock' &&
            a.stockDelta > 0)
            .toList();

        for (final a in receives) {
          rows.add(
            _SupplierActivityRow(
              date: a.createdAt,
              item: itemName,
              event: 'Stock Received',
              value: '+${a.stockDelta}',
              status: s.status.name,
            ),
          );
        }

        // 🔹 Payments (system bucket)
        final payments = controller.systemInventoryActivities
            .where((a) =>
        a.referenceId == s.id &&
            a.referenceType == 'inventory_stock' &&
            a.type == 'supplier_payment')
            .toList();

        for (final p in payments) {
          rows.add(
            _SupplierActivityRow(
              date: p.createdAt,
              item: itemName,
              event: 'Payment',
              value: '₹${p.amount?.toStringAsFixed(0) ?? '—'}',
              status: 'paid',
            ),
          );
        }
      }

      rows.sort((a, b) => b.date.compareTo(a.date));
      final recent = rows.take(6).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Recent Supplier Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 12),
          const _SupplierHeader(),
          const SizedBox(height: 8),
          ...recent.map((r) => _SupplierRow(row: r)),
        ],
      );
    });
  }
}



class _SupplierHeader extends StatelessWidget {
  const _SupplierHeader();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: Color(0xFF6B7280),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: const [
          Expanded(flex: 4, child: Text('Date', style: style)),
          Expanded(flex: 5, child: Text('Item', style: style)),
          Expanded(flex: 4, child: Text('Event', style: style)),
          Expanded(flex: 3, child: Text('Value', style: style)),
          Expanded(flex: 3, child: Text('Status', style: style)),
        ],
      ),
    );
  }
}

class _SupplierRow extends StatelessWidget {
  final _SupplierActivityRow row;

  const _SupplierRow({required this.row});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          _cell(_fmt(row.date), 4),
          _cell(row.item, 5),
          _cell(row.event, 4),
          _cell(row.value, 3),
          _cell(row.status, 3),
        ],
      ),
    );
  }

  Widget _cell(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
}

class _SupplierActivityRow {
  final DateTime date;
  final String item;
  final String event;
  final String value;
  final String status;

  _SupplierActivityRow({
    required this.date,
    required this.item,
    required this.event,
    required this.value,
    required this.status,
  });
}
