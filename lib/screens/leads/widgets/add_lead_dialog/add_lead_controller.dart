import 'package:clwb_crm/screens/leads/add_lead_model.dart';
import 'package:clwb_crm/screens/leads/firebase/lead_activity_repo.dart';
import 'package:clwb_crm/screens/leads/firebase/lead_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddLeadController extends GetxController {
  final repo = LeadRepository();

  // Controllers
  final businessCtrl = TextEditingController();
  final contactCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final areaCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

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

  // final bottleSizes = <String>[].obs;

  // final LeadModel formData;


  bool validate() {
    businessError.value = contactCtrl.text.isEmpty
        ? 'Business name required'
        : null;
    phoneError.value = phoneCtrl.text.length < 10
        ? 'Invalid phone number'
        : null;
    typeError.value = selectedBusinessType.isEmpty
        ? 'Select business type'
        : null;
    qtyError.value = monthlyQuantity.isEmpty ? 'Enter monthly quantity' : null;
    bottleError.value = bottleSizes.isEmpty
        ? 'Select bottle size'
        : null;

    return businessError.value == null &&
        phoneError.value == null &&
        typeError.value == null &&
        qtyError.value == null &&
        bottleError.value == null;
  }

  Future<void> submit() async {
    print("A");

    businessError.value = null;
        phoneError.value = null;
        typeError.value = null;
        qtyError.value = null;
        bottleError.value = null;

    if (!validate()) return;
    print("Aa");
    try {
    isSubmitting.value = true;


    final activity = LeadActivity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: LeadActivityType.created,
      title: 'Lead Created',
      note: 'Lead added from CRM',
      at: DateTime.now(),
    );
    print("submit 1");

    final lead = LeadModel(
      id: '',
      businessName: businessCtrl.text,
      contactName: contactCtrl.text,
      phone: phoneCtrl.text,
      email: emailCtrl.text,
      businessType: selectedBusinessType.value,
      monthlyQuantity: monthlyQuantity.value,
      bottleSizes: bottleSizes.toList(),
      city: cityCtrl.text,
      state: stateCtrl.text,
      deliveryLocation: "",
      notes: notesCtrl.text,
      status: LeadStatus.newLead,
      createdAt: DateTime.now(),
      bottleDesign: '',
      area: areaCtrl.text,
      followUpNotes: '',
      lastActivityAt:  DateTime.now(),
      activities: [
        LeadActivity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: LeadActivityType.created,
          title: 'Lead Created',
          note: 'Lead added from CRM',
          at: DateTime.now(),
        ),
      ],
    );
    print("submit 2");

    final leadId = await repo.addLead(lead);
    print("submit 3");

    await LeadActivityRepository().addActivity(leadId, activity);
    print("submit 4");

    print("Aa");


    print("Aa");

    Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add lead',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false; // 🔥 ALWAYS

    }
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
