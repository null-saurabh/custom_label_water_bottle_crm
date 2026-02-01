import 'package:clwb_crm/core/utils/responsive.dart';
import 'package:clwb_crm/screens/orders/order_controller.dart';
import 'package:clwb_crm/screens/orders/orders_mobile_view.dart';
import 'package:clwb_crm/screens/orders/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersShellScreen extends GetView<OrdersController> {
  const OrdersShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return context.isMobile
        ? const OrdersMobileView()
        : const OrdersPage();
  }
}
