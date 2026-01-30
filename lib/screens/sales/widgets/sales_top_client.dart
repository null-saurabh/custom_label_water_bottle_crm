import 'package:clwb_crm/screens/sales/sales_controller.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_card.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_empty_state.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_row_tile.dart';
import 'package:flutter/material.dart';

class TopClients extends StatelessWidget {
  final SalesController c;
  const TopClients(this.c, {super.key});

  @override
  Widget build(BuildContext context) {
    final entries = c.revenueByClient.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return SalesCard(
      title: 'Top Clients',
      subtitle: c.rangeLabel,
      child: entries.isEmpty
          ? const SalesEmptyState('No client sales yet.')
          : ListView.separated(
        itemCount: entries.length.clamp(0, 8),
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final e = entries[i];
          return SalesRowTile(e.key, '₹${e.value.toStringAsFixed(0)}');
        },
      ),
    );
  }
}
