// lib/features/leads/widgets/lead_table.dart

import 'package:clwb_crm/screens/leads/add_lead_model.dart';
import 'package:clwb_crm/screens/leads/widgets/lead_table/widgets/delete_confirmation_dialog.dart';
import 'package:clwb_crm/screens/leads/widgets/lead_table/widgets/follow_up_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clwb_crm/screens/leads/leads_controller.dart';

class LeadTable extends GetView<LeadsController> {
  const LeadTable({super.key});


  @override
  Widget build(BuildContext context) {


    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: DataTable(
          headingRowHeight: 56,
          dataRowHeight: 98,
          columnSpacing: 22,
          horizontalMargin: 18,
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Company')),
            DataColumn(label: Text('Stage')),
            DataColumn(label: Text('Next Action')),
            DataColumn(label: Text('Interest')),
            DataColumn(label: Text('Activity')),
            DataColumn(label: Text('')),
          ],
          rows: controller.filteredLeads.map((l) {

            final interestText = l.interests.isNotEmpty
                ? l.interests.map((e) => e.bottleSize).toSet().join(', ')
                : '—';

            return DataRow(
              cells: [
                // NAME (a bit wider + padding to increase gap before company)
                DataCell(
                  Padding(
                    padding: const EdgeInsets.only(right: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l.primaryContactName,
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Text(l.primaryPhone, style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                ),

                // COMPANY
                DataCell(
                  Padding(
                    padding: const EdgeInsets.only(right: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l.businessName == "" ? "N/A" : l.businessName,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: l.businessName == "" ? 0 : 4),
                        l.businessName == ""
                            ? SizedBox()
                            : Text(
                                [
                                  l.area,
                                  l.city,
                                ].where((e) => e.trim().isNotEmpty).join(', '),
                                style: TextStyle(fontSize: 10),
                              ),
                      ],
                    ),
                  ),
                ),

                // STATUS (editable dropdown)
                DataCell(
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: _StageDropdown(
                      stage: l.stage,
                      isLocked: l.isConverted,
                      onChanged: (newStage) {
                        if (newStage == null) return;
                        controller.changeStage(l, newStage);
                      },
                    ),
                  ),
                ),

                // FOLLOW UP / NOTE (add note)
                DataCell(
                  Row(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 220),
                        child: Tooltip(
                          message: (l.nextFollowUpNote.trim().isEmpty)
                              ? 'No next action'
                              : l.nextFollowUpNote.trim(),
                          waitDuration: const Duration(milliseconds: 400),
                          child: Text(
                            l.nextFollowUpAt == null
                                ? (l.nextFollowUpNote.trim().isEmpty
                                      ? 'No follow-up set'
                                      : l.nextFollowUpNote.trim())
                                : '${_followUpLabel(l.nextFollowUpAt!)} · ${l.nextFollowUpNote.trim().isEmpty ? 'Next follow-up' : l.nextFollowUpNote.trim()}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Schedule follow-up',
                        icon: const Icon(
                          Icons.event_available_outlined,
                          size: 20,
                        ),
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
                                  barrierDismissible: false,
                                );
                              },
                      ),
                    ],
                  ),
                ),

                // INTEREST
                DataCell(

                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 160, // tweak: 140–200 depending on your table
                    ),
                    child: Tooltip(
                      message: interestText,
                      child: Text(
                        interestText,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),

                // ACTIVITY
                DataCell(
                  Text(
                    l.lastActivityAt != null
                        ? controller.lastActivityLabel(l)
                        // ? dateTimeToString(l.lastActivityAt!)
                        : '—',
                  ),
                ),

                // ACTION ICONS (view/edit/delete)
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Call',
                        icon: const Icon(Icons.call_outlined, size: 20),
                        onPressed: () => controller.onCallPressed(l),
                      ),
                      IconButton(
                        tooltip: 'Edit',
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        onPressed: () => controller.editLead(l),
                      ),
                      IconButton(
                        tooltip: 'Delete',
                        icon: const Icon(Icons.delete_outline, size: 20),
                        onPressed: () {
                          Get.dialog(
                            DeleteConfirmationDialog(
                              controller: controller,
                              lead: l,
                            ),
                            barrierDismissible: false,
                          );
                        },
                      ),

                      IconButton(
                        tooltip: 'View',
                        icon: const Icon(Icons.visibility_outlined, size: 20),
                        onPressed: () => controller.viewLead(l),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
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
      height: 36,
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
