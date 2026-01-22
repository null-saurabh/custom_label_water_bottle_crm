import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:flutter/material.dart';

class ClientHeader extends StatelessWidget {
  final ClientModel client;

  const ClientHeader({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 26,
          child: Text(
            client.businessName.isNotEmpty
                ? client.businessName[0].toUpperCase()
                : '?',
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              client.businessName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${client.contactName} · ${client.contactRole}',
              style: const TextStyle(color: Colors.grey),
            ),Text(
              '+91 ${client.phone}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
