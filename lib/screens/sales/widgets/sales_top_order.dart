import 'package:clwb_crm/screens/sales/sales_controller.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_card.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_empty_state.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_row_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesTopOrders extends StatelessWidget {
  final SalesController c;
  const SalesTopOrders(this.c, {super.key});

  @override
  Widget build(BuildContext context) {
    final entries = c.revenueByOrder.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return SalesCard(
      title: 'Top Orders',
      subtitle: c.rangeLabel,
      child: entries.isEmpty
          ? const SalesEmptyState('No order sales yet.')
          : ListView.separated(
              itemCount: entries.length.clamp(0, 8),
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final e = entries[i];
                final order = c.orders.firstWhereOrNull((o) => o.id == e.key);

                final label = order == null
                    ? 'Order ${e.key}'
                    : 'Order ${order.orderNumber} • ${order.clientNameSnapshot}';

                return SalesRowTile(label, '₹${e.value.toStringAsFixed(0)}');
              },
            ),
    );
  }
}

