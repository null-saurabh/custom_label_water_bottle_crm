import 'package:clwb_crm/core/utils/responsive.dart';
import 'package:clwb_crm/screens/sales/sales_controller.dart';
import 'package:clwb_crm/screens/sales/sales_screen.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesShellScreen extends GetView<SalesController> {
  const SalesShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return context.isMobile
        ? const SalesMobileView()
        : const SalesScreen();
  }
}
