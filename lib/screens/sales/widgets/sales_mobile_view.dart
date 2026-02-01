import 'package:clwb_crm/screens/sales/sales_controller.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_delivery_table.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_header.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_kpi_row_mobile.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_top_client.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_top_item.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_top_order.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_trend_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesMobileView extends GetView<SalesController> {
  const SalesMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        controller.orders.length;
        controller.deliveries.length;
        controller.expenses.length;
        controller.preset.value;
        controller.customStart.value;
        controller.customEnd.value;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SalesHeader(controller),
            const SizedBox(height: 16),

            /// 🔥 KPI HORIZONTAL SCROLL
            SalesKpiRowMobile(controller),
            const SizedBox(height: 18),

            TrendCard(controller),
            const SizedBox(height: 18),

            SalesDeliveriesTable(controller),
            const SizedBox(height: 18),

            TopClients(controller),
            const SizedBox(height: 18),

            SalesTopItems(controller),
            const SizedBox(height: 18),

            SalesTopOrders(controller),
            const SizedBox(height: 24),
          ],
        );
      }),
    );
  }
}
