import 'package:flutter/material.dart';

class InventoryDetailPanelTabSwitcher extends StatefulWidget {
  const InventoryDetailPanelTabSwitcher({super.key});

  @override
  State<InventoryDetailPanelTabSwitcher> createState() => _InventoryDetailTabsState();
}

class _InventoryDetailTabsState extends State<InventoryDetailPanelTabSwitcher> {
  int selectedIndex = 0;

  final tabs = const [
    'Overview',
    'Recent Transactions',
  ];

  final width = const [
    44.0,
    96.0,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffebe7f7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              tabs.length,
                  (index) => _TabItem(
                title: tabs[index],
                width: width[index],
                isActive: selectedIndex == index,
                onTap: () {
                  setState(() => selectedIndex = index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final double width;
  final VoidCallback onTap;

  const _TabItem({
    required this.title,
    required this.isActive,
    required this.onTap, required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).primaryColor;

    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 6,
            right: 24,
            // bottom: ,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.blue : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: isActive ?  width: 0,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
