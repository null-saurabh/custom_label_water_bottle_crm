import 'package:clwb_crm/core/utils/responsive.dart';
import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_order_tab/client_orders_controller.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';




class ClientOrdersTab extends StatelessWidget {
  final String clientId;
  final ClientModel client;

  const ClientOrdersTab({super.key, required this.clientId,required this.client});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ClientOrdersController(clientId), tag: clientId);

    return Obx(() {
      if (c.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Stack(
        children: [
          SingleChildScrollView(
            padding:  EdgeInsets.all(context.isMobile?0:16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SummaryRow(
                  total: c.totalOrders.value,
                  active: c.activeOrders.value,
                  delivered: c.deliveredOrders.value,
                  billed: c.totalBilled.value,
                  paid: c.totalPaid.value,
                  due: c.totalDue.value,
                ),
                const SizedBox(height: 14),

                _HeaderRow(),
                const SizedBox(height: 10),

                if (c.orders.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No orders for this client'),
                  )
                else
                  ...c.orders.map((o) => _OrderRow(order: o,client: client,c: c,)),
              ],
            ),
          ),


          Obx(() {
            if (!c.isGeneratingInvoice.value) {
              return const SizedBox.shrink();
            }

            return Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.35),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 12),
                      Text(
                        'Generating invoice…',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      );
    });
  }
}

class _SummaryRow extends StatelessWidget {
  final int total;
  final int active;
  final int delivered;
  final double billed;
  final double paid;
  final double due;

  const _SummaryRow({
    required this.total,
    required this.active,
    required this.delivered,
    required this.billed,
    required this.paid,
    required this.due,
  });

  @override
  Widget build(BuildContext context) {
    Widget chip(String label, String value, {Color? bg, Color? fg}) {
      return Container(
        height: 75,
        width: 150,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bg ?? const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontWeight: FontWeight.w800, color: fg ?? const Color(0xFF111827))),
          ],
        ),
      );
    }

    return SizedBox(
      height: 75, // adjust if your chips are taller
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            chip('Total Orders', '$total'),
            const SizedBox(width: 16),
            chip(
              'Active',
              '$active',
              bg: const Color(0xFFE0F2FE),
              fg: const Color(0xFF0369A1),
            ),
            const SizedBox(width: 16),
            chip(
              'Delivered',
              '$delivered',
              bg: const Color(0xFFD1FAE5),
              fg: const Color(0xFF047857),
            ),
            const SizedBox(width: 16),
            chip('Billed', '₹${billed.toStringAsFixed(0)}'),
            const SizedBox(width: 16),
            chip(
              'Paid',
              '₹${paid.toStringAsFixed(0)}',
              bg: const Color(0xFFF0FDF4),
              fg: const Color(0xFF166534),
            ),
            const SizedBox(width: 16),
            chip(
              'Due',
              '₹${due.toStringAsFixed(0)}',
              bg: const Color(0xFFFEF2F2),
              fg: const Color(0xFF991B1B),
            ),
          ],
        ),
      ),
    );

  }
}

class _HeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return const SizedBox.shrink(); // ❌ no header on mobile
    }

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
          Expanded(flex: 4, child: Text('Order', style: style)),
          Expanded(flex: 3, child: Text('Delivery', style: style)),
          Expanded(flex: 3, child: Text('Paid', style: style)),
          Expanded(flex: 3, child: Text('Due', style: style)),
          Expanded(flex: 3, child: Text('Status', style: style)),
          SizedBox(width: 80),
        ],
      ),
    );
  }
}


class _OrderRow extends StatelessWidget {
  final OrderModel order;
  final ClientModel client;
  final ClientOrdersController c;

  const _OrderRow({
    required this.order,
    required this.client,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    final d = order.expectedDeliveryDate;
    final delivery = d == null ? '—' : DateFormat('d MMM').format(d);

    // =========================
    // 📱 MOBILE CARD VIEW
    // =========================
    if (context.isMobile) {
      return Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order number + status
            Row(
              children: [
                Text(
                  order.orderNumber,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                _StatusChip(order.orderStatus),
              ],
            ),

            const SizedBox(height: 8),

            _kv('Delivery', delivery),
            _kv('Paid', '₹${order.paidAmount.toStringAsFixed(0)}'),
            _kv('Due', '₹${order.dueAmount.toStringAsFixed(0)}'),

            const SizedBox(height: 10),

            // Actions
            Row(
              children: [
                _ActionButton(
                  icon: Icons.picture_as_pdf,
                  label: 'Invoice',
                  onTap: c.isGeneratingInvoice.value
                      ? null
                      : () => c.generateInvoiceWithoutPaymentPdf(
                    order: order,
                    client: client,
                  ),
                ),
                const SizedBox(width: 12),
                _ActionButton(
                  icon: Icons.picture_as_pdf,
                  label: 'Invoice + Pay',
                  onTap: c.isGeneratingInvoice.value
                      ? null
                      : () => c.generateInvoiceWithPaymentPdf(
                    order: order,
                    client: client,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // =========================
    // 🖥 DESKTOP ROW (UNCHANGED LOGIC)
    // =========================
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
          Expanded(
            flex: 4,
            child: Text(
              order.orderNumber,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          Expanded(flex: 3, child: Text(delivery)),
          Expanded(flex: 3, child: Text('₹${order.paidAmount.toStringAsFixed(0)}')),
          Expanded(flex: 3, child: Text('₹${order.dueAmount.toStringAsFixed(0)}')),
          Expanded(flex: 3, child: Text(order.orderStatus)),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Generate Invoice Without Payment',
            onPressed: c.isGeneratingInvoice.value
                ? null
                : () => c.generateInvoiceWithoutPaymentPdf(
              order: order,
              client: client,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Generate Invoice With Payment',
            onPressed: c.isGeneratingInvoice.value
                ? null
                : () => c.generateInvoiceWithPaymentPdf(
              order: order,
              client: client,
            ),
          ),
        ],
      ),
    );
  }

  Widget _kv(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}








class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip(this.status);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
      ),
    );
  }
}
