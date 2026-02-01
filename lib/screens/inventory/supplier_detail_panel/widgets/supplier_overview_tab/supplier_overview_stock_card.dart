import 'package:clwb_crm/core/utils/responsive.dart';
import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/model/supplier_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SupplierOverviewStockCard extends GetView<InventoryController> {
  final SupplierModel item;

  const SupplierOverviewStockCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final supplierId = item.id;

      final itemsCount =
      controller.supplierItemsCount(supplierId);

      final purchaseCount =
      controller.supplierPurchaseCount(supplierId);

      final totalBusiness =
      controller.supplierTotalPurchased(supplierId);

      final dueAmount =
      controller.supplierPendingAmount(supplierId);

      final pendingDeliveries =
      controller.supplierPendingDeliveries(supplierId);

      final pendingDeliveryQty =
      controller.supplierPendingDeliveryQuantity(supplierId);

      final pendingDeliveryValue =
      controller.supplierPendingDeliveryValue(supplierId);

      return Column(
        children: [
          Row(
            children: [
              _ValueCard(
                title: 'Delivery Due',
                value: pendingDeliveries.toString(),
                sub: 'Open Deliveries',
                valueColor: Colors.red,
                titleColor: Colors.red,
              ),
               SizedBox(width:  context.isMobile? 8 :16),
              _ValueCard(
                title: 'Stock Purchases',
                value: purchaseCount.toString(),
                sub: 'Total Orders',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _ValueCard(
                title: 'Total Business',
                value: '₹${totalBusiness.toStringAsFixed(0)}',
                sub: 'Lifetime',
              ),
               SizedBox(width:  context.isMobile? 8 :16),
              _ValueCard(
                title: 'Amount Due',
                value: '₹${dueAmount.toStringAsFixed(0)}',
                sub: 'Payment Due',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _ValueCard(
                title: 'Units Pending',
                value: pendingDeliveryQty.toString(),
                sub: 'Yet to Receive',
              ),
              const SizedBox(width: 16),

              _ValueCard(
                title: 'Units Pending Value',
                value: pendingDeliveryValue.toString(),
                sub: 'Open Deliveries',
              ),
            ],
          ),
        ],
      );
    });
  }
}


class _ValueCard extends StatelessWidget {
  final String title;
  final String value;
  final String sub;
  final Color? titleColor;
  final Color? valueColor;
  final bool editable;

  const _ValueCard({
    required this.title,
    required this.value,
    required this.sub,
    this.editable = false,
    this.valueColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.shade50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded( // ✅ constrains Text so ellipsis can work
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(
                      color: titleColor ?? Colors.grey.shade600, // ✅ use titleColor
                    ),
                  ),
                ),

                if (editable) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.edit, size: 16),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              maxLines: 1, // optional safety
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}






// class _ValueCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final String sub;
//   final Color? titleColor;
//   final Color? valueColor;
//   final bool editable;
//
//   const _ValueCard({
//     required this.title,
//     required this.value,
//     required this.sub,
//     this.editable = false, this.valueColor, this.titleColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(18),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           color: Colors.grey.shade50,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   title,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   softWrap: false,
//                   style: TextStyle(
//                     color: valueColor ?? Colors.grey.shade600,
//                   ),
//                 ),
//
//                 if (editable) ...[
//                   const Spacer(),
//                   const Icon(Icons.edit, size: 16),
//                 ]
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: valueColor
//               ),
//             ),
//             // const SizedBox(height: 4),
//             // Text(sub, style: TextStyle(color: Colors.grey.shade600)),
//           ],
//         ),
//       ),
//     );
//   }
// }
