import 'package:clwb_crm/screens/client/client_controller.dart';
import 'package:clwb_crm/screens/orders/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/premium_button.dart';


class OrdersFiltersRow extends GetView<OrdersController> {
  const OrdersFiltersRow({super.key});

  @override
  Widget build(BuildContext context) {
    final clientsCtrl = Get.find<ClientsController>();

    return Row(
      children: [
        // =====================
        // CLIENT FILTER
        // =====================
        Obx(() {
          final clientNames = [
            'All Clients',
            ...clientsCtrl.clients.map((c) => c.businessName),
          ];

          return _FilterDropdown(
            label: 'All Clients',
            items: clientNames,
            value: controller.clientFilter.value,
            onChanged: (v) {
              if (v == null) return;
              controller.setClientFilter(
                v == 'All Clients' ? 'all' : v,
              );
            },
          );
        }),

        const SizedBox(width: 12),

        // =====================
        // DELIVERY DATE FILTER
        // =====================
        Obx(() {
          return _FilterDropdown(
            label: 'All Delivery Dates',
            items: const [
              'All',
              'Today',
              'Tomorrow',
              'Next 7 Days',
              'Custom Range',
            ],
            value: () {
              switch (controller.dateFilter.value) {
                case 'today': return 'Today';
                case 'tomorrow': return 'Tomorrow';
                case 'next_7': return 'Next 7 Days';
                case 'custom': return 'Custom Range';
                default: return 'All';
              }
            }(),
            onChanged: (v) {
              if (v == null) return;

              switch (v) {
                case 'Today':
                  controller.setDateFilter('today');
                  break;
                case 'Tomorrow':
                  controller.setDateFilter('tomorrow');
                  break;
                case 'Next 7 Days':
                  controller.setDateFilter('next_7');
                  break;
                case 'Custom Range':
                  controller.openCustomDatePicker();
                  break;
                default:
                  controller.setDateFilter('all');
              }
            },
          );
        }),

        const SizedBox(width: 12),
        // =====================
// SORT DROPDOWN 🔥
// =====================
        Obx(() {
          return _FilterDropdown(
            label: 'Sort By',
            items: const [
              'Delivery Date',
              'Created Date',
            ],
            value: () {
              switch (controller.sortMode.value) {
                case OrderSortMode.delivery:
                  return 'Delivery Date';
                case OrderSortMode.created:
                  return 'Created Date';
              }
            }(),
            onChanged: (v) {
              if (v == null) return;

              switch (v) {
                case 'Delivery Date':
                  controller.setSortMode(OrderSortMode.delivery);
                  break;
                case 'Created Date':
                  controller.setSortMode(OrderSortMode.created);
                  break;
              }
            },
          );
        }),


        const Spacer(),

        // =====================
        // ADD ORDER BUTTON
        // =====================
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: PremiumButton(
            text: "+ Add Order",
            // onTap: (){
            //   OrdersSeedService.uploadDummyOrders();
            // },
            onTap: controller.openAddOrderDialog,
          ),
        ),
      ],
    );
  }
}

// ===============================
// SHARED DROPDOWN WIDGET
// ===============================


class _FilterDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final String value;
  final ValueChanged<String?> onChanged;

  const _FilterDropdown({
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected =
    items.contains(value) ? value : items.first;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selected,
          items: items
              .map(
                (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
