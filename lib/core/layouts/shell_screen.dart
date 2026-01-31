// lib/core/layouts/shell_view.dart
import 'package:clwb_crm/core/layouts/shell_desktop_body.dart';
import 'package:clwb_crm/core/layouts/shell_mobile_body.dart';
import 'package:clwb_crm/core/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_side_bar.dart';

class ShellView extends StatelessWidget {
  const ShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (!isMobile) {
      // 🔒 DESKTOP (UNCHANGED)
      return Row(
          children:  [
            AppSidebar(),
            Expanded(
              child: GetRouterOutlet(
                initialRoute: AppRoutes.dashboard,
              ),
            ),
          ],
      );
    }

    // 📱 MOBILE SHELL
    return const ShellMobileScaffold();
      // bottomNavigationBar: isMobile ? const MobileBottomNav() : null
  }
}

