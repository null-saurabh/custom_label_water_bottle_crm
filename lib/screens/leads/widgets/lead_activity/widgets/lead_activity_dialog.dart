// lead_activity_dialog.dart

import 'package:clwb_crm/screens/leads/add_lead_model.dart';
import 'package:clwb_crm/screens/leads/widgets/lead_activity/lead_activity_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeadActivityDialog extends StatelessWidget {
  final LeadModel lead;

  const LeadActivityDialog({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      lead.businessName.isNotEmpty
                          ? lead.businessName
                          : lead.contactName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),

              // Activity Timeline
              Expanded(
                child: LeadActivityTimeline(
                  leadId: lead.id,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
