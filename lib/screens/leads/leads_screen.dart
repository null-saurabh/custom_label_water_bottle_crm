// lib/features/leads/leads_view.dart

import 'package:clwb_crm/core/utils/responsive.dart';
import 'package:clwb_crm/screens/leads/widgets/add_lead_dialog/add_lead_controller.dart';
import 'package:clwb_crm/screens/leads/widgets/add_lead_dialog/add_lead_dialog.dart';
import 'package:clwb_crm/screens/leads/widgets/lead_filter_mobile.dart';
import 'package:clwb_crm/screens/leads/widgets/lead_table/lead_table.dart';
import 'package:clwb_crm/screens/leads/widgets/lead_table/lead_table_mobile.dart';
import 'package:clwb_crm/screens/leads/widgets/leads_filter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'leads_controller.dart';

class LeadsView extends GetView<LeadsController> {
  const LeadsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: context.isMobile? 0 :24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: TextField(
                  controller: controller.searchCtrl,
                  onChanged: controller.leadSearchQuery.call,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Text(
                "Leads",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              context.isMobile ? LeadFiltersMobile() : LeadFilters(),
              const SizedBox(height: 16),
              !context.isMobile
                  ? SizedBox(width: double.infinity, child: LeadTable())
                  : LeadListMobile(),
            ],
          ),
        ),
      ),
      floatingActionButton: context.isMobile
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF3558C9),
              shape: const CircleBorder(),
              tooltip: 'Add Lead',
              onPressed: () {
                if (Get.isRegistered<AddLeadController>()) {
                  Get.delete<AddLeadController>();
                }
                Get.put(AddLeadController(), permanent: false);

                Get.dialog(const AddLeadDialog(), barrierDismissible: true);
              },
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
