import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/order_controller.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/order_detail_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void openOrderDetailDialog(BuildContext context, OrderModel order) {
  // If another detail dialog is already open, close it first
  if (Get.isDialogOpen == true) {
    Get.back();
  }

  Get.generalDialog(
    barrierLabel: 'Order Details',
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.15),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (ctx, a1, a2) {
      return Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: 340,
            height: MediaQuery.of(ctx).size.height,
            child: OrdersDetailPanel(
              order: order,
              onClose: () {
                // Close dialog, then clear selection
                if (Get.isDialogOpen == true) Get.back();
                Get.find<OrdersController>().clearSelection();
              },
            ),
          ),
        ),
      );
    },
    transitionBuilder: (ctx, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0), // slide from right
          end: Offset.zero,
        ).animate(curved),
        child: child,
      );
    },
  ).then((_) {
    // Dialog closed by barrier tap / back / ESC
    final c = Get.find<OrdersController>();
    if (c.selectedOrderId.value != null) {
      c.clearSelection();
    }
  });
}
