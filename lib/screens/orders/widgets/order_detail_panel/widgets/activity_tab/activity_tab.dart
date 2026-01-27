import 'package:clwb_crm/screens/orders/models/order_activity_model.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/order_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ActivityTab extends StatelessWidget {
  final String orderId;

  const ActivityTab({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderDetailController>();

    return Obx(() {
      final list = controller.activities;

      if (list.isEmpty) {
        return const Center(
          child: Text(
            'No activity yet',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }

      return ListView.separated(
        itemCount: list.length,
        separatorBuilder: (_, __) =>
        const Divider(height: 12),
        itemBuilder: (_, i) {
          final a = list[i];

          return _ActivityTile(activity: a);
        },
      );
    });
  }
}




class _ActivityTile extends StatelessWidget {
  final OrderActivityModel activity;

  const _ActivityTile({
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (activity.type) {
      case 'production':
        icon = Icons.factory;
        color = Colors.blue;
        break;
      case 'expense':
        icon = Icons.money_off;
        color = Colors.redAccent;
        break;
      case 'payment':
        icon = Icons.payments;
        color = Colors.green;
        break;
      case 'delivery':
        icon = Icons.local_shipping;
        color = Colors.orange;
        break;
      case 'dispatch':
        icon = Icons.outbox;
        color = Colors.purple;
        break;
      default:
        icon = Icons.info_outline;
        color = Colors.grey;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                activity.description,
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 4),

              Text(
                DateFormat('dd MMM yyyy, hh:mm a')
                    .format(activity.activityDate),
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
