// lib/features/leads/leads_view.dart

import 'package:clwb_crm/screens/leads/widgets/lead_table/lead_table.dart';
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
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: const Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
