
import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_activity_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverviewStockFlowTable extends GetView<InventoryController> {
  final String itemId;

  const OverviewStockFlowTable({
    super.key,
    required this.itemId,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final activities = controller
          .inventoryActivitiesForItem(itemId)
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      final recent = activities.toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Stock Movement History',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),

          if (recent.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No stock movement yet'),
            )
          else ...[
            const _FlowHeader(),
            const SizedBox(height: 8),
            ...recent.map((a) => _FlowRow(activity: a)),
          ],
        ],
      );
    });
  }
}



class _FlowHeader extends StatelessWidget {
  const _FlowHeader();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      color: Color(0xFF6B7280),
      fontSize: 12,
      fontWeight: FontWeight.w700,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: const [
          Expanded(flex: 4, child: Text('Date', style: style)),
          Expanded(flex: 5, child: Text('Source', style: style)),
          Expanded(flex: 3, child: Text('Δ Qty', style: style)),
          Expanded(flex: 4, child: Text('Type', style: style)),
          Expanded(flex: 8, child: Text('Note', style: style)),
        ],
      ),
    );
  }
}


class _FlowRow extends StatelessWidget {
  final InventoryActivityModel activity;

  const _FlowRow({required this.activity});

  @override
  Widget build(BuildContext context) {
    final isIn = activity.stockDelta >= 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          _cell(_fmt(activity.createdAt), flex: 4),

          _cell(
            _sourceLabel(activity, Get.find<InventoryController>()),
            flex: 5,
          ),

          _cell(
            '${isIn ? '+' : ''}${activity.stockDelta}',
            flex: 3,
            highlight: true,
            color: isIn
                ? const Color(0xFF047857)
                : const Color(0xFFB91C1C),
          ),

          _cell(
            _typeLabel(activity),
            flex: 4,
            dim: true,
          ),

          _cell(
            activity.description,
            flex: 8,
          ),
        ],
      ),
    );
  }

  static Widget _cell(
      String text, {
        required int flex,
        bool highlight = false,
        bool dim = false,
        Color? color,
      }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: highlight ? FontWeight.w700 : FontWeight.w600,
          color: color ??
              (dim
                  ? const Color(0xFF6B7280)
                  : const Color(0xFF111827)),
        ),
      ),
    );
  }

  static String _fmt(DateTime d) =>
      '${d.day}/${d.month}/${d.year}';

  static String _typeLabel(InventoryActivityModel a) {
    switch (a.type) {
      case 'stock_in':
      case 'purchase_receive':
        return 'Stock In';
      case 'production_use':
        return 'Production';
      case 'cancel_restock':
        return 'Restock';
      case 'stock_meta_corrected':
        return 'Correction';
      default:
        return a.type;
    }
  }

  static String _sourceLabel(
      InventoryActivityModel a,
      InventoryController controller,
      ) {
    if (a.source == 'purchase' || a.source == 'purchase_receive') {
      return controller.supplierNameForStockActivity(a);
    }
    if (a.source == 'order') return 'Production';
    if (a.source == 'order_cancel') return 'Order Cancel';
    if (a.source == 'manual') return 'Manual';
    return 'System';
  }
}

