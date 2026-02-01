import 'package:clwb_crm/screens/sales/sales_controller.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_card.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesDeliveriesTable extends StatelessWidget {
  final SalesController c;
  const SalesDeliveriesTable(this.c, {super.key});

  @override
  Widget build(BuildContext context) {
    final list = c.deliveriesInRange.toList()
      ..sort((a, b) => b.deliveryDate.compareTo(a.deliveryDate));

    final orderMap = {for (final o in c.orders) o.id: o};

    return SalesCard(
      title: 'Sales Table (Deliveries)',
      subtitle: c.rangeLabel,
      child: list.isEmpty
          ? const SalesEmptyState('No deliveries found.')
          : ListView.separated(
        shrinkWrap: true, // ✅ REQUIRED here
        physics: const BouncingScrollPhysics(),
        itemCount: list.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final d = list[i];
          final o = orderMap[d.orderId];

          final client = o?.clientNameSnapshot ?? 'Unknown client';
          final orderNo = o?.orderNumber ?? d.orderId;
          final rate = o?.ratePerBottle ?? 0;
          final revenue = d.quantityDeliveredToday * rate;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 92,
                  child: Text(
                    DateFormat('dd MMM').format(d.deliveryDate),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Order $orderNo • $client',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 70,
                  child: Text(
                    '+${d.quantityDeliveredToday}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 14),
                SizedBox(
                  width: 110,
                  child: Text(
                    '₹${revenue.toStringAsFixed(0)}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}



