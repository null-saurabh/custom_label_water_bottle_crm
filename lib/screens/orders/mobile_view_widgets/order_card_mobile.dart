import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:flutter/material.dart';

class OrderMobileCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const OrderMobileCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress = order.orderedQuantity == 0
        ? 0.0
        : order.producedQuantity / order.orderedQuantity;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border:
          Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ORDER + PRIORITY
            Row(
              children: [
                Text(
                  order.orderNumber,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                _PriorityTag(order.isPriority),
              ],
            ),

            const SizedBox(height: 6),

            // CLIENT
            Text(
              order.clientNameSnapshot,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 4),

            // ITEM
            Text(
              '${order.itemNameSnapshot} · ${order.orderedQuantity} Bottles',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
              ),
            ),

            const SizedBox(height: 10),

            // PROGRESS
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor:
                const Color(0xFFE5E7EB),
                color: const Color(0xFF6366F1),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              '${order.producedQuantity} / ${order.orderedQuantity} Produced',
              style: const TextStyle(fontSize: 12),
            ),

            const SizedBox(height: 10),

            // DELIVERY + STATUS
            Row(
              children: [
                Text(
                  _fmt(order.expectedDeliveryDate),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const Spacer(),
                _StatusBadge(order.orderStatus),
              ],
            ),
          ],
        ),
      ),
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


class _PriorityTag extends StatelessWidget {
  final bool isHigh;

  const _PriorityTag(this.isHigh);

  @override
  Widget build(BuildContext context) {
    if (!isHigh) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Open',
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF2563EB),
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'High',
        style: TextStyle(
          fontSize: 11,
          color: Color(0xFFDC2626),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case 'in_production':
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFB45309);
        label = 'In Production';
        break;

      case 'completed':
        bg = const Color(0xFFD1FAE5);
        fg = const Color(0xFF047857);
        label = 'Delivered';
        break;

      case 'ready':
        bg = const Color(0xFFE0F2FE);
        fg = const Color(0xFF0369A1);
        label = 'Ready';
        break;

      case 'cancelled':
        bg = const Color(0xFFFEE2E2); // soft red
        fg = const Color(0xFFB91C1C); // deep red
        label = 'Cancelled';
        break;

      case 'partially_delivered':
        bg = const Color(0xFFFEF3C7); // amber-ish (same family as in_production)
        fg = const Color(0xFF92400E); // darker amber
        label = 'Partially Delivered';
        break;

      case 'pending':
        bg = const Color(0xFFE5E7EB); // light gray
        fg = const Color(0xFF6B7280); // muted gray
        label = 'Pending';
        break;

      default:
        bg = const Color(0xFFF3F4F6);
        fg = const Color(0xFF374151);
        label = status;
    }


    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}