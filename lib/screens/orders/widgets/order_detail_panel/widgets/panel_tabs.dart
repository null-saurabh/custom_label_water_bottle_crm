import 'package:flutter/material.dart';

class PanelTabs extends StatefulWidget {
  const PanelTabs({super.key});

  @override
  State<PanelTabs> createState() => _PanelTabsState();
}

class _PanelTabsState extends State<PanelTabs> {
  int active = 0;

  final tabs = const ['Overview', 'Production', 'Activity'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(tabs.length, (i) {
        final isActive = active == i;

        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() => active = i);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive ? Colors.blue : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                tabs[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight:
                  isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
