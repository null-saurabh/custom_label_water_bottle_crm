import 'package:flutter/material.dart';

class OverviewWarning extends StatelessWidget {
  const OverviewWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded,
              color: Colors.orange.shade700),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Low Stock: Need 2000 Sealed Bottles',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
