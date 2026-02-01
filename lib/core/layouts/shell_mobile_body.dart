import 'package:clwb_crm/core/controllers/app_controller.dart';
import 'package:clwb_crm/core/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShellMobileScaffold extends StatelessWidget {
  const ShellMobileScaffold({super.key});

  int _indexFromMenu(SidebarMenu menu) {
    switch (menu) {
      case SidebarMenu.dashboard:
        return 0;
      case SidebarMenu.orders:
        return 1;
      case SidebarMenu.inventory:
        return 2;
      case SidebarMenu.clients:
        return 3;
      default:
        return 0;
    }
  }

  SidebarMenu _menuFromIndex(int index) {
    switch (index) {
      case 0:
        return SidebarMenu.dashboard;
      case 1:
        return SidebarMenu.orders;
      case 2:
        return SidebarMenu.inventory;
      case 3:
        return SidebarMenu.clients;
      default:
        return SidebarMenu.dashboard;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();

    return Scaffold(
      // appBar: _buildMobileAppBar(controller),

      // 🔁 ROUTED CONTENT
      body: GetRouterOutlet(initialRoute: AppRoutes.dashboard),

      // ⬇️ BOTTOM NAV
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: _indexFromMenu(controller.selectedMenu.value),
          onTap: (index) {
            controller.selectMenu(_menuFromIndex(index));
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              activeIcon: Icon(Icons.inventory_2),
              label: 'Inventory',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Clients',
            ),
          ],
        ),
      ),
    );
  }
}

