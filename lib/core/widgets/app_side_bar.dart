// lib/core/widgets/app_sidebar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();

    return Container(
      width: 260,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF6F8FD),
            Color(0xFFF1F4FA),
          ],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),

          // LOGO
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/icons/main_logo.png',
                  height: 40, // smaller, tighter like reference
                  fit: BoxFit.contain,
                  color: Colors.blue,
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Custom Label',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Bottling',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // USER INFO
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              children:  [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(
                    Icons.person_outline,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),

                SizedBox(width: 8),
                Column(
                  children: [
                    Text(
                      'John Parker',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Sales Manager',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                )

              ],
            ),
          ),

          const SizedBox(height: 32),

          // MENU
          Expanded(
            child: Obx(
                  () => ListView(
                padding: EdgeInsets.zero,
                children: [
                  _SidebarItem(
                    icon: Icons.dashboard_outlined,
                    label: 'Dashboard',
                    isActive:
                    controller.selectedMenu.value ==
                        SidebarMenu.dashboard,
                    onTap: () =>
                        controller.selectMenu(SidebarMenu.dashboard),
                  ),
                  _SidebarItem(
                    icon: Icons.receipt_long_outlined,
                    label: 'Orders',
                    isActive:
                    controller.selectedMenu.value ==
                        SidebarMenu.orders,
                    onTap: () =>
                        controller.selectMenu(SidebarMenu.orders),
                  ),
                  _SidebarItem(
                    icon: Icons.people_outline,
                    label: 'Clients',
                    isActive:
                    controller.selectedMenu.value ==
                        SidebarMenu.clients,
                    onTap: () =>
                        controller.selectMenu(SidebarMenu.clients),
                  ),
                  _SidebarItem(
                    icon: Icons.people_outline,
                    label: 'Leads',
                    isActive:
                    controller.selectedMenu.value ==
                        SidebarMenu.leads,
                    onTap: () =>
                        controller.selectMenu(SidebarMenu.leads),
                  ),
                  _SidebarItem(
                    icon: Icons.inventory_2_outlined,
                    label: 'Inventory',
                    isActive:
                    controller.selectedMenu.value ==
                        SidebarMenu.inventory,
                    onTap: () =>
                        controller.selectMenu(SidebarMenu.inventory),
                  ),
                  _SidebarItem(
                    icon: Icons.bar_chart_outlined,
                    label: 'Sales',
                    isActive:
                    controller.selectedMenu.value ==
                        SidebarMenu.sales,
                    onTap: () =>
                        controller.selectMenu(SidebarMenu.sales),
                  ),
                ],
              ),
            ),
          ),

          // FOOTER ACTIONS
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _FooterItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                ),
                const SizedBox(height: 8),
                _FooterItem(
                  icon: Icons.logout,
                  label: 'Logout',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: isActive
                ? const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF5B7CFA),
                Color(0xFF4C6FFF),
              ],
            )
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : Colors.grey.shade700,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color:
                  isActive ? Colors.white : Colors.grey.shade800,
                  fontWeight:
                  isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FooterItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade700),
        ),
      ],
    );
  }
}
