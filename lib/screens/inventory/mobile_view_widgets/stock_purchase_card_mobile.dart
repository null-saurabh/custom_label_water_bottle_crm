import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../inventory_controller.dart';

class InventoryStockPurchasesMobilePanel
    extends GetView<InventoryController> {
  const InventoryStockPurchasesMobilePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('d MMM');

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 500),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER (same as desktop, minus Add button)
              const Text(
                'Stock Purchases',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
          
              const SizedBox(height: 12),
          
              /// SEARCH (UNCHANGED)
              _SearchBox(
                hint: 'Search by supplier...',
                controller: controller.stockSupplierSearchCtrl,
                onChanged: controller.setStockSupplierSearch,
              ),
          
              const SizedBox(height: 12),
          
              /// LIST
              Obx(() {
                final list = controller.filteredStockPurchases;
          
                if (list.isEmpty) {
                  return const _EmptyState(
                    title: 'No pending purchases',
                    subtitle: 'All purchases are fully received or match your search.',
                  );
                }
          
                return Column(
                  children: list.map((e) {
                    final supplier = controller.supplierName(e.supplierId);
                    final item = controller.itemName(e.itemId);
                    final ordered = e.orderedQuantity;
                    final received = e.receivedQuantity;
                    final pending = ordered - received;
          
                    final paid = e.paidAmount;
                    final due = e.dueAmount;
          
                    final nextDelivery =
                    e.deliveryDate != null ? df.format(e.deliveryDate!) : '—';
          
                    return _StockPurchaseCard(
                      supplier: supplier,
                      item: item,
                      ordered: ordered,
                      received: received,
                      pending: pending,
                      paid: paid,
                      due: due,
                      nextDelivery: nextDelivery,
                      status: e.status.name,
                      onAddDelivery: () =>
                          controller.openStockReceiveDialog(e),
                      onAddPayment: () =>
                          controller.openStockPaymentDialog(e),
                      onEdit: () =>
                          controller.openStockCorrectionDialog(e),
                      onView: () =>
                          controller.openStockPurchaseViewDialog(e),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}


class _StockPurchaseCard extends StatelessWidget {
  final String supplier;
  final String item;
  final int ordered, received, pending;
  final double paid, due;
  final String nextDelivery, status;
  final VoidCallback onAddDelivery, onAddPayment, onEdit, onView;

  const _StockPurchaseCard({
    required this.supplier,
    required this.item,
    required this.ordered,
    required this.received,
    required this.pending,
    required this.paid,
    required this.due,
    required this.nextDelivery,
    required this.status,
    required this.onAddDelivery,
    required this.onAddPayment,
    required this.onEdit,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(supplier,
              style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(item, style: const TextStyle(color: Colors.grey)),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _metric('Ordered', ordered),
              _metric('Received', received),
              _metric('Pending', pending,
                  color: pending > 0 ? Colors.red : Colors.green),
            ],
          ),

          const SizedBox(height: 8),

          Text('₹${paid.toStringAsFixed(0)} paid · ₹${due.toStringAsFixed(0)} due',
              style: const TextStyle(fontWeight: FontWeight.w600)),

          const SizedBox(height: 4),

          Text('Next: $nextDelivery · $status',
              style: const TextStyle(fontSize: 12, color: Colors.grey)),

          const SizedBox(height: 10),

          /// ACTIONS
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _icon(Icons.local_shipping_outlined, onAddDelivery),
              _icon(Icons.currency_rupee, onAddPayment),
              _icon(Icons.edit_outlined, onEdit),
              _icon(Icons.visibility_outlined, onView),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metric(String label, int v, {Color? color}) {
    return Column(
      children: [
        Text('$v',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: color)),
        Text(label,
            style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _icon(IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, size: 20),
      onPressed: onTap,
    );
  }
}




class _SearchBox extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBox({
    required this.hint,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}


class _EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  const _EmptyState({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          const Icon(Icons.inventory_2_outlined, color: Color(0xFF6B7280)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Color(0xFF6B7280))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

