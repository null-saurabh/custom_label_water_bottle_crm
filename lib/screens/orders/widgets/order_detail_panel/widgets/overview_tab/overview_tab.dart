import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/widgets/overview_tab/overview_inventory_warning.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/widgets/overview_tab/overview_summary_card.dart';
import 'package:flutter/material.dart';


class OverviewTab extends StatelessWidget {
  final OrderModel order;

  const OverviewTab({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _InfoRow('Client', order.clientNameSnapshot),
        _InfoRow('Order Value', order.totalAmount.toString()),
        _InfoRow('Payment', order.paidAmount.toString(),valueColor: Colors.green),
        _InfoRow('Rate', order.ratePerBottle.toString()),
        _InfoRow(
          'Delivery Date',
          _fmt(order.expectedDeliveryDate),
        ),
        _InfoRow(
          'Order Date',
          _fmt(order.createdAt),
        ),
        _InfoRow(
          'Priority',
          order.isPriority ? 'High' : 'Normal',
          valueColor:
          order.isPriority ? Colors.red : Colors.grey,
        ),
        const SizedBox(height: 16),
        OverviewSummaryCard(order: order),
        const SizedBox(height: 16),
        if (order.remainingQuantity > 0)
          const OverviewInventoryWarning(),
      ],
    );
  }

  String _fmt(DateTime? d) {
    if (d == null) return '-';
    return '${d.day.toString().padLeft(2, '0')} '
        '${_months[d.month - 1]} ${d.year}';
  }

  static const _months = [
    'Jan','Feb','Mar','Apr','May','Jun',
    'Jul','Aug','Sep','Oct','Nov','Dec',
  ];
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow(
      this.label,
      this.value, {
        this.valueColor,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
