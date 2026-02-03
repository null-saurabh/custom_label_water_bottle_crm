import 'package:clwb_crm/core/widgets/premium_button.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/widgets/client_maps/client_map_edit_controller.dart';
import 'package:clwb_crm/screens/inventory/dialogs/base_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditMapsLinkDialog extends StatelessWidget {
  final EditMapsLinkController c;
  const EditMapsLinkDialog({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return OldBaseDialog(
      title: 'Google Maps Link',
      footer: Obx(
            () => PremiumButton(
          text: c.isSaving.value ? 'Saving...' : 'Save',
          onTap: c.isSaving.value ? () {} : c.submit,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Field(
            label: 'Paste Google Maps link',
            controller: c.linkCtrl, // ✅ matches your Field widget
            enabled: !c.isSaving.value,
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: c.isSaving.value ? null : c.useCurrentLocation,
            icon: const Icon(Icons.my_location),
            label: const Text('Use current location'),
          ),
          const SizedBox(height: 6),
          const Text(
            'You can keep it empty if you don’t want to store the link.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
