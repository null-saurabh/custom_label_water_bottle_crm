import 'package:clwb_crm/core/utils/responsive.dart';
import 'package:clwb_crm/screens/dashboard/dashboard_mobile_screen.dart';
import 'package:clwb_crm/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

class DashboardShellScreen extends StatelessWidget {
  const DashboardShellScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: context.isDesktop ?  const DashboardScreen() : const DashboardMobileView(),
    );
  }
}
