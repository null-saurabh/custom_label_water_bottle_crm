import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_orders_summary_controller.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_stat_widget/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LastOrderCard extends StatelessWidget {
  final bool isNextOrder;
  final ClientModel client;

  const LastOrderCard({
    super.key,
    required this.client,
    required this.isNextOrder,
  });

  @override
  Widget build(BuildContext context) {
    final summary = Get.find<ClientOrdersSummaryController>(tag: client.id);

    return StatCard(
      gradient: const LinearGradient(
        colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                flex: 14,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      isNextOrder ? 'Next Order' : 'Last Order',
                      style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                    ),

                    Obx(() {
                      final last = summary.lastOrder.value;
                      final next = summary.nextDeliveryOrder.value;

                      if (!isNextOrder) {
                        if (last == null) {
                          return const Text(
                            'No recent order',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          );
                        }
                        final days = DateTime.now().difference(last.createdAt).inDays;
                        return Text(
                          days <= 0 ? 'Today' : '$days days ago',
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                        );
                      } else {
                        final d = next?.expectedDeliveryDate;
                        if (d == null) {
                          return const Text(
                            'No upcoming delivery',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          );
                        }
                        final days = d.difference(DateTime.now()).inDays;
                        return Text(
                          days <= 0 ? 'Due now' : 'After $days days',
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                        );
                      }
                    }),
                  ],
                ),
              ),
              // Spacer(),

              Expanded(
                flex: 20,
                child: Obx(() {
                  final target = isNextOrder
                      ? summary.nextDeliveryOrder.value
                      : summary.lastOrder.value;

                  final amount = target?.totalAmount ?? 0;

                  String marginText = 'Margin: —';

                  // ✅ margin only for last delivered order (not next)
                  if (!isNextOrder) {
                    final m = summary.lastDeliveredMarginPct.value;
                    if (m != null) {
                      marginText = 'Margin: ${m.toStringAsFixed(1)}%';
                    }
                  }

                  return Column(

                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${amount > 0 ?amount.toStringAsFixed(0):"N/A"}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        marginText,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                      // const SizedBox(height: 16),
                    ],
                  );
                }),
              ),
            ],
          ),
          Spacer(),
          nextDeliveryButton(isNextOrder: isNextOrder),

        ],
      ),
    );
  }

  String _daysAgo(DateTime d) => DateTime.now().difference(d).inDays.toString();
}

Widget nextDeliveryButton({required bool isNextOrder, VoidCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(4),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF1C089), // light gold
            Color(0xFFE2A86F), // warm caramel
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE2A86F).withOpacity(0.35),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isNextOrder ? 'View Order' : 'View Delivery',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white,
            size: 18,
          ),
        ],
      ),
    ),
  );
}
