import 'package:flutter/material.dart';

class OverviewInventoryWarning extends StatelessWidget {
  const OverviewInventoryWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: Row(
        children: const [
          Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFEA580C),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Low Inventory:\nNeed 80 bottles in production.',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF9A3412),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
