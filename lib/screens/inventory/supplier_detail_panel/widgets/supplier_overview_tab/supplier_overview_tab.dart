import 'package:clwb_crm/screens/inventory/model/supplier_model.dart';
import 'package:clwb_crm/screens/inventory/supplier_detail_panel/widgets/supplier_overview_tab/supplier_items_section.dart';
import 'package:clwb_crm/screens/inventory/supplier_detail_panel/widgets/supplier_overview_tab/supplier_overview_header.dart';
import 'package:clwb_crm/screens/inventory/supplier_detail_panel/widgets/supplier_overview_tab/supplier_overview_stock_card.dart';
import 'package:clwb_crm/screens/inventory/supplier_detail_panel/widgets/supplier_overview_tab/supplier_recent_table.dart';
import 'package:flutter/material.dart';




class SupplierOverviewTab extends StatelessWidget {
  final SupplierModel item;

  const SupplierOverviewTab({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SupplierOverviewHeader(item: item),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SupplierOverviewStockCard(item: item),
        ),
        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SupplierItemsSection(supplier: item),
        ),


        const SizedBox(height: 16),
        SupplierRecentTable(supplierId: item.id),
        const SizedBox(height: 24),
      ],
    );
  }
}

