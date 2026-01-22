import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_stat_widget/stat_card.dart';
import 'package:flutter/material.dart';

class LastOrderCard extends StatelessWidget {
  final bool isNextOrder;
  final ClientModel client;

  const LastOrderCard({super.key, required this.client, required this.isNextOrder});

  @override
  Widget build(BuildContext context) {
    return StatCard(
      gradient: const LinearGradient(
        colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5)],
      ),
      child: Row(

        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                isNextOrder ?'Next Order':'Last Order',
                style: TextStyle(fontSize: 18,color: Colors.grey.shade600),
              ),
              // const SizedBox(height: 4),
              Text(

                client.lastOrderDate == null
                    ? 'No recent order'
                    : isNextOrder ? 'After ${_daysAgo(client.lastOrderDate!)} days':'${_daysAgo(client.lastOrderDate!)} days ago',
                style: TextStyle(color: Colors.grey.shade400,fontSize: 14),
              ),
            ],
          ),
          Spacer(),
          Column(

            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${client.outstandingAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // const SizedBox(height: 4),
              Text(
                'Margin: 20%',
                style: TextStyle(fontSize: 12,color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              nextDeliveryButton(isNextOrder: isNextOrder),

            ],
          ),







        ],
      ),
    );
  }

  String _daysAgo(DateTime d) =>
      DateTime.now().difference(d).inDays.toString();
}



Widget nextDeliveryButton({
  required bool isNextOrder,
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(4),
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
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
            isNextOrder ?'View Order':'View Delivery',
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
