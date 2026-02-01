import 'package:clwb_crm/screens/sales/sales_controller.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_delivery_table.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_header.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_kpi_row.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_top_client.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_top_item.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_top_order.dart';
import 'package:clwb_crm/screens/sales/widgets/sales_trend_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesScreen extends GetView<SalesController> {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Obx(() {
          // 🔥 FORCE rebuild on ALL range mutations
          controller.orders.length;
          controller.deliveries.length;
          controller.expenses.length;
          controller.preset.value;
          controller.customStart.value;
          controller.customEnd.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SalesHeader(controller),
              const SizedBox(height: 18),

              SalesKpiRow(controller),
              const SizedBox(height: 18),

              Expanded(
                child: SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            TrendCard(controller),
                            const SizedBox(height: 18),
                            SalesDeliveriesTable(controller),
                          ],
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            TopClients(controller),
                            const SizedBox(height: 18),
                            SalesTopItems(controller),
                            const SizedBox(height: 18),
                            SalesTopOrders(controller),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}














































