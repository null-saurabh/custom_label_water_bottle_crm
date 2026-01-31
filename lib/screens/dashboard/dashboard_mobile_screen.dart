import 'package:clwb_crm/screens/dashboard/widgets/dashboard_header.dart';
import 'package:clwb_crm/screens/dashboard/widgets/dashboard_kpi_row.dart';
import 'package:clwb_crm/screens/dashboard/widgets/due_cards_slider.dart';
import 'package:clwb_crm/screens/dashboard/widgets/inventory_warning_card/inventory_warning_card.dart';
import 'package:clwb_crm/screens/dashboard/widgets/notes/admin_notes_card.dart';
import 'package:flutter/material.dart';

class DashboardMobileView extends StatelessWidget {
  const DashboardMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        DashboardHeader(),
        SizedBox(height: 16),

        // KPIs stacked
        DashboardKpiRow(),
        SizedBox(height: 16),


        DueCardsSlider(),
        SizedBox(height: 16),

        // Notes should be collapsible on mobile
        AdminNotesCard(),
        SizedBox(height: 16),
        InventoryWarningCardShell(),

      ],
    );
  }
}
