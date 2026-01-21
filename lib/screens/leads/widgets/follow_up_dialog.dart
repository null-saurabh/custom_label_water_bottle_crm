import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowFollowUpDialog extends StatelessWidget {
  final String leadId;
  final String leadName;
  final String initialNote;
  final Future<void> Function(String note) onSave;
  final RxBool isSaving;

  const ShowFollowUpDialog({
    super.key,
    required this.leadId,
    required this.leadName,
    required this.initialNote,
    required this.onSave,
    required this.isSaving,
  });

  @override
  Widget build(BuildContext context) {
    final textCtrl = TextEditingController(text: initialNote);

    return Obx(() {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Follow up note'),
        content: SizedBox(
          width: 460,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                leadName,
                style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textCtrl,
                maxLines: 4,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: 'Write a follow up note...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: isSaving.value ? null : () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C6FFF),
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFF4C6FFF).withOpacity(0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isSaving.value
                ? null
                : () async {
                    final note = textCtrl.text.trim();
                    await onSave(note);

                    if (Get.isDialogOpen == true) Get.back();
                  },
            icon: isSaving.value
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save_outlined, size: 18),
            label: Text(isSaving.value ? 'Saving...' : 'Save'),
          ),
        ],
      );
    });
  }
}
