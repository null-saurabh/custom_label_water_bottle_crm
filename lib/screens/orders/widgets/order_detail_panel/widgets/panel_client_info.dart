import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:flutter/material.dart';

class PanelClientInfo extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onEdit;

  const PanelClientInfo({
    super.key,
    required this.order, required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.blue.shade100,
          child: Text(
            order.clientNameSnapshot[0],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.clientNameSnapshot,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
               Text(
                order.itemNameSnapshot,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onEdit,
        ),
      ],
    );
  }
}
