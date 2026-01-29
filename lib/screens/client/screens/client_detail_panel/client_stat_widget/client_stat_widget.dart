import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_stat_widget/client_status_card.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_stat_widget/last_order_card.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_stat_widget/order_summary_card.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/notes_widget/notes_card.dart';
import 'package:flutter/material.dart';

class ClientStatSection extends StatelessWidget {
  final ClientModel client;

  const ClientStatSection({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 360,
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
          Row(
            children: [
              Text(
                "Client Details",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    ClientStatusCard(client: client),
                    const SizedBox(height: 20),
                    LastOrderCard(client: client, isNextOrder: false),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                flex: 4,

                child: Column(
                  children: [
                    OrdersSummaryCard(client: client),
                    const SizedBox(height: 20),
                    LastOrderCard(client: client, isNextOrder: true),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                  flex: 5,
                  child: NotesCard(client: client)),

            ],
          ),
        ],
      ),
    );
  }
}
