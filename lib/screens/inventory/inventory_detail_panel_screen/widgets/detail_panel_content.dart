import 'package:flutter/material.dart';

class InventoryPanelDetail extends StatelessWidget {
  const InventoryPanelDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          // Image + specs
          // Supplier
          // Stock values
          // Low stock warning
          // Tabs (Overview / Orders / Transactions / Config)
          // Table inside
          SizedBox(height: 600), // placeholder
        ],
      ),
    );
  }
}
