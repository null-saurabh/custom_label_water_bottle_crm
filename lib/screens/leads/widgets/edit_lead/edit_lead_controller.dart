
import 'package:clwb_crm/screens/leads/add_lead_model.dart';
import 'package:clwb_crm/screens/leads/firebase/lead_activity_repo.dart';
import 'package:clwb_crm/screens/leads/firebase/lead_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditLeadController extends GetxController {
  EditLeadController(this.lead);

  final LeadModel lead;
  final repo = LeadRepository();
  final activityRepo = LeadActivityRepository();

  // Controllers
  late final businessCtrl = TextEditingController(text: lead.businessName);
  late final contactCtrl = TextEditingController(text: lead.primaryContactName);
  late final phoneCtrl = TextEditingController(text: lead.primaryContactName);
  late final emailCtrl = TextEditingController(text: lead.primaryEmail);
  late final cityCtrl = TextEditingController(text: lead.city);
  late final stateCtrl = TextEditingController(text: lead.state);
  late final areaCtrl = TextEditingController(text: lead.area);
  late final notesCtrl = TextEditingController(text: lead.notes);

  // State
  final selectedBusinessType = ''.obs;
  final monthlyQuantity = ''.obs;
  final bottleSizes = <String>[].obs;

  final isSubmitting = false.obs;

  // Errors
  final businessError = RxnString();
  final phoneError = RxnString();
  final typeError = RxnString();
  final qtyError = RxnString();
  final bottleError = RxnString();

  @override
  void onInit() {
    super.onInit();
    selectedBusinessType.value = lead.businessType;
    // monthlyQuantity.value = lead.monthlyQuantity;
    // bottleSizes.assignAll(lead.bottleSizes);
  }

  bool validate() {
    businessError.value = contactCtrl.text.isEmpty ? 'Business name required' : null;
    phoneError.value = phoneCtrl.text.length < 10 ? 'Invalid phone number' : null;
    typeError.value = selectedBusinessType.isEmpty ? 'Select business type' : null;
    qtyError.value = monthlyQuantity.isEmpty ? 'Enter monthly quantity' : null;
    bottleError.value = bottleSizes.isEmpty ? 'Select bottle size' : null;

    return businessError.value == null &&
        phoneError.value == null &&
        typeError.value == null &&
        qtyError.value == null &&
        bottleError.value == null;
  }

  Future<void> submit() async {
    businessError.value = null;
    phoneError.value = null;
    typeError.value = null;
    qtyError.value = null;
    bottleError.value = null;

    if (!validate()) return;

    try {
      isSubmitting.value = true;

      final updatedData = <String, dynamic>{
        'businessName': businessCtrl.text.trim(),
        'contactName': contactCtrl.text.trim(),
        'phone': phoneCtrl.text.trim(),
        'email': emailCtrl.text.trim(),
        'businessType': selectedBusinessType.value,
        'monthlyQuantity': monthlyQuantity.value,
        'bottleSizes': bottleSizes.toList(),
        'city': cityCtrl.text.trim(),
        'state': stateCtrl.text.trim(),
        'area': areaCtrl.text.trim(),
        'notes': notesCtrl.text.trim(),
        // keep status as-is unless you edit separately
        // 'status': lead.status.name,
      };

      await repo.updateLead(leadId: lead.id, data: updatedData);

      // Activity entry
      // final activity = LeadActivity(
      //   id: DateTime.now().millisecondsSinceEpoch.toString(),
      //   type: LeadActivityType.note,
      //   title: 'Lead Updated',
      //   note: _buildUpdateNote(lead),
      //   at: DateTime.now(),
      // );

      // await activityRepo.addActivity(lead.id, activity);

      if (isClosed) return;
      Get.back();
      Get.snackbar('Success', 'Lead updated', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      if (isClosed) return;
      Get.snackbar('Error', 'Failed to update lead', snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (!isClosed) isSubmitting.value = false;
    }
  }


  String _buildUpdateNote(LeadModel oldLead) {
    final changes = <String>[];

    void check(String label, String oldVal, String newVal) {
      if (oldVal.trim() != newVal.trim()) {
        changes.add('$label: "$oldVal" → "$newVal"');
      }
    }

    check('Business name', oldLead.businessName, businessCtrl.text);
    // check('Contact name', oldLead.contactName, contactCtrl.text);
    // check('Phone', oldLead.phone, phoneCtrl.text);
    // check('Email', oldLead.email, emailCtrl.text);
    // check('Business type', oldLead.businessType, selectedBusinessType.value);
    // check('Monthly qty', oldLead.monthlyQuantity, monthlyQuantity.value);
    check('City', oldLead.city, cityCtrl.text);
    check('State', oldLead.state, stateCtrl.text);
    check('Area', oldLead.area, areaCtrl.text);

    // bottle sizes (list compare)
    // final oldSizes = oldLead.bottleSizes.join(', ');
    final newSizes = bottleSizes.join(', ');
    // if (oldSizes != newSizes) {
    //   changes.add('Bottle sizes: "$oldSizes" → "$newSizes"');
    // }
    //
    // if (changes.isEmpty) return 'Lead updated (no visible changes)';
    //
    return changes.join('\n');
  }


  @override
  void onClose() {
    businessCtrl.dispose();
    contactCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    cityCtrl.dispose();
    stateCtrl.dispose();
    areaCtrl.dispose();
    notesCtrl.dispose();
    super.onClose();
  }
}
