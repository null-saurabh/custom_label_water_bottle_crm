import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/widgets/client_recent_activity.dart';
import 'package:flutter/material.dart';
















class ClientOverviewTab extends StatelessWidget {
  final ClientModel client;

  const ClientOverviewTab({super.key, required this.client});


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          children: [
            _infoCard('Status', client.isActive ? 'Active' : 'Inactive'),
            const SizedBox(width: 16),
            _infoCard(
              'Orders',
              '${client.deliveredOrdersCount} / ${client.deliveredOrdersCount}',
            ),
            const SizedBox(width: 16),
            _infoCard(
              'Outstanding',
              '₹${client.outstandingAmount.toStringAsFixed(0)}',
            ),
            const SizedBox(width: 16),
            _infoCard(
              'Credit Days',
              '${client.creditDays} days',
            ),

          ],
        ),
        const SizedBox(height: 24),
        RecentActivityList(clientId: client.id,),
      ],
    );
  }

  Widget _infoCard(String title, String value) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Color(0x11000000),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey,fontSize: 12)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

}
