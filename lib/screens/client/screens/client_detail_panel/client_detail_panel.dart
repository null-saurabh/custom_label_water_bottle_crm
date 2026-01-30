import 'package:clwb_crm/screens/client/client_controller.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_order_tab/client_orders_tab.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_payment_tab/client_payments_tab.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/widgets/client_recent_activity_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/client_header.dart';
import 'widgets/client_overview_tab.dart';
import 'widgets/client_tabs.dart';

class ClientDetailScreen extends GetView<ClientsController> {
  const ClientDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final client = controller.selectedClient;

      if (client == null) {
        return const Center(
          child: Text(
            'Select a client to view details',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return DefaultTabController(
        length: 4,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClientHeader(client: client),
              const SizedBox(height: 20),

              /// Tabs (ONLY UI)
              const ClientTabs(),
              const SizedBox(height: 20),

              /// Tab content (REAL LOGIC)
              Expanded(
                child: TabBarView(
                  children: [
                    ClientOverviewTab(client: client),
                    RecentActivityTab(clientId: client.id),
                    ClientOrdersTab(clientId: client.id,client: client,),
                    ClientPaymentsTab(clientId: client.id),

                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
