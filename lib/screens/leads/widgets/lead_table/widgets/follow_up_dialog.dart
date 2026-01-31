import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ShowFollowUpDialog extends StatefulWidget {
  final String leadName;
  final DateTime? initialNextAt;
  final String initialNote;
  final Future<void> Function(DateTime? nextAt, String note) onSave;
  final RxBool isSaving;

  const ShowFollowUpDialog({
    super.key,
    required this.leadName,
    required this.initialNextAt,
    required this.initialNote,
    required this.onSave,
    required this.isSaving,
  });

  @override
  State<ShowFollowUpDialog> createState() => _ShowFollowUpDialogState();
}

class _ShowFollowUpDialogState extends State<ShowFollowUpDialog> {
  late final TextEditingController noteCtrl;
  DateTime? nextAt;

  @override
  void initState() {
    super.initState();
    noteCtrl = TextEditingController(text: widget.initialNote);
    nextAt = widget.initialNextAt;
  }

  @override
  void dispose() {
    noteCtrl.dispose();
    super.dispose();
  }

  String _fmt(DateTime? dt) {
    if (dt == null) return 'Not set';
    return DateFormat('dd MMM, hh:mm a').format(dt);
  }

  Future<void> pickDateTime() async {
    final now = DateTime.now();
    final base = nextAt ?? now.add(const Duration(hours: 2));

    final d = await showDatePicker(
      context: context,
      initialDate: DateTime(base.year, base.month, base.day),
      firstDate: DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (d == null) return;

    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(base),
    );
    if (t == null) return;

    setState(() {
      nextAt = DateTime(d.year, d.month, d.day, t.hour, t.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final saving = widget.isSaving.value;

      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Next follow-up'),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.leadName,
                style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 12),

              // next follow-up datetime
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Text(_fmt(nextAt)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: saving ? null : pickDateTime,
                    icon: const Icon(Icons.calendar_month_outlined, size: 18),
                    label: const Text('Pick'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: saving
                        ? null
                        : () => setState(() {
                      nextAt = null;
                    }),
                    child: const Text('Clear'),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              TextField(
                controller: noteCtrl,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'What is the next action? (call, visit, sample reminder...)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: saving ? null : () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C6FFF),
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFF4C6FFF).withOpacity(0.6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: saving
                ? null
                : () async {
              await widget.onSave(nextAt, noteCtrl.text.trim());
            },
            icon: saving
                ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
                : const Icon(Icons.save_outlined, size: 18),
            label: Text(saving ? 'Saving...' : 'Save'),
          ),
        ],
      );
    });
  }
}
