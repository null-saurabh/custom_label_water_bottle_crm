// lib/features/leads/widgets/lead_filters.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../leads_controller.dart';

class LeadFilters extends GetView<LeadsController> {
  const LeadFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedFilter.value;

      final allCount = controller.leads.length;
      final newCount = controller.leads
          .where((e) => e.status == LeadStatus.newLead)
          .length;
      final contactedCount = controller.leads
          .where((e) => e.status == LeadStatus.contacted)
          .length;

      return Row(
        children: [
          _FilterPill(
            label: 'All',
            count: allCount,
            icon: null,
            selected: selected == null, // recommended: null means "All"
            showChevronWhenSelected: true,
            onTap: () => controller.selectedFilter.value = null,
          ),
          const SizedBox(width: 14),

          _FilterPill(
            label: 'New Leads',
            count: newCount,
            icon: Icons.group_outlined,
            selected: selected == LeadStatus.newLead,
            onTap: () => controller.selectedFilter.value = LeadStatus.newLead,
          ),
          const SizedBox(width: 14),

          _FilterPill(
            label: 'Contacted',
            count: contactedCount,
            icon: Icons.person_outline,
            selected: selected == LeadStatus.contacted,
            onTap: () => controller.selectedFilter.value = LeadStatus.contacted,
          ),

          const Spacer(),

          _AddLeadButton(
            onPressed: () {
              // TODO: open add lead modal/page
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

    final textColor = selected ? const Color(0xFF1F2A44) : const Color(0xFF2E3A59);
    final muted = selected ? const Color(0xFF5B677A) : const Color(0xFF6B7A90);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
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
                Icon(icon, size: 18, color: muted),
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
              const SizedBox(width: 10),
              Text(
                count.toString(),
                style: TextStyle(
                  color: muted,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (selected && showChevronWhenSelected) ...[
                const SizedBox(width: 10),
                Icon(Icons.chevron_right, size: 20, color: muted),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AddLeadButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddLeadButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6F86FF), Color(0xFF4C6FFF)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        ),
        icon: const Icon(Icons.add, color: Colors.white, size: 20),
        label: const Text(
          'Add Lead',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
