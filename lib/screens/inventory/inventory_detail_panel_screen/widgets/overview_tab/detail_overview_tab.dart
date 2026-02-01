import 'package:clwb_crm/core/utils/responsive.dart';
import 'package:clwb_crm/screens/inventory/inventory_detail_panel_screen/widgets/overview_tab/item_supplier_section.dart';
import 'package:clwb_crm/screens/inventory/inventory_detail_panel_screen/widgets/overview_tab/low_stock_warning.dart';
import 'package:clwb_crm/screens/inventory/inventory_detail_panel_screen/widgets/overview_tab/overview_header.dart';
import 'package:clwb_crm/screens/inventory/inventory_detail_panel_screen/widgets/overview_tab/overview_recent_table.dart';
import 'package:clwb_crm/screens/inventory/inventory_detail_panel_screen/widgets/overview_tab/overview_stock_card.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_item_detail.dart';
import 'package:flutter/material.dart';




class InventoryOverviewTab extends StatelessWidget {
  final InventoryItemDetail detail;
  // final InventoryItemModel item;


  const InventoryOverviewTab({
    super.key, required this.detail,
    // required this.item,

  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.isMobile? 8 :16),
          child: OverviewHeader(detail: detail)
        ),
        const SizedBox(height: 20),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: context.isMobile? 8 :16),
          child: OverviewStockCards(item: detail.item),
        ),
        const SizedBox(height: 16),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: context.isMobile? 8 :16),
          child: OverviewWarning(item: detail.item),
        ),

        const SizedBox(height: 24),

        Padding(
          padding:  EdgeInsets.symmetric(horizontal:context.isMobile? 8 : 16),
          child: ItemSuppliersSection(
            itemId: detail.item.id,
          ),
        ),

        const SizedBox(height: 24),
        OverviewRecentTable(itemId: detail.item.id),
        const SizedBox(height: 24),
      ],
    );
  }
}

