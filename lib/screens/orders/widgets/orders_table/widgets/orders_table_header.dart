import 'package:flutter/material.dart';

class OrdersTableHeader extends StatelessWidget {
  const OrdersTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: const [
          _HeaderCol('Order', 2),
          _HeaderCol('Client', 3),
          _HeaderCol('Items', 2),
          _HeaderCol('Progress', 3),
          _HeaderCol('Delivery  >', 2),
          _HeaderCol('Status', 2),
        ],
      ),
    );
  }
}

class _HeaderCol extends StatelessWidget {
  final String label;
  final int flex;

  const _HeaderCol(this.label, this.flex);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF6B7280), // subtle gray like UI
        ),
      ),
    );
  }
}
