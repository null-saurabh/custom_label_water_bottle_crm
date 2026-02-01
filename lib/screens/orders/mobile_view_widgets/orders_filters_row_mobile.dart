import 'package:clwb_crm/screens/client/client_controller.dart';
import 'package:clwb_crm/screens/orders/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersFiltersRowMobile extends GetView<OrdersController> {
  const OrdersFiltersRowMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final clientsCtrl = Get.find<ClientsController>();

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // CLIENT FILTER
          Obx(() {
            final clientNames = [
              'All Clients',
              ...clientsCtrl.clients.map((c) => c.businessName),
            ];

            return _MobileFilterDropdown(
              label: 'Client',
              value: controller.clientFilter.value == 'all'
                  ? 'All Clients'
                  : controller.clientFilter.value,
              items: clientNames,
              onChanged: (v) {
                if (v == null) return;
                controller.setClientFilter(
                  v == 'All Clients' ? 'all' : v,
                );
              },
            );
          }),

          // DELIVERY DATE FILTER
          Obx(() {
            final value = () {
              switch (controller.dateFilter.value) {
                case 'today': return 'Today';
                case 'tomorrow': return 'Tomorrow';
                case 'next_7': return 'Next 7 Days';
                case 'custom': return 'Custom Range';
                default: return 'All';
              }
            }();

            return _MobileFilterDropdown(
              label: 'Delivery',
              value: value,
              items: const [
                'All',
                'Today',
                'Tomorrow',
                'Next 7 Days',
                'Custom Range',
              ],
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

          // SORT FILTER
          Obx(() {
            final value = controller.sortMode.value ==
                OrderSortMode.delivery
                ? 'Delivery Date'
                : 'Created Date';

            return _MobileFilterDropdown(
              label: 'Sort',
              value: value,
              items: const [
                'Delivery Date',
                'Created Date',
              ],
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
        ],
      ),
    );
  }
}


class _MobileFilterDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _MobileFilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: items.contains(value) ? value : items.first,
            items: items
                .map(
                  (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            )
                .toList(),
            onChanged: onChanged,
            icon: const Icon(Icons.keyboard_arrow_down),
          ),
        ),
      ),
    );
  }
}
