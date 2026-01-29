// lib/features/dashboard/widgets/dashboard_kpi_row.dart
import 'package:clwb_crm/screens/dashboard/dashboard_controller.dart';
import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_item_model.dart';
import 'package:clwb_crm/screens/leads/leads_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardKpiRow extends GetView<DashboardController> {
  const DashboardKpiRow({super.key});

  @override
  Widget build(BuildContext context) {
    final inv = Get.find<InventoryController>();   // live inventory data
    final leads = Get.isRegistered<LeadsController>()
        ? Get.find<LeadsController>()
        : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        const double cardHeight = 110;

        return SizedBox(
          height: cardHeight,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(() {
              // ---------- Inventory KPIs ----------
              final totalBottleStock = inv.items
                  .where((i) => i.isActive && i.category == InventoryCategory.bottle)
                  .fold<int>(0, (s, i) => s + i.stock);

              // Low stock alerts = items below reorder OR shortage warnings
              // (using your existing inventoryWarnings logic)
              final lowStockSkus = inv.inventoryWarnings
                  .map((w) => w.item.id)
                  .toSet()
                  .length;

              // ---------- Leads ----------

              final newLeads = leads?.newLeadsCount ?? 0;

              return Row(
                children: [
                  _KpiCard(
                    title: 'Inventory',
                    value: '$totalBottleStock',
                    suffix: 'Bottles',
                    icon: Icons.inventory_2_outlined,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5B7CFA), Color(0xFF4C6FFF)],
                    ),
                  ),
                  const SizedBox(width: 20),

                  _KpiCard(
                    title: 'Total Orders',
                    value: '${controller.weekNewOrders.value}',
                    suffix: 'Created This Week',
                    icon: Icons.shopping_cart_outlined,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE6F4EA), Color(0xFFDFF3EA)],
                    ),
                    darkText: true,
                  ),
                  const SizedBox(width: 20),

                  _KpiCard(
                    title: 'Sales',
                    value: '₹${controller.salesThisWeek.value.toStringAsFixed(0)}',
                    suffix: 'Delivered This Week',
                    icon: Icons.payments_outlined,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEFF3FF), Color(0xFFE8EEFF)],
                    ),
                    darkText: true,
                  ),
                  const SizedBox(width: 20),

                  _KpiCard(
                    title: 'Leads',
                    value: '$newLeads',
                    suffix: 'New Leads',
                    icon: Icons.person_outline,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF4E5), Color(0xFFFFF1DD)],
                    ),
                    darkText: true,
                  ),
                  const SizedBox(width: 20),

                  _KpiCard(
                    title: 'Low Stock Alerts',
                    value: '$lowStockSkus',
                    suffix: 'SKUs',
                    icon: Icons.warning_amber_rounded,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFE6E6), Color(0xFFFFF0F0)],
                    ),
                    darkText: true,
                  ),
                  const SizedBox(width: 20),

                  _KpiCard(
                    title: 'Orders Due Today',
                    value: '${controller.dueTodayCount.value}',
                    suffix: 'Orders',
                    icon: Icons.today_outlined,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE9F7EF), Color(0xFFDFF5EA)],
                    ),
                    darkText: true,
                  ),
                  const SizedBox(width: 20),

                  _KpiCard(
                    title: 'Orders Due This Week',
                    value: '${controller.dueThisWeekCount.value}',
                    suffix: 'Orders',
                    icon: Icons.date_range_outlined,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEFF2FF), Color(0xFFE7EBFF)],
                    ),
                    darkText: true,
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

}


class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String suffix;
  final IconData icon;
  final LinearGradient gradient;
  final bool darkText;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.suffix,
    required this.icon,
    required this.gradient,
    this.darkText = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = darkText ? Color(0xff454d70) : Colors.white;

    return Container(
      width: 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: darkText
                      ? Colors.white
                      : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12), // tweak: 10–14 looks great
                ),
                child: Icon(
                  icon,
                  color: darkText ? Colors.black54 : Colors.white,
                  size: 22,
                ),
              ),

              const SizedBox(width: 14),
              Text(
                title,
                style: TextStyle(
                  color: textColor.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Icon(Icons.chevron_right, color: textColor.withOpacity(0.7)),


            ],
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

              Text(value,style: TextStyle(color: textColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,),),
              SizedBox(width: 8,),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(suffix,style: TextStyle(
                  color: textColor.withOpacity(0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),),
              )
            ],),
          )


        ],
      ),
    );
  }
}



