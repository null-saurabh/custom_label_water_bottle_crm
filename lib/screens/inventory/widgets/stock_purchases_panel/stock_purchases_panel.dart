import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:clwb_crm/screens/inventory/inventory_controller.dart';

class InventoryStockPurchasesPanel extends GetView<InventoryController> {
  const InventoryStockPurchasesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('d MMM');

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 800),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE6EAF2)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  const Text(
                    'Stock Purchases',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: controller.openAddStockDialog,
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Row(
                        children: const [
                          Icon(Icons.add, size: 18, color: Color(0xFF6D5EF6)),
                          SizedBox(width: 6),
                          Text(
                            'Add',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF6D5EF6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Search
              _SearchBox(
                hint: 'Search by supplier...',
                controller: controller.stockSupplierSearchCtrl,
                onChanged: controller.setStockSupplierSearch,
              ),

              const SizedBox(height: 12),

              // Table
              Obx(() {
                final list = controller.filteredStockPurchases; // pending/partial + search applied

                if (list.isEmpty) {
                  return _EmptyState(
                    title: 'No pending purchases',
                    subtitle: 'All purchases are fully received or match your search.',
                  );
                }

                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE6EAF2)),
                  ),
                  child: Column(
                    children: [
                      // header
                      _HeaderRow(),

                      const Divider(height: 1, thickness: 1, color: Color(0xFFE6EAF2)),

                      // rows
                      ...list.take(8).map((e) {
                        final supplierName = controller.supplierName(e.supplierId);
                        final ordered = e.orderedQuantity;
                        final received = e.receivedQuantity;
                        final pending = ordered - received;

                        final paid = e.paidAmount;
                        final due = e.dueAmount;

                        final nextDeliveryText = e.deliveryDate != null
                            ? df.format(e.deliveryDate!)
                            : '—';
                        final itemName = controller.itemName(e.itemId);

                        final statusText = e.status.name; // pending / partial / received

                        return Column(
                          children: [
                            _DataRow(
                              supplier: supplierName,
                              item: itemName,
                              ordered: ordered,
                              received: received,
                              pending: pending,
                              paid: paid,
                              due: due,
                              nextDelivery: nextDeliveryText,
                              status: statusText,
                              onAddDelivery: () => controller.openStockReceiveDialog(e),
                              onAddPayment: () => controller.openStockPaymentDialog(e),
                              onEdit: () => controller.openStockCorrectionDialog(e),
                              onView: () => controller.openStockPurchaseViewDialog(e),

                            ),
                            const Divider(height: 1, thickness: 1, color: Color(0xFFE6EAF2)),
                          ],
                        );
                      }),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 6),

            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: Color(0xFF6B7280),
    );

    return Container(
      // color: const Color(0xFFF1F4F9), // 🔥 header grey
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: const [
          Expanded(flex: 12, child: Text('Supplier', style: headerStyle)),
          Expanded(flex: 8, child: Text('Purchased', style: headerStyle)),
          Expanded(flex: 5, child: Text('Ordered', style: headerStyle)),
          Expanded(flex: 5, child: Text('Received', style: headerStyle)),
          Expanded(flex: 5, child: Text('Pending', style: headerStyle)),
          Expanded(flex: 6, child: Text('Paid / Due', style: headerStyle)),
          Expanded(flex: 5, child: Text('Next Delivery', style: headerStyle)),
          SizedBox(width: 100),
        ],
      ),
    );

  }
}

class _DataRow extends StatelessWidget {
  final String supplier;
  final String item;
  final int ordered;
  final int received;
  final int pending;
  final double paid;
  final double due;
  final String nextDelivery;
  final String status;

  final VoidCallback onAddDelivery;
  final VoidCallback onAddPayment;
  final VoidCallback onEdit;
  final VoidCallback onView;


  const _DataRow({
    required this.supplier,
    required this.ordered,
    required this.received,
    required this.pending,
    required this.paid,
    required this.due,
    required this.nextDelivery,
    required this.status,
    required this.onAddDelivery,
    required this.onAddPayment,
    required this.onEdit, required this.item, required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final money = _money;

    final pendingStyle = TextStyle(
      fontWeight: FontWeight.w800,
      color: pending > 0 ? const Color(0xFF111827) : const Color(0xFF6B7280),
    );

    return Container(
      color: Colors.white, // 🔥 header grey

      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),

      child: Row(
        children: [
          Expanded(
            flex: 12,
            child: Text(
              supplier,
              style: const TextStyle(fontWeight: FontWeight.w700),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 8,
            child: Text(
              item,
              style: const TextStyle(fontWeight: FontWeight.w700),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Expanded(flex: 5, child: Text('$ordered')),
          Expanded(flex: 5, child: Text('$received')),
          Expanded(flex: 5, child: Text('$pending', style: pendingStyle)),
          Expanded(
            flex: 6,
            child: Text(
              '₹${money(paid)} / ₹${money(due)}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nextDelivery,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  status,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),

          // Actions (icons instead of big button)
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _IconAction(
                      tooltip: 'Add received quantity',
                      icon: Icons.local_shipping_outlined,
                      onTap: onAddDelivery,
                    ),
                    const SizedBox(width: 6),
                    _IconAction(
                      tooltip: 'Add payment',
                      icon: Icons.currency_rupee,
                      onTap: onAddPayment,
                    ),

                  ],
                ),
                const SizedBox(height: 6),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    _IconAction(
                      tooltip: 'Edit / correct entry',
                      icon: Icons.edit_outlined,
                      onTap: onEdit,
                    ),
                    const SizedBox(width: 6),
                    _IconAction(
                      tooltip: 'View details',
                      icon: Icons.visibility_outlined,
                      onTap: onView,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _money(double v) {
    // You can later replace with NumberFormat if you want commas
    return v.toStringAsFixed(0);
  }
}

class _IconAction extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  const _IconAction({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF6D5EF6)),
        ),
      ),
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
