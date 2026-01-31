// lib/features/leads/widgets/lead_filters.dart
import 'package:clwb_crm/screens/leads/add_lead_model.dart';
import 'package:clwb_crm/screens/leads/leads_controller.dart';
import 'package:clwb_crm/screens/leads/widgets/add_lead_dialog/add_lead_controller.dart';
import 'package:clwb_crm/screens/leads/widgets/add_lead_dialog/add_lead_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class LeadFilters extends GetView<LeadsController> {
  const LeadFilters({super.key});

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

      return Row(
        children: [
          _FilterPill(
            label: 'All',
            count: allCount,
            icon: null,
            selected: selected == null,
            showChevronWhenSelected: true,
            onTap: () => controller.selectedStage.value = null,
          ),
          const SizedBox(width: 14),

          _FilterPill(
            label: 'New Inquiry',
            count: newCount,
            icon: Icons.inbox_outlined,
            selected: selected == LeadStage.newInquiry,
            onTap: () => controller.selectedStage.value = LeadStage.newInquiry,
          ),
          const SizedBox(width: 14),

          _FilterPill(
            label: 'Contacted',
            count: contactedCount,
            icon: Icons.phone_in_talk_outlined,
            selected: selected == LeadStage.contacted,
            onTap: () => controller.selectedStage.value = LeadStage.contacted,
          ),
          const SizedBox(width: 14),

          _FilterPill(
            label: 'Overdue',
            count: followUpCount,
            icon: Icons.event_busy_outlined,
            selected: controller.showOnlyOverdue.value == true,
            onTap: () {
              // Overdue is a "view", not a stage
              controller.showOnlyDueToday.value = false;
              controller.showOnlyOverdue.toggle();
              controller.selectedStage.value = null;
            },
          ),

          const Spacer(),

          HeaderActionButton(
            text: 'Add Lead',
            onTap: () {
              // safer than lazyPut in dialog flow
              if (Get.isRegistered<AddLeadController>()) {
                Get.delete<AddLeadController>();
              }
              Get.put(AddLeadController(), permanent: false);

              Get.dialog(
                const AddLeadDialog(),
                barrierDismissible: false,
              );
            },
          ),
        ],
      );
    });
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final int count;
  final IconData? icon;
  final bool selected;
  final bool showChevronWhenSelected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
    this.icon,
    this.showChevronWhenSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final border = Colors.black.withOpacity(0.06);

    final bgGradient = selected
        ? const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFF4E8), Color(0xFFFFEBD6)],
    )
        : const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF4F7FF), Color(0xFFEEF2FF)],
    );

    final textColor = selected ? const Color(0xFF1F2A44) : Colors.grey;
    final muted = selected ? const Color(0xFF5B677A) : const Color(0xFF6B7A90);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 180,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            gradient: bgGradient,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 22, color: muted),
                const SizedBox(width: 10),
              ],
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 20),
              Text(
                count.toString(),
                style: TextStyle(
                  color: muted,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (selected && showChevronWhenSelected) ...[
                const Spacer(),
                Icon(Icons.chevron_right, size: 20, color: muted),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const HeaderActionButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          decoration: BoxDecoration(
            color: const Color(0xFF3558C9),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3558C9).withOpacity(0.25),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.add, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Add Lead',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
