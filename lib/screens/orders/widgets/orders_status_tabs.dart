import 'package:flutter/material.dart';

class OrdersStatusTabs extends StatefulWidget {
  const OrdersStatusTabs({super.key});

  @override
  State<OrdersStatusTabs> createState() => _OrdersStatusTabsState();
}

class _OrdersStatusTabsState extends State<OrdersStatusTabs> {
  int activeIndex = 0;

  final tabs = const [
    'All',
    'In Production',
    'Ready',
    'Delivered',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(tabs.length, (i) {
          final isActive = activeIndex == i;

          return GestureDetector(
            onTap: () {
              setState(() => activeIndex = i);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isActive ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  if (i == 1) ...[
                    const Icon(Icons.trending_up, size: 16),
                    const SizedBox(width: 6),
                  ],
                  if (i == 2) ...[
                    const Icon(Icons.check_circle, size: 16),
                    const SizedBox(width: 6),
                  ],
                  if (i == 3) ...[
                    const Icon(Icons.local_shipping, size: 16),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    tabs[i],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
