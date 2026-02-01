import 'package:clwb_crm/core/utils/responsive.dart';
import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_orders_summary_controller.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_stat_widget/client_stat_widget.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_stat_widget/client_stat_widget_mobile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientOverviewTab extends StatelessWidget {
  final ClientModel client;

  const ClientOverviewTab({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    final summary = Get.put(
      ClientOrdersSummaryController(client.id),
      tag: client.id,
    );
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,

            child: Row(
              children: [
                _infoCard('Status', client.isActive ? 'Active' : 'Inactive'),
                const SizedBox(width: 16),

                Obx(
                  () => _infoCard(
                    'Orders',
                    '${summary.deliveredOrders.value} / ${summary.totalOrders.value}',
                  ),
                ),
                const SizedBox(width: 16),

                Obx(
                  () => _infoCard(
                    'Outstanding',
                    '₹${summary.outstanding.value.toStringAsFixed(0)}',
                  ),
                ),
                const SizedBox(width: 16),

                Obx(
                  () => _infoCard(
                    'Credit Days',
                    '${summary.maxOverdueDays.value} days',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          !context.isMobile
              ? ClientStatSection(client: client)
              : ClientStatSectionMobile(client: client),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _infoCard(String title, String value) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Color(0x11000000))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
