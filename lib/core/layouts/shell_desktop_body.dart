import 'package:clwb_crm/core/layouts/app_side_bar.dart';
import 'package:clwb_crm/core/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShellDesktopBody extends StatelessWidget {
  const ShellDesktopBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const AppSidebar(), // 🔒 EXACT SAME SIDEBAR
          Expanded(child: GetRouterOutlet(initialRoute: AppRoutes.dashboard)),
        ],
      ),
    );
  }
}
