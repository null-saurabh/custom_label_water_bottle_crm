// ✅ REUSABLE LIST ROW (USED BY: Due Today + Due Next Week)
import 'package:flutter/material.dart';

class DeliveryListRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String meta;
  final Color chipBg;
  final Color chipText;

  const DeliveryListRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.chipBg,
    required this.chipText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFD),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: chipBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              meta,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: chipText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
