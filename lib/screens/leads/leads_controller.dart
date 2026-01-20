// lib/features/leads/leads_controller.dart

import 'package:get/get.dart';

enum LeadStatus { newLead, contacted,followUp, converted }

class Lead {
  final String name;
  final String number;
  final String area;
  final String company;
  LeadStatus status;
  final String interest;
  final String activity;
  String? followUpNote;


  Lead( {
    required this.name,required this.number,
    required this.company,
    required this.status,
    required this.area,
    required this.interest,
    required this.activity,
    this.followUpNote,
  });
}

class LeadsController extends GetxController {

  final selectedFilter = Rxn<LeadStatus>(); // null means "All"

  // final selectedFilter = LeadStatus.newLead.obs;

  final leads = <Lead>[
    Lead(
      name: 'Carlos Mendoza',
      number: '9876543210',
      area: "Patna",
      company: 'The Green Garden',
      status: LeadStatus.newLead,
      interest: '500ml water bottles',
      activity: '30 mins ago',
    ),
    Lead(
      name: 'Jacob Ross',
      number: '9876543210',
      area: "Gaya",

      company: 'Hotel LuxStay',
      status: LeadStatus.contacted,
      interest: 'Private labeling',
      activity: '1h ago',
    ),
    Lead(
      name: 'David Wong',
      number: '9876543210',
      area: "Patna",

      company: 'Café Venezia',
      status: LeadStatus.converted,
      interest: 'Custom labeling',
      activity: '2 days ago',
    ),
  ].obs;

  List<Lead> get filteredLeads =>
      selectedFilter.value == null
          ? leads
          : leads.where((l) => l.status == selectedFilter.value).toList();

  void updateLeadStatus(Lead lead, LeadStatus status) {
    lead.status = status;
    leads.refresh(); // if leads is RxList
  }


  void openFollowUpDialog(Lead lead) {
    // showDialog with TextField and save to lead.followUpNote, then leads.refresh()
  }

  void viewLead(Lead lead) {}
  void editLead(Lead lead) {}
  void deleteLead(Lead lead) {}



}