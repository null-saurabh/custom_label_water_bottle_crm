import 'package:clwb_crm/screens/sales/sales_controller.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_card.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrendCard extends StatelessWidget {
  final SalesController c;
  const TrendCard(this.c, {super.key});

  @override
  Widget build(BuildContext context) {
    final points = c.trendPoints;
    final maxRev = points.fold<double>(
      0,
          (m, e) => e.revenue > m ? e.revenue : m,
    );

    return SalesCard(
      title: 'Sales Trend',
      subtitle: c.rangeLabel,
      child: points.isEmpty
          ? const SalesEmptyState('No deliveries in this period.')
          : ListView.separated(
        itemCount: points.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final p = points[i];
          final w = maxRev <= 0 ? 0.0 : (p.revenue / maxRev);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 86,
                  child: Text(
                    DateFormat('dd MMM').format(p.day),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 12,
                      color: const Color(0xFFF1F4FA),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: w.clamp(0, 1),
                          child: Container(
                            color: const Color(0xFF4C6FFF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 110,
                  child: Text(
                    '₹${p.revenue.toStringAsFixed(0)}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.w700),
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