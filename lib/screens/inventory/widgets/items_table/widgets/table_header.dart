import 'package:clwb_crm/core/theme/constants.dart';
import 'package:flutter/material.dart';

class TableHeader extends StatelessWidget {
  const TableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
      color: Colors.black54,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
      decoration: BoxDecoration(
        gradient: AppGradients.subtleCool
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _col('Item', 2, style),
          _col('In Stock', 1, style),
          _col('Order Due', 1.2, style, subText: 'This Week'),
          _col('Order Due', 1.4, style, subText: 'This Month'),
          _col('Current Stock Value', 1.4, style),
          _col('Sold Stock Value', 1.4, style),
          const SizedBox(width: 32),
        ],
      ),
    );

  }
}


Widget _col(
    String text,
    double flex,
    TextStyle style, {
      String? subText,
      TextStyle? subStyle,
    }) {
  return Expanded(
    flex: (flex * 10).toInt(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: style),
        if (subText != null) ...[
          const SizedBox(height: 2),
          Text(
            subText,
            style: subStyle ??
                style.copyWith(
                  fontSize: (style.fontSize ?? 12) - 4,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ],
      ],
    ),
  );
}
