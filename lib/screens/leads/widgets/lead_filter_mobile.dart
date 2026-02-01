import 'package:clwb_crm/screens/leads/add_lead_model.dart';
import 'package:clwb_crm/screens/leads/leads_controller.dart';
import 'package:clwb_crm/screens/leads/widgets/leads_filter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeadFiltersMobile extends GetView<LeadsController> {
  const LeadFiltersMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedStage.value;

      final allCount = controller.leads.length;

      final newCount = controller.leads
          .where((e) => e.stage == LeadStage.newInquiry)
          .length;

      final contactedCount = controller.leads
          .where((e) => e.stage == LeadStage.contacted)
          .length;

      final followUpCount = controller.leads.where((l) {
        return l.nextFollowUpAt != null &&
            l.nextFollowUpAt!.isBefore(DateTime.now()) &&
            !l.isConverted;
      }).length;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            FilterPill(
              label: 'All',
              count: allCount,
              icon: null,
              selected: selected == null,
              showChevronWhenSelected: true,
              onTap: () => controller.selectedStage.value = null,
            ),
            const SizedBox(width: 14),

            FilterPill(
              label: 'New Inquiry',
              count: newCount,
              icon: Icons.inbox_outlined,
              selected: selected == LeadStage.newInquiry,
              onTap: () =>
              controller.selectedStage.value = LeadStage.newInquiry,
            ),
            const SizedBox(width: 14),

            FilterPill(
              label: 'Contacted',
              count: contactedCount,
              icon: Icons.phone_in_talk_outlined,
              selected: selected == LeadStage.contacted,
              onTap: () =>
              controller.selectedStage.value = LeadStage.contacted,
            ),
            const SizedBox(width: 14),

            FilterPill(
              label: 'Overdue',
              count: followUpCount,
              icon: Icons.event_busy_outlined,
              selected: controller.showOnlyOverdue.value == true,
              onTap: () {
                controller.showOnlyDueToday.value = false;
                controller.showOnlyOverdue.toggle();
                controller.selectedStage.value = null;
              },
            ),
          ],
        ),
      );
    });
  }
}
