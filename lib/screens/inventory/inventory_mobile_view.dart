import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/mobile_view_widgets/inventory_item_list_mobile.dart';
import 'package:clwb_crm/screens/inventory/mobile_view_widgets/inventory_stat_card_mobile.dart';
import 'package:clwb_crm/screens/inventory/mobile_view_widgets/inventory_supplier_list_mobile.dart';
import 'package:clwb_crm/screens/inventory/mobile_view_widgets/stock_purchase_card_mobile.dart';
import 'package:clwb_crm/screens/inventory/widgets/inventory_warnings_panel/inventory_warnings_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class InventoryMobileView extends GetView<InventoryController> {
  const InventoryMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
      children: const [
        /// Header (title only)
        Text(
          'Inventory',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),


        SizedBox(height: 16),

        /// Stat cards (horizontal scroll)
        InventoryStatCardsMobile(),

        SizedBox(height: 16),

        InventoryWarningsPanel(),
        SizedBox(height: 16),

        InventoryStockPurchasesMobilePanel(),
        SizedBox(height: 16),

        InventoryItemsMobileList(),
        SizedBox(height: 16),

        InventorySuppliersMobileList(),
      ],
    );
  }
}
