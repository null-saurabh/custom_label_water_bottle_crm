import 'package:clwb_crm/screens/client/client_controller.dart';
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

      // ✅ No client selected state
      if (client == null) {
        return const Center(
          child: Text(
            'Select a client to view details',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        );
      }

      // Get.put(
      //   ClientActivityController(client.id),
      //   tag: client.id,
      // );

      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClientHeader(client: client),
            const SizedBox(height: 20),
            const ClientTabs(),
            const SizedBox(height: 20),
            Expanded(
              child: ClientOverviewTab(client: client),
            ),
          ],
        ),
      );
    });
  }
}
