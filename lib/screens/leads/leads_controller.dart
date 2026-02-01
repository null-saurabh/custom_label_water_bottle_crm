import 'package:clwb_crm/screens/leads/widgets/edit_lead/edit_lead.dart';
import 'package:clwb_crm/screens/leads/widgets/edit_lead/edit_lead_controller.dart';
import 'package:clwb_crm/screens/leads/widgets/lead_activity/widgets/lead_activity_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:clwb_crm/screens/leads/add_lead_model.dart';
import 'package:clwb_crm/screens/leads/firebase/lead_repo.dart';
import 'package:clwb_crm/screens/leads/firebase/lead_activity_repo.dart';

class LeadsController extends GetxController {
  final repo = LeadRepository();
  final activityRepo = LeadActivityRepository();

  final leads = <LeadModel>[].obs;

  // TODO: connect to your auth/user system
  String get userId => 'demo-user';
  String get userName => 'Sales';

  @override
  void onInit() {
    repo.watchLeads().listen(leads.assignAll);
    super.onInit();
  }

  // Pipeline filter
  final leadSearchQuery = ''.obs;
  final searchCtrl = TextEditingController();

  void setSearch(String v) {
    leadSearchQuery.value = v;

    if (searchCtrl.text != v) {
      searchCtrl.value = searchCtrl.value.copyWith(
        text: v,
        selection: TextSelection.collapsed(offset: v.length),
        composing: TextRange.empty,
      );
    }
  }

  final selectedStage = Rxn<LeadStage>(LeadStage.newInquiry); // null = All

  // Quick views (optional)
  final showOnlyOverdue = false.obs;
  final showOnlyDueToday = false.obs;

  int get newLeadsCount =>
      leads.where((l) => l.stage == LeadStage.newInquiry).length;

  String lastActivityLabel(LeadModel lead) {
    if (lead.lastActivityAt == null) return 'No activity';
    final diff = DateTime.now().difference(lead.lastActivityAt!);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }

  bool _isDueToday(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  List<LeadModel> get filteredLeads {
    Iterable<LeadModel> result = leads;

    // 1) stage filter
    final st = selectedStage.value;
    if (st != null) {
      result = result.where((l) => l.stage == st);
    }

    // 2) overdue/today
    if (showOnlyOverdue.value) {
      result = result.where((l) =>
      l.nextFollowUpAt != null && l.nextFollowUpAt!.isBefore(DateTime.now()));
    } else if (showOnlyDueToday.value) {
      result = result.where((l) => l.nextFollowUpAt != null && _isDueToday(l.nextFollowUpAt!));
    }

    // 3) search
    final q = leadSearchQuery.value.trim().toLowerCase();
    if (q.isNotEmpty) {
      bool contains(String? v) => v != null && v.toLowerCase().contains(q);

      result = result.where((l) {
        return contains(l.businessName) ||
            contains(l.primaryContactName) ||
            contains(l.primaryPhone) ||
            contains(l.primaryEmail) ||
            contains(l.primaryWhatsApp) ||
            contains(l.area) ||
            contains(l.city) ||
            contains(l.state);
      });
    }

    return result.toList();
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

  Future<void> saveFollowUp({
    required LeadModel lead,
    required DateTime? nextAt,
    required String note,
  }) async
  {
    if (isSavingFollowUp.value) return;

    try {
      isSavingFollowUp.value = true;

      await repo.updateNextFollowUp(
        leadId: lead.id,
        nextAt: nextAt,
        note: note,
      );

      await activityRepo.logFollowUpScheduled(
        leadId: lead.id,
        nextAt: nextAt,
        note: note,
        userId: userId,
        userName: userName,
      );

      if (Get.isDialogOpen == true) Get.back();
      Get.snackbar('Saved', 'Follow-up updated', snackPosition: SnackPosition.BOTTOM);
    } catch (_) {
      Get.snackbar('Error', 'Failed to save follow-up', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSavingFollowUp.value = false;
    }
  }

  Future<void> changeStage(LeadModel lead, LeadStage stage) async {
    if (lead.isConverted) return;

    await repo.updateStage(leadId: lead.id, stage: stage);
    await activityRepo.logStatusChange(
      leadId: lead.id,
      stage: stage,
      userId: userId,
      userName: userName,
    );
  }

  final isDeleting = false.obs;

  Future<void> deleteLead(String leadId) async {
    if (isDeleting.value) return;
    try {
      isDeleting.value = true;
      await repo.deleteLead(leadId);
      if (Get.isDialogOpen == true) Get.back();
      Get.snackbar('Deleted', 'Lead removed', snackPosition: SnackPosition.BOTTOM);
    } catch (_) {
      Get.snackbar('Error', 'Failed to delete lead', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isDeleting.value = false;
    }
  }

  void onCallPressed(LeadModel lead) {
    final phone = lead.primaryPhone.trim();
    if (phone.isEmpty || lead.isConverted) return;

    // activity + mark last contacted
    activityRepo.logCallMade(
      leadId: lead.id,
      phone: phone,
      userId: userId,
      userName: userName,
    );
    repo.markContactedNow(leadId: lead.id);

    // dialer
    launchUrl(Uri.parse('tel:$phone'));
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    super.onClose();
  }

}
