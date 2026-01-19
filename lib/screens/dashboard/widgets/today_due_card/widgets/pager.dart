// lib/features/dashboard/widgets/_pager.dart
import 'package:flutter/material.dart';

class Pager extends StatelessWidget {
  const Pager({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: const [
          Icon(Icons.chevron_left, size: 16),
          SizedBox(width: 4),
          Text('1', style: TextStyle(fontSize: 12)),
          SizedBox(width: 4),
          Icon(Icons.chevron_right, size: 16),
        ],
      ),
    );
  }
}
