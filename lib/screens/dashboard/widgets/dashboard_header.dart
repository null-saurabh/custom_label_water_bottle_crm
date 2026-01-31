// lib/features/dashboard/widgets/dashboard_header.dart
import 'package:clwb_crm/core/layouts/mobile_side_menu.dart';
import 'package:clwb_crm/core/utils/responsive.dart';
import 'package:clwb_crm/screens/dashboard/global_search/global_search_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/app_controller.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔍 TOP SEARCH + ACTIONS ROW
        Row(
          children: [
            Expanded(child: GlobalSearchBox()),

            const SizedBox(width: 16),

            _IconButton(icon: Icons.notifications_none_outlined, showDot: true, onTap: () {  },),
            const SizedBox(width: 12),
            _IconButton(icon: Icons.notifications_active_outlined, onTap: () {  },),
            if (context.isMobile) ...[
              const SizedBox(width: 12),
              _IconButton(
                icon: Icons.menu,
                onTap: () {
                  MobileMoreMenu.open(context);
                },
              ),
            ],

          ],
        ),

      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final bool showDot;
  final VoidCallback onTap;

  const _IconButton({required this.icon, this.showDot = false,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Icon(icon, size: 20, color: Colors.black54),
          ),
          if (showDot)
            Positioned(
              right: 4,
              top: 4,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
