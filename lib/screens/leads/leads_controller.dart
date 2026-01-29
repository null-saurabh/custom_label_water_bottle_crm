// lib/features/leads/leads_controller.dart

import 'package:clwb_crm/screens/leads/add_lead_model.dart';
import 'package:clwb_crm/screens/leads/firebase/lead_activity_repo.dart';
import 'package:clwb_crm/screens/leads/firebase/lead_repo.dart';
import 'package:clwb_crm/screens/leads/widgets/edit_lead/edit_lead.dart';
import 'package:clwb_crm/screens/leads/widgets/edit_lead/edit_lead_controller.dart';
import 'package:clwb_crm/screens/leads/widgets/lead_activity/widgets/lead_activity_dialog.dart';
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


  int get newLeadsCount {
    return leads.where((l) => l.status == LeadStatus.newLead).length;
  }


  String lastActivityLabel(LeadModel lead) {
    if (lead.lastActivityAt == null) return 'No activity';
    final diff = DateTime.now().difference(lead.lastActivityAt ?? DateTime.now());
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }


  final leadSearchQuery = ''.obs;

  final selectedFilter = Rxn<LeadStatus>(LeadStatus.newLead); // null means "All"

  List<LeadModel> get filteredLeads {
    Iterable<LeadModel> result = leads;

    /// 1️⃣ Status filter
    final status = selectedFilter.value;
    if (status != null) {
      result = result.where((l) => l.status == status);
    }

    /// 2️⃣ Search filter (multi-field)
    final query = leadSearchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result.where((l) {
        bool contains(String? value) =>
            value != null && value.toLowerCase().contains(query);

        return contains(l.businessName) ||
            contains(l.contactName) ||
            contains(l.phone) ||
            contains(l.email) ||
            contains(l.area);
      });
    }

    return result.toList();
  }



  // ===== SEARCH =====




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


  void viewLead(LeadModel lead) {
    Get.dialog(
      LeadActivityDialog(lead: lead),
      barrierDismissible: true,
    );
  }


  void editLead(LeadModel lead) {
    if (Get.isRegistered<EditLeadController>()) {
      Get.delete<EditLeadController>();
    }

    Get.put(EditLeadController(lead), permanent: false);

    Get.dialog(const EditLeadDialog());
  }



  final isSavingFollowUp = false.obs;

  Future<void> saveFollowUpNote({
    required String leadId,
    required String note,
  })
  async {
    if (isSavingFollowUp.value) return;

    try {
      isSavingFollowUp.value = true;

      await repo.updateFollowUpNote(leadId: leadId, note: note);

      // add activity
      final activity = LeadActivity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: LeadActivityType.followUp,
        title: 'Follow up note',
        note: note.isEmpty ? '(cleared)' : note,
        at: DateTime.now(),
      );

      await activityRepo.addActivity(leadId, activity);
      if (Get.isDialogOpen == true) Get.back(); // ✅ close dialog

      Get.snackbar('Saved', 'Follow up updated', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save follow up', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSavingFollowUp.value = false;
    }
  }


  Future<void> changeStatus(LeadModel lead, LeadStatus status) async {
    await repo.updateLeadStatus(leadId: lead.id, status: status);
    await activityRepo.logStatusChange(leadId: lead.id, status: status);
  }
  Future<void> addFollowUp(LeadModel lead, String note) async {
    await repo.updateFollowUpNote(leadId: lead.id, note: note);
    await activityRepo.logFollowUp(leadId: lead.id, note: note);
  }


  final isDeleting = false.obs;

  // Future<void> deleteLead(String leadId) async {
  //   await repo.deleteLead(leadId);
  // }


  Future<void> deleteLead(String leadId) async {
    if (isDeleting.value) return;
    try {
      isDeleting.value = true;
      await repo.deleteLead(leadId);

      if (Get.isDialogOpen == true) Get.back(); // ✅ close dialog
      Get.snackbar('Deleted', 'Lead removed', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete lead', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isDeleting.value = false;
    }
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