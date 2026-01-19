// lib/features/dashboard/widgets/inventory_warning_row.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../dashboard_controller.dart';

class InventoryWarningRow extends StatelessWidget {
  final InventoryWarning data;

  const InventoryWarningRow({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    Color shortfallColor =
    data.shortfall > 0 ? const Color(0xFFD32F2F) : const Color(0xFF2E7D32);

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
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      data.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 2,),
                    data.isBottle == true ?Icon(CupertinoIcons.pin,size: 10,):SizedBox()
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  data.sizeCode,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          _ValueCell(label: 'Order', value: data.due.toString()),
          _Divider(),
          _ValueCell(
            label: 'Shortfall',
            value: data.shortfall.toString(),
            valueColor: shortfallColor,
          ),
          _Divider(),
          _ValueCell(
            label: 'Stock',
            value: data.stock.toString(),
            valueColor: const Color(0xFF4C6FFF),
          ),
        ],
      ),
    );
  }
}

class _ValueCell extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _ValueCell({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: valueColor ?? const Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: const Color(0xFFE5E7EB),
    );
  }
}