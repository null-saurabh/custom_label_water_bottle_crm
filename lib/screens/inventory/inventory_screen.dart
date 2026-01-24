// inventory/inventory_screen.dart
import 'package:clwb_crm/screens/inventory/inventory_detail_panel_screen/inventory_detail_panel.dart';
import 'package:clwb_crm/screens/inventory/widgets/inventory_header.dart';
import 'package:clwb_crm/screens/inventory/widgets/items_table/inventory_item_table.dart';
import 'package:clwb_crm/screens/inventory/widgets/stat_card.dart';
import 'package:clwb_crm/screens/inventory/widgets/supplier_table/supplier_table.dart';
import 'package:flutter/material.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  bool showDetails = false;

  void openDetails() {
    setState(() => showDetails = true);
  }

  void closeDetails() {
    setState(() => showDetails = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),

      body: Stack(
        children: [
          _MainInventoryContent(onItemTap: openDetails),

          InventoryDetailPanel(isVisible: showDetails, onClose: closeDetails),
        ],
      ),
    );
  }
}

class _MainInventoryContent extends StatelessWidget {
  final VoidCallback onItemTap;

  const _MainInventoryContent({required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InventoryHeader(),
              SizedBox(height: 24),
              InventoryStatCards(),
              SizedBox(height: 24),
              InventoryItemsTable(onDetailTap: onItemTap),
              SizedBox(height: 24),
              InventorySupplierTable(onDetailTap: onItemTap),
            ],
          ),
        ),
      ),
    );
  }
}

//Scaffold(
//       backgroundColor: const Color(0xFFF6F8FC),
//
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: const [
//               InventoryHeader(),
//               SizedBox(height: 24),
//               InventoryStatCards(),
//               SizedBox(height: 24),
//               InventoryItemsTable(),
//               SizedBox(height: 24),
//               InventorySupplierTable(),
//             ],
//           ),
//         ),
//       )
//       ,
//     );
