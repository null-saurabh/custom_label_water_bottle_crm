import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:flutter/material.dart';

class OrdersTableRow extends StatelessWidget {
  final OrderModel order;
  final bool isSelected;
  const OrdersTableRow({
    super.key,
    required this.order, required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isHigh = order.isPriority;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        gradient: isHigh
        ? LinearGradient(
        colors: [
        const Color(0xFFF7F9FF),
    const Color(0xFFEFF3FF),
    ],
    )
        : null,),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(isHigh ? 18 : 0),
            border: Border.all(
              color: isHigh ? const Color(0xFFE5ECFF) : Colors.transparent,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Order + Priority
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.orderNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _PriorityTag(isHigh),
                      ],
                    ),
                  ),

                  // Client
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.clientNameSnapshot,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${order.orderedQuantity} Bottles',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Items
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${order.orderedQuantity} Bottles',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),

                  // Progress
                  Expanded(
                    flex: 3,
                    child: _ProgressBlock(order),
                  ),

                  // Delivery
                  Expanded(
                    flex: 2,
                    child: _DeliveryBlock(order),
                  ),

                  // Status + Arrow
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        _StatusBadge(order.orderStatus),
                        const Spacer(),
                        const Icon(
                          Icons.chevron_right,
                          color: Color(0xFF9CA3AF),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (!isHigh)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Divider(height: 1),
                ),
            ],
          ),
        ),
      ),
    );
  }
}




class _ProgressBlock extends StatelessWidget {
  final OrderModel order;
  const _ProgressBlock(this.order);

  @override
  Widget build(BuildContext context) {
    final progress = order.orderedQuantity == 0
        ? 0.0
        : order.producedQuantity / order.orderedQuantity;

    return Padding(
      padding: const EdgeInsets.only(right: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFE5E7EB),
              color: const Color(0xFF6366F1),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${order.producedQuantity} / ${order.orderedQuantity}',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
class _DeliveryBlock extends StatelessWidget {
  final OrderModel order;
  const _DeliveryBlock(this.order);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          order.deliveredQuantity == order.orderedQuantity
              ? '${order.deliveredQuantity} Delivered'
              : '${order.deliveredQuantity} / ${order.orderedQuantity}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          _fmt(order.expectedDeliveryDate),
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
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
