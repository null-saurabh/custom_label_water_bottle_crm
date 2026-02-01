// lib/core/layouts/shell_view.dart
import 'package:clwb_crm/core/layouts/shell_desktop_body.dart';
import 'package:clwb_crm/core/layouts/shell_mobile_body.dart';
import 'package:clwb_crm/core/utils/responsive.dart';
import 'package:flutter/material.dart';

class ShellView extends StatelessWidget {
  const ShellView({super.key});

  @override
  Widget build(BuildContext context) {

    if (context.isDesktop) {
      // 🔒 DESKTOP (UNCHANGED)
      return ShellDesktopBody();
    }

    // 📱 MOBILE SHELL
    return const ShellMobileScaffold();
      // bottomNavigationBar: isMobile ? const MobileBottomNav() : null
  }
}

