import 'package:clwb_crm/core/theme/constants.dart';
import 'package:flutter/material.dart';

class SupplierHeader extends StatelessWidget {
  const SupplierHeader({super.key});

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
          _col('Name', 1.6, style),
          _col('Items Supplied', 1.5, style),
          _col('Orders', 1, style),
          _col('Next Due Delivery', 1.2, style, subText: 'This Week'),
          _col('Pending Value', 1.4, style),
          _col('Total Value', 1.2, style),
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
