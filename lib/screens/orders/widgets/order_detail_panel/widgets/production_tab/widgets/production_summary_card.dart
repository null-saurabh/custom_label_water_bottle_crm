import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:flutter/material.dart';

class ProductionSummaryCard extends StatelessWidget {
  final OrderModel order;

  const ProductionSummaryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final percent = order.orderedQuantity == 0
        ? 0.0
        : (order.producedQuantity / order.orderedQuantity);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Production Progress",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),

          LinearProgressIndicator(
            value: percent,
            minHeight: 8,
            backgroundColor: const Color(0xFFE5E7EB),
            color: const Color(0xFF6366F1),
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Produced: ${order.producedQuantity}"),
              Text(
                "Remaining: ${order.orderedQuantity - order.producedQuantity}",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
