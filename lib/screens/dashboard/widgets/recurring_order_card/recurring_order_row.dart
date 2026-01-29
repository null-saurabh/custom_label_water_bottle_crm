// ✅ REUSABLE ROW FOR STANDING / RECURRING ORDERS
import 'package:clwb_crm/screens/dashboard/models/dashboard_models.dart';
import 'package:flutter/material.dart';


class RecurringOrderRow extends StatelessWidget {
  final StandingOrderSummary data;
  final VoidCallback? onTap;


  const RecurringOrderRow({super.key, required this.data,
    this.onTap,

  });

  @override
  Widget build(BuildContext context) {
    final progress =
    (data.fulfilledQty / data.committedQty).clamp(0.0, 1.0);

    final cycleLabel =
    data.cycle == RecurringCycle.weekly ? 'Weekly Order' : 'Monthly Order';

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFD),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            // CLIENT AVATAR
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF4C6FFF),
              child: Text(
                data.client[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // CLIENT + CYCLE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.client,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cycleLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // PROGRESS
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 110,
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFE0E7FF),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      data.cycle == RecurringCycle.weekly
                          ? const Color(0xFF4C6FFF)
                          : const Color(0xFF7CBFA2),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${data.fulfilledQty} / ${data.committedQty}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
