// dashboard/dashboard_screen.dart
import 'package:clwb_crm/screens/dashboard/widgets/dashboard_header.dart';
import 'package:clwb_crm/screens/dashboard/widgets/dashboard_kpi_row.dart';
import 'package:clwb_crm/screens/dashboard/widgets/due_next_week_card/due_next_week_card.dart';
import 'package:clwb_crm/screens/dashboard/widgets/inventory_warning_card/inventory_warning_card.dart';
import 'package:clwb_crm/screens/dashboard/widgets/notes/admin_notes_card.dart';
import 'package:clwb_crm/screens/dashboard/widgets/order_this_week_card/order_this_week_card.dart';
import 'package:clwb_crm/screens/dashboard/widgets/recurring_order_card/recurring_order_card.dart';
import 'package:clwb_crm/screens/dashboard/widgets/today_due_card/today_due_card.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            DashboardHeader(),
            SizedBox(height: 20),
            DashboardKpiRow(),
            SizedBox(height: 20),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      DueDeliveriesTodayCard(),
                      SizedBox(height: 20),

                       DueNextWeekCard(),
                      SizedBox(height: 20),
                      RecurringOrdersCard(),
                    ],
                  ),
                ),
                SizedBox(width: 20,),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          OrdersThisWeekCard(),
                          SizedBox(width: 20,),

                          Expanded(
                            child:AdminNotesCard(),
                            // notes,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      InventoryWarningCard(),


                  ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
