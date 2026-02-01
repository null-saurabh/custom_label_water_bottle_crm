import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_stat_widget/client_status_card.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_stat_widget/last_order_card.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_stat_widget/order_summary_card.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/notes_widget/notes_card.dart';
import 'package:flutter/material.dart';

class ClientStatSectionMobile extends StatelessWidget {
  final ClientModel client;

  const ClientStatSectionMobile({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Client Details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 20),

          ClientStatusCard(client: client),
          const SizedBox(height: 20),
          LastOrderCard(client: client, isNextOrder: false),

          const SizedBox(height: 12),
          OrdersSummaryCard(client: client),
          const SizedBox(height: 12),
          LastOrderCard(client: client, isNextOrder: true),

              const SizedBox(height: 12),
        NotesCard(client: client),

        ],
      ),
    );
  }
}
