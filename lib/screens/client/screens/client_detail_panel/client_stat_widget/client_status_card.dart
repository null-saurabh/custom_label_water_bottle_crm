import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_stat_widget/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClientStatusCard extends StatelessWidget {
  final ClientModel client;

  const ClientStatusCard({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return StatCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
               Text('Client Status',
                style: TextStyle(fontSize: 16,color: Colors.grey.shade600),
              ),
              const Spacer(),
              ActiveStatusChip(active: client.isActive),
            ],
          ),

          const SizedBox(height: 12),
          Text('CL-${client.id.substring(0, 4).toUpperCase()}',style: TextStyle(color: Colors.grey.shade600),),
          const SizedBox(height: 12),

          Row(
            children: [Text(
              'Joined Date',
              style: TextStyle(fontSize: 16,color: Colors.grey.shade600),
            ),
              const Spacer(),

              Text(
                DateFormat('MM/dd/yyyy').format(client.createdAt),
                style: TextStyle(fontSize: 16,color: Colors.grey.shade600),

              ),],
          )

        ],
      ),
    );
  }
}

class ActiveStatusChip extends StatelessWidget {
  final bool active;

  const ActiveStatusChip({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        active ? 'Active' : 'Inactive',
        style: TextStyle(
          fontSize: 12,
          color: active ? const Color(0xFF065F46) : const Color(0xFF991B1B),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
