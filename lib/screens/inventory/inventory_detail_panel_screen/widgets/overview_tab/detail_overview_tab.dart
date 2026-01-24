import 'package:clwb_crm/screens/inventory/inventory_detail_panel_screen/widgets/overview_tab/low_stock_warning.dart';
import 'package:clwb_crm/screens/inventory/inventory_detail_panel_screen/widgets/overview_tab/overview_header.dart';
import 'package:clwb_crm/screens/inventory/inventory_detail_panel_screen/widgets/overview_tab/overview_recent_table.dart';
import 'package:clwb_crm/screens/inventory/inventory_detail_panel_screen/widgets/overview_tab/overview_stock_card.dart';
import 'package:flutter/material.dart';


class InventoryOverviewTab extends StatelessWidget {
  const InventoryOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: OverviewHeader(),
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: OverviewStockCards(),
        ),
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: OverviewWarning(),
        ),
        SizedBox(height: 24),
        OverviewRecentTable(),
        SizedBox(height: 24),

      ],
    );
  }
}
