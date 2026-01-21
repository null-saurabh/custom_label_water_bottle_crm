// lib/features/leads/leads_controller.dart

import 'package:clwb_crm/screens/leads/add_lead_model.dart';
import 'package:clwb_crm/screens/leads/firebase/lead_activity_repo.dart';
import 'package:clwb_crm/screens/leads/firebase/lead_repo.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';





class LeadsController extends GetxController {


  final repo = LeadRepository();
  final activityRepo = LeadActivityRepository();

  final leads = <LeadModel>[].obs;

  @override
  void onInit() {
    // print("a");
    repo.watchLeads().listen(leads.assignAll);
    // print("aaa");
    super.onInit();
  }

  String lastActivityLabel(LeadModel lead) {
    if (lead.lastActivityAt == null) return 'No activity';
    final diff = DateTime.now().difference(lead.lastActivityAt ?? DateTime.now());
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }



  final selectedFilter = Rxn<LeadStatus>(LeadStatus.newLead); // null means "All"

  List<LeadModel> get filteredLeads =>
      selectedFilter.value == null
          ? leads
          : leads.where((l) => l.status == selectedFilter.value).toList();



  void updateLeadStatus(LeadModel lead, LeadStatus newStatus) {
    final updatedLead = lead.copyWith(
      status: newStatus,
      lastActivityAt: DateTime.now(),
      activities: [
        ...lead.activities,
        LeadActivity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: LeadActivityType.statusChanged,
          title: 'Status changed',
          note: 'Status changed to ${newStatus.name}',
          at: DateTime.now(),
        ),
      ],
    );

    final index = leads.indexWhere((l) => l.id == lead.id);
    if (index != -1) {
      leads[index] = updatedLead;
    }
  }



  void openFollowUpDialog(LeadModel lead) {
    // showDialog with TextField and save to lead.followUpNote, then leads.refresh()
  }

  void viewLead(LeadModel lead) {}
  void editLead(LeadModel lead) {}


  Future<void> changeStatus(LeadModel lead, LeadStatus status) async {
    await repo.updateLeadStatus(leadId: lead.id, status: status);
    await activityRepo.logStatusChange(leadId: lead.id, status: status);
  }
  Future<void> addFollowUp(LeadModel lead, String note) async {
    await repo.updateFollowUpNote(leadId: lead.id, note: note);
    await activityRepo.logFollowUp(leadId: lead.id, note: note);
  }
  Future<void> deleteLead(String leadId) async {
    await repo.deleteLead(leadId);
  }


  // in LeadsController

  void onCallPressed(LeadModel lead) {
    final phone = lead.phone.trim();
    if (phone.isEmpty) return;

    // log activity (fire-and-forget)
    activityRepo.addActivity(
      lead.id,
      LeadActivity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: LeadActivityType.call,
        title: 'Call Initiated',
        note: 'Call initiated to $phone',
        at: DateTime.now(),
      ),
    );

    // open dialer (web + mobile safe)
    final uri = Uri.parse('tel:$phone');
    launchUrl(uri);
  }





}