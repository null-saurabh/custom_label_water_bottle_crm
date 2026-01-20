// lib/features/leads/leads_controller.dart

import 'package:get/get.dart';

enum LeadStatus { newLead, contacted, converted }

class Lead {
  final String name;
  final String company;
  final LeadStatus status;
  final String interest;
  final String activity;

  Lead({
    required this.name,
    required this.company,
    required this.status,
    required this.interest,
    required this.activity,
  });
}

class LeadsController extends GetxController {

  final selectedFilter = Rxn<LeadStatus>(); // null means "All"

  // final selectedFilter = LeadStatus.newLead.obs;

  final leads = <Lead>[
    Lead(
      name: 'Carlos Mendoza',
      company: 'The Green Garden',
      status: LeadStatus.newLead,
      interest: '500ml water bottles',
      activity: '30 mins ago',
    ),
    Lead(
      name: 'Jacob Ross',
      company: 'Hotel LuxStay',
      status: LeadStatus.contacted,
      interest: 'Private labeling',
      activity: '1h ago',
    ),
    Lead(
      name: 'David Wong',
      company: 'Café Venezia',
      status: LeadStatus.converted,
      interest: 'Custom labeling',
      activity: '2 days ago',
    ),
  ].obs;

  List<Lead> get filteredLeads {
    return leads
        .where((l) => l.status == selectedFilter.value)
        .toList();
  }
}
