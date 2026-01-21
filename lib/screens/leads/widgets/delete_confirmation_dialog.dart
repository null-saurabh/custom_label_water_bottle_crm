import 'package:clwb_crm/screens/leads/add_lead_model.dart';
import 'package:clwb_crm/screens/leads/leads_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final LeadsController controller;
  final LeadModel lead;

  const DeleteConfirmationDialog({
    super.key,
    required this.controller,
    required this.lead,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final deleting = controller.isDeleting.value;

      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete lead?'),
        content: Text(
          'This will permanently delete "${lead.businessName.isNotEmpty ? lead.businessName : lead.contactName}" '
              'and all its activities.\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: deleting ? null : () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.red.withOpacity(0.6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: deleting ? null : () => controller.deleteLead(lead.id),
            icon: deleting
                ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
                : const Icon(Icons.delete_outline, size: 18),
            label: Text(deleting ? 'Deleting...' : 'Delete'),
          ),
        ],
      );
    });
  }
}
