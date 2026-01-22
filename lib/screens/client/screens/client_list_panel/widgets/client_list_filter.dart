import 'package:clwb_crm/screens/client/client_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientFilters extends GetView<ClientsController> {
  const ClientFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _filterChip(
            label: 'All',
            filter: ClientFilter.all,
            count: controller.clients.length,
          ),
          _filterChip(
            label: 'Active',
            filter: ClientFilter.active,
            count:
            controller.clients.where((c) => c.isActive).length,
          ),
          _filterChip(
            label: 'Inactive',
            filter: ClientFilter.inactive,
            count:
            controller.clients.where((c) => !c.isActive).length,
          ),
          _filterChip(
            label: 'Priority',
            filter: ClientFilter.priority,
            count:
            controller.clients.where((c) => c.isPriority).length,
          ),
        ],
      );
    });
  }

  Widget _filterChip({
    required String label,
    required ClientFilter filter,
    required int count,
  }) {
    final isSelected = controller.selectedFilter.value == filter;

    return ChoiceChip(
      label: Text('$label'),
      selected: isSelected,
      onSelected: (_) => controller.selectedFilter.value = filter,
      selectedColor: const Color(0xFFEFF6FF),
      backgroundColor: const Color(0xFFF3F4F6),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isSelected ? Colors.blue : Colors.grey,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
