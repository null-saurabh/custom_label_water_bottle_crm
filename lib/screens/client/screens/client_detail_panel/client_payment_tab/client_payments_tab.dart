import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_payment_tab/client_payments_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ClientPaymentsTab extends StatelessWidget {
  final String clientId;
  const ClientPaymentsTab({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ClientPaymentsController(clientId), tag: clientId);

    return Obx(() {
      if (c.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TopSummary(
              totalReceived: c.totalReceived.value,
              count: c.totalCount.value,
            ),
            const SizedBox(height: 14),

            _Header(),
            const SizedBox(height: 10),

            if (c.payments.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No payments received yet'),
              )
            else
              ...c.payments.map((p) => _Row(
                date: p.expenseDate,
                amount: p.amount,
                orderId: p.orderId,
                ref: p.referenceNo,
              )),
          ],
        ),
      );
    });
  }
}

class _TopSummary extends StatelessWidget {
  final double totalReceived;
  final int count;

  const _TopSummary({
    required this.totalReceived,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Received', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                const SizedBox(height: 6),
                Text('₹${totalReceived.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          Container(width: 1, height: 42, color: const Color(0xFFE5E7EB)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payments', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                const SizedBox(height: 6),
                Text('$count', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w800,
      color: Color(0xFF6B7280),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Expanded(flex: 3, child: Text('Date', style: style)),
          Expanded(flex: 3, child: Text('Amount', style: style)),
          Expanded(flex: 4, child: Text('Order', style: style)),
          Expanded(flex: 4, child: Text('Ref', style: style)),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final DateTime date;
  final double amount;
  final String orderId;
  final String? ref;

  const _Row({
    required this.date,
    required this.amount,
    required this.orderId,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final d = DateFormat('d MMM yyyy').format(date);

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(d)),
          Expanded(flex: 3, child: Text('₹${amount.toStringAsFixed(0)}')),
          Expanded(
            flex: 4,
            child: Text(
              orderId.length > 6 ? orderId.substring(0, 6) : orderId,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(flex: 4, child: Text((ref ?? '—').toString(), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
