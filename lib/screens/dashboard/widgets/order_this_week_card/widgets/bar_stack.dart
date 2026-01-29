import 'package:flutter/material.dart';

class BarStack extends StatelessWidget {
  final int delivered;
  final int scheduled;
  final int maxTotal;

  const BarStack({super.key,
    required this.delivered,
    required this.scheduled,
    required this.maxTotal,
  });

  @override
  Widget build(BuildContext context) {
    const maxHeight = 90.0;
    final total = delivered + scheduled ;

    double h(int v) =>
        maxTotal == 0 ? 0 : (v / maxTotal) * maxHeight;

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(height: h(scheduled), color: const Color(0xFF8AB4F8)),
          Container(height: h(delivered), color: const Color(0xFF4C6FFF)),
        ],
      ),
    );
  }
}
