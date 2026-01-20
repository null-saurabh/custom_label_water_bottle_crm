// lib/features/leads/widgets/lead_table.dart

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
          dataRowHeight: 64,
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Company')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Interest')),
            DataColumn(label: Text('Activity')),
            DataColumn(label: Text('')),
          ],
          rows: controller.filteredLeads.map((l) {
            return DataRow(
              cells: [
                DataCell(Text(l.name)),
                DataCell(Text(l.company)),
                DataCell(_StatusChip(status: l.status)),
                DataCell(Text(l.interest)),
                DataCell(Text(l.activity)),
                const DataCell(
                  Text('View', style: TextStyle(color: Color(0xFF4C6FFF))),
                ),
              ],
            );
          }).toList(),
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
      case LeadStatus.converted:
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
