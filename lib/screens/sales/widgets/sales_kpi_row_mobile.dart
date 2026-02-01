import 'package:clwb_crm/screens/sales/sales_controller.dart';

import 'package:flutter/material.dart';

class SalesKpiRowMobile extends StatelessWidget {
  final SalesController c;
  const SalesKpiRowMobile(this.c, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _KpiCard(
            title: 'Revenue',
            value: _money(c.revenue),
            accent: const Color(0xFF2563EB),
          ),
          const SizedBox(width: 12),
          _KpiCard(
            title: 'COGS',
            value: _money(c.cogs),
            accent: const Color(0xFFF59E0B),
          ),
          const SizedBox(width: 12),
          _KpiCard(
            title: 'Expenses',
            value: _money(c.operatingExpenses),
            accent: const Color(0xFFF59E0B),
          ),
          const SizedBox(width: 12),
          _KpiCard(
            title: 'Net Profit',
            value: _money(c.netProfit),
            accent: const Color(0xFF7C3AED),
          ),
          const SizedBox(width: 12),
          _KpiCard(
            title: 'Margin',
            value: '${c.profitMarginPct.toStringAsFixed(1)}%',
            accent: const Color(0xFF0EA5E9),
          ),
        ],
      ),
    );
  }

  String _money(double v) => '₹${v.toStringAsFixed(0)}';
}


class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final Color accent;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160, // 🔥 important for horizontal scroll
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EAF2)),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 6),
            color: accent.withOpacity(0.08),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}
