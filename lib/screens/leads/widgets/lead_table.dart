// lib/features/leads/widgets/lead_table.dart

import 'package:clwb_crm/screens/leads/add_lead_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../leads_controller.dart';

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
          columnSpacing: 22, // overall spacing between columns
          horizontalMargin: 18,
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Company')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Follow up')),
            DataColumn(label: Text('Interest')),
            DataColumn(label: Text('Activity')),
            DataColumn(label: Text('')),
          ],
          rows: controller.filteredLeads.map((l) {
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
                        Text(l.contactName),
                        SizedBox(height: 4,),
                        Text(l.phone)
                      ],
                    ),
                  ),
                ),

                // COMPANY
                DataCell(Padding(
                  padding: const EdgeInsets.only(right: 28),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l.businessName),
                      SizedBox(height: 4,),
                      Text(l.deliveryLocation)
                    ],
                  ),
                )),

                // STATUS (editable dropdown)
                DataCell(
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: _StatusDropdown(
                      status: l.status,
                      onChanged: (newStatus) {
                        if (newStatus == null) return;
                        controller.updateLeadStatus(l, newStatus);
                      },
                    ),
                  ),
                ),

                // FOLLOW UP / NOTE (add note)
                DataCell(
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          (l.followUpNotes ?? '').isEmpty
                              ? 'Add note'
                              : l.followUpNotes!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Add/Edit follow up',
                        icon: const Icon(Icons.note_add_outlined, size: 20),
                        onPressed: () => controller.openFollowUpDialog(l),
                      ),
                    ],
                  ),
                ),

                // INTEREST
                DataCell(Text(l.bottleSizes.toString())),

                // ACTIVITY
                DataCell(Text(l.lastActivityAt.toString())),

                // ACTION ICONS (view/edit/delete)
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Call',
                        icon: const Icon(Icons.call_outlined, size: 20),
                        onPressed: () => controller.viewLead(l),
                      ),
                      IconButton(
                        tooltip: 'Edit',
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        onPressed: () => controller.editLead(l),
                      ),
                      IconButton(
                        tooltip: 'Delete',
                        icon: const Icon(Icons.delete_outline, size: 20),
                        onPressed: () => controller.deleteLead(l),
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

class _StatusDropdown extends StatelessWidget {
  final LeadStatus status;
  final ValueChanged<LeadStatus?> onChanged;

  const _StatusDropdown({required this.status, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<LeadStatus>(
          value: status,
          isDense: true,
          alignment: Alignment.centerLeft,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
          borderRadius: BorderRadius.circular(12),
          menuMaxHeight: 220,
          items: LeadStatus.values.map((s) {
            return DropdownMenuItem(
              value: s,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: _StatusChip(status: s),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final LeadStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    String label;

    switch (status) {
      case LeadStatus.newLead:
        bg = const Color(0xFFFFE8CC);
        label = 'New Lead';
        break;
      case LeadStatus.contacted:
        bg = const Color(0xFFE6F4EA);
        label = 'Contacted';
        break;
        case LeadStatus.followUp:
        bg = const Color(0xFFF1F1EB);
        label = 'Follow Up';
        break;
        case LeadStatus.qualified:
        bg = const Color(0xFFF1F1EB);
        label = 'Follow Up';
        break;
      case LeadStatus.converted:
        bg = const Color(0xFFE0ECFF);
        label = 'Converted';
        break;
        case LeadStatus.lost:
        bg = Colors.grey;
        label = 'Converted';
        break;

    }

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label),
    );
  }
}
