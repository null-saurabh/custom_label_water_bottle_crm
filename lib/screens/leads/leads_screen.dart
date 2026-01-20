// lib/features/leads/leads_view.dart

import 'package:clwb_crm/screens/leads/widgets/lead_table.dart';
import 'package:clwb_crm/screens/leads/widgets/leads_filter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/layouts/app_shell.dart';
import 'leads_controller.dart';


class LeadsView extends GetView<LeadsController> {
  const LeadsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Leads",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
                const SizedBox(height: 16),
                const LeadFilters(),
                const SizedBox(height: 16),
                LeadTable(),
              ],
            ),
          ),
      ),
    );
  }
}
