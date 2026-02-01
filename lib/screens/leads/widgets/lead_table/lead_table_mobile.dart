import 'package:clwb_crm/screens/leads/add_lead_model.dart';
import 'package:clwb_crm/screens/leads/widgets/lead_table/widgets/delete_confirmation_dialog.dart';
import 'package:clwb_crm/screens/leads/widgets/lead_table/widgets/follow_up_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clwb_crm/screens/leads/leads_controller.dart';


class LeadListMobile extends GetView<LeadsController> {
  const LeadListMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: controller.filteredLeads
            .map((l) => LeadCardMobile(
          l: l,
          controller: controller,
        ))
            .toList(),
      );
    });
  }
}




class LeadCardMobile extends StatelessWidget {
  final LeadModel l;
  final LeadsController controller;

  const LeadCardMobile({
    super.key,
    required this.l,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final interestText = l.interests.isNotEmpty
        ? l.interests.map((e) => e.bottleSize).toSet().join(', ')
        : '—';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NAME
          Text(
            l.primaryContactName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(l.primaryPhone, style: const TextStyle(fontSize: 12)),

          // COMPANY
          if (l.businessName.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              l.businessName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              [l.area, l.city]
                  .where((e) => e.trim().isNotEmpty)
                  .join(', '),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],

          const SizedBox(height: 12),

          // STAGE (UNCHANGED)
          _StageDropdown(
            stage: l.stage,
            isLocked: l.isConverted,
            onChanged: (newStage) {
              if (newStage == null) return;
              controller.changeStage(l, newStage);
            },
          ),

          const SizedBox(height: 12),

          // NEXT ACTION
          Row(
            children: [
              Expanded(
                child: Text(
                  l.nextFollowUpAt == null
                      ? (l.nextFollowUpNote.trim().isEmpty
                      ? 'No follow-up set'
                      : l.nextFollowUpNote.trim())
                      : '${_followUpLabel(l.nextFollowUpAt!)} · ${l.nextFollowUpNote.trim().isEmpty ? 'Next follow-up' : l.nextFollowUpNote.trim()}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.event_available_outlined, size: 20),
                onPressed: l.isConverted
                    ? null
                    : () {
                  Get.dialog(
                    ShowFollowUpDialog(
                      leadName: l.businessName.isNotEmpty
                          ? l.businessName
                          : l.primaryContactName,
                      initialNextAt: l.nextFollowUpAt,
                      initialNote: l.nextFollowUpNote,
                      onSave: (nextAt, note) =>
                          controller.saveFollowUp(
                            lead: l,
                            nextAt: nextAt,
                            note: note,
                          ),
                      isSaving: controller.isSavingFollowUp,
                    ),
                    barrierDismissible: true,
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 8),

          // INTEREST
          Text(
            'Interest: $interestText',
            style: const TextStyle(fontSize: 12),
          ),

          const SizedBox(height: 4),

          // ACTIVITY
          Text(
            'Last Activity: ${l.lastActivityAt != null ? controller.lastActivityLabel(l) : '—'}',
            style: const TextStyle(fontSize: 12),
          ),

          const SizedBox(height: 10),

          // ACTIONS
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.call_outlined),
                onPressed: () => controller.onCallPressed(l),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => controller.editLead(l),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  Get.dialog(
                    DeleteConfirmationDialog(
                      controller: controller,
                      lead: l,
                    ),
                    barrierDismissible: true,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.visibility_outlined),
                onPressed: () => controller.viewLead(l),
              ),
            ],
          ),
        ],
      ),
    );
  }
}




class _StageDropdown extends StatelessWidget {
  final LeadStage stage;
  final bool isLocked;
  final ValueChanged<LeadStage?> onChanged;

  const _StageDropdown({
    required this.stage,
    required this.isLocked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44  ,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<LeadStage>(
          value: stage,
          isDense: true,
          alignment: Alignment.centerLeft,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
          borderRadius: BorderRadius.circular(12),
          menuMaxHeight: 260,
          items: LeadStage.values.map((s) {
            return DropdownMenuItem(
              value: s,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: _StageChip(stage: s),
              ),
            );
          }).toList(),
          onChanged: isLocked ? null : onChanged,
        ),
      ),
    );
  }
}
class _StageChip extends StatelessWidget {
  final LeadStage stage;
  const _StageChip({required this.stage});

  @override
  Widget build(BuildContext context) {
    Color bg;
    String label;

    switch (stage) {
      case LeadStage.newInquiry:
        bg = const Color(0xFFFFE8CC);
        label = 'New Inquiry';
        break;
      case LeadStage.attemptingContact:
        bg = const Color(0xFFFFF3C4);
        label = 'Attempting Contact';
        break;
      case LeadStage.contacted:
        bg = const Color(0xFFE6F4EA);
        label = 'Contacted';
        break;
      case LeadStage.qualified:
        bg = const Color(0xFFDFF6FF);
        label = 'Qualified';
        break;

      case LeadStage.sampleRequested:
        bg = const Color(0xFFEDE9FE);
        label = 'Sample Requested';
        break;
      case LeadStage.sampleSent:
        bg = const Color(0xFFEDE9FE);
        label = 'Sample Sent';
        break;
      case LeadStage.sampleFeedbackAwaited:
        bg = const Color(0xFFFCE7F3);
        label = 'Feedback Awaited';
        break;
      case LeadStage.requirementsClarifying:
        bg = const Color(0xFFF1F5F9);
        label = 'Requirements';
        break;

      case LeadStage.priceShared:
        bg = const Color(0xFFE0F2FE);
        label = 'Price Shared';
        break;
      case LeadStage.negotiation:
        bg = const Color(0xFFFFEDD5);
        label = 'Negotiation';
        break;
      case LeadStage.decisionPending:
        bg = const Color(0xFFF1F5F9);
        label = 'Decision Pending';
        break;

      case LeadStage.meetingScheduled:
        bg = const Color(0xFFE0ECFF);
        label = 'Meeting Scheduled';
        break;
      case LeadStage.visitScheduled:
        bg = const Color(0xFFE0ECFF);
        label = 'Visit Scheduled';
        break;
      case LeadStage.followUpRequired:
        bg = const Color(0xFFF1F1EB);
        label = 'Follow-up Required';
        break;

      case LeadStage.callMeLater:
        bg = const Color(0xFFF1F5F9);
        label = 'Call Me Later';
        break;
      case LeadStage.interestedNotReady:
        bg = const Color(0xFFF1F5F9);
        label = 'Interested, Not Ready';
        break;

      case LeadStage.lostPrice:
        bg = const Color(0xFFE5E7EB);
        label = 'Lost: Price';
        break;
      case LeadStage.lostNoRequirement:
        bg = const Color(0xFFE5E7EB);
        label = 'Lost: No Requirement';
        break;
      case LeadStage.lostNoResponse:
        bg = const Color(0xFFE5E7EB);
        label = 'Lost: No Response';
        break;
      case LeadStage.lostCompetitor:
        bg = const Color(0xFFE5E7EB);
        label = 'Lost: Competitor';
        break;

      case LeadStage.convertedToClient:
        bg = const Color(0xFFE0ECFF);
        label = 'Converted';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label),
    );
  }
}
String _followUpLabel(DateTime dt) {
  final now = DateTime.now();
  final diff = dt.difference(now);

  if (dt.isBefore(now)) return 'Overdue';
  if (diff.inHours < 24) return 'Today';
  if (diff.inDays == 1) return 'Tomorrow';
  return '${diff.inDays}d';
}