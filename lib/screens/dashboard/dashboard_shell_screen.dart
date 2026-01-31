import 'package:clwb_crm/screens/dashboard/dashboard_mobile_screen.dart';
import 'package:clwb_crm/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

class DashboardShellScreen extends StatelessWidget {
  const DashboardShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: isMobile ? const DashboardMobileView() : const DashboardScreen(),
    );
  }
}
