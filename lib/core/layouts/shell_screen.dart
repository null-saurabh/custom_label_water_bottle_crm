// lib/core/layouts/shell_view.dart
import 'package:clwb_crm/core/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/app_side_bar.dart';

class ShellView extends StatelessWidget {
  const ShellView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const AppSidebar(),
          Expanded(
            child: GetRouterOutlet(initialRoute: AppRoutes.leads,), // 🔥 THIS IS KEY
          ),
        ],
      ),
    );
  }
}
