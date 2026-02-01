import 'package:clwb_crm/core/controllers/app_controller.dart';
import 'package:clwb_crm/firebase/auth_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MobileMoreMenu {
  static void open(BuildContext context) {
    final controller = Get.find<AppController>();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'More Menu',
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.white,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: double.infinity,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MenuHeader(),
                  _WelcomeSection(),

                  const Divider(height: 1),

                  _MenuItem(
                    icon: Icons.receipt_long_outlined,
                    label: 'Orders',
                    onTap: () {
                      Get.back();
                      controller.selectMenu(SidebarMenu.orders);
                    },
                  ),
                  _MenuItem(
                    icon: Icons.inventory_2_outlined,
                    label: 'Inventory',
                    onTap: () {
                      Get.back();
                      controller.selectMenu(SidebarMenu.inventory);
                    },
                  ),
                  _MenuItem(
                    icon: Icons.people_outline,
                    label: 'Clients',
                    onTap: () {
                      Get.back();
                      controller.selectMenu(SidebarMenu.clients);
                    },
                  ),
                  _MenuItem(
                    icon: Icons.people_outline,
                    label: 'Leads',
                    onTap: () {
                      Get.back();
                      controller.selectMenu(SidebarMenu.leads);
                    },
                  ),
                  _MenuItem(
                    icon: Icons.bar_chart_outlined,
                    label: 'Sales',
                    onTap: () {
                      Get.back();
                      controller.selectMenu(SidebarMenu.sales);
                    },
                  ),

                  const Spacer(),

                  _MenuFooter(controller: controller),
                ],
              ),

            ),
          ),
        );
      },
      transitionBuilder: (_, animation, __, child) {
        final tween =
        Tween(begin: const Offset(1, 0), end: Offset.zero);
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}



class _MenuHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Row(
          children: [
            Image.asset(
              'assets/icons/main_logo.png',
              height: 42,
            ),
            const SizedBox(width: 12),
            const Text(
              'Ink & Drink',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _WelcomeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F8FD),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFE1E7FF),
              child: Text(
                AuthUser.name.isNotEmpty
                    ? AuthUser.name[0].toUpperCase()
                    : 'S',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xFF4C6FFF),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AuthUser.name ,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (AuthUser.email.isNotEmpty)
                    Text(
                      AuthUser.email,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Icon(icon, color: Colors.grey.shade700),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _MenuFooter extends StatelessWidget {
  final AppController controller;

  const _MenuFooter({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: InkWell(
          onTap: controller.handleAuthAction,
          child: Row(
            children: [
              Icon(
                !controller.isAdmin ? Icons.login : Icons.logout,
                size: 18,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 10),
              Text(
                !controller.isAdmin ? 'Admin Login' : 'Logout',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
