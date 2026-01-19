// dashboard/dashboard_screen.dart
import 'package:clwb_crm/screens/dashboard/widgets/dashboard_header.dart';
import 'package:clwb_crm/screens/dashboard/widgets/dashboard_kpi_row.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            DashboardHeader(),
            SizedBox(height: 24),
            DashboardKpiRow(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
