import 'package:clwb_crm/screens/dashboard/widgets/order_this_week_card/widgets/legend_item.dart';
import 'package:flutter/material.dart';

class LegendRow extends StatelessWidget {
  const LegendRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        LegendItem(color: Color(0xFF4C6FFF), label: 'Delivered'),
        SizedBox(width: 14),
        LegendItem(color: Color(0xFF8AB4F8), label: 'Scheduled'),
        SizedBox(width: 14),
        LegendItem(color: Color(0xFF7CBFA2), label: 'New Orders'),
        Spacer(),
        Text(
          'Due 05 gents 2 >',
          style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}
