import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_stat_widget/stat_card.dart';
import 'package:flutter/material.dart';

class NotesCard extends StatelessWidget {
  final ClientModel client;

  const NotesCard({
    super.key,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    return StatCard(
      height: 299,
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          const Text(
            'Notes',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            client.notes,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),

    );
  }

}
