import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/model/supplier_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupplierRow extends GetView<InventoryController> {
  final SupplierModel supplier;
  final VoidCallback onTap;
  final String pendingAmount;
  final String pendingOrders;
  final String nextDeliveryDate;



  const SupplierRow( {
    super.key,
    required this.supplier,
    required this.onTap,
    required this.pendingAmount, required this.pendingOrders, required this.nextDeliveryDate,

  });

  @override
  Widget build(BuildContext context) {
    // final categories =
    // controller.supplierCategories(supplier.id);


    // final nextDeliveryDate =
    // controller.supplierNextDeliveryDate(supplier.id) ?? "N/A";
    // final pendingOrders =
    // controller.supplierPendingDeliveries(supplier.id);
    // final pendingAmount =
    // controller.supplierPendingAmount(supplier.id);


    final totalPurchased =
    controller.supplierTotalPurchased(supplier.id);

    return InkWell(
      onTap: onTap,

      child: Row(
        children: [
          _itemCell(),
          // _textCell(categories,15),
          _textCell(pendingOrders,5),
          _textCell(nextDeliveryDate,5),
          _redText('₹$pendingAmount'),
          _greenText('₹${totalPurchased.toStringAsFixed(0)}'),
          // const SizedBox(
          //   width: 32,
          //   child: Icon(
          //     Icons.arrow_forward_ios,
          //     size: 14,
          //     color: Colors.grey,
          //   ),
          // ),
        ],
      ),
    );
  }

  /// ===== CELLS =====

  Widget _itemCell() {
    return Expanded(
      flex: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            supplier.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            supplier.isActive ? 'Active' : 'Inactive',
            style: TextStyle(
              fontSize: 12,
              color: supplier.isActive
                  ? Colors.green
                  : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _textCell(String text,int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _greenText(String text) {
    return Expanded(
      flex: 5,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _redText(String text) {
    return Expanded(
      flex: 5,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.red,
        ),
      ),
    );
  }
}
