import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clwb_crm/screens/leads/add_lead_model.dart';
import 'package:clwb_crm/screens/leads/firebase/lead_repo.dart';
import 'package:clwb_crm/screens/leads/firebase/lead_activity_repo.dart';

class AddLeadController extends GetxController {
  final repo = LeadRepository();
  final activityRepo = LeadActivityRepository();

  // TODO: connect to your auth/user system
  String get userId => 'demo-user';
  String get userName => 'Sales';

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


  @override
  void onInit() {
    super.onInit();
    ever<List<String>>(bottleSizes, (_) {
      if (bottleSizes.isNotEmpty) bottleError.value = null;
    });
  }


  bool validate() {
    businessError.value =
    contactCtrl.text.trim().isEmpty ? 'Contact person required' : null;

    phoneError.value =
    phoneCtrl.text.trim().length < 10 ? 'Invalid phone number' : null;

    typeError.value = selectedBusinessType.value.trim().isEmpty
        ? 'Select business type'
        : null;

    qtyError.value =
    monthlyQuantity.value.trim().isEmpty ? 'Enter monthly quantity' : null;

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

      // Convert old fields -> new interests list
      final interests = bottleSizes
          .map((s) => ProductInterest.empty(bottleSize: s))
          .toList();

      final lead = LeadModel(
        id: '',
        businessName: businessCtrl.text.trim(),
        businessType: selectedBusinessType.value.trim(),

        primaryContactName: contactCtrl.text.trim(),
        primaryPhone: phoneCtrl.text.trim(),
        primaryWhatsApp: phoneCtrl.text.trim(),
        primaryEmail: emailCtrl.text.trim(),

        contacts: [
          LeadContact(
            name: contactCtrl.text.trim(),
            role: 'owner',
            phone: phoneCtrl.text.trim(),
            whatsapp: phoneCtrl.text.trim(),
            email: emailCtrl.text.trim(),
            isPrimary: true,
          ),
        ],

        stage: LeadStage.newInquiry,
        temperature: LeadTemperature.warm,

        nextFollowUpAt: null,
        nextFollowUpNote: '',

        createdAt: DateTime.now(),
        updatedAt: null,
        lastActivityAt: DateTime.now(),
        lastContactedAt: null,

        assignedToUserId: userId,
        assignedToUserName: userName,

        source: LeadSource.other,
        sourceDetail: '',

        interests: interests,
        expectedMonthlyVolume: monthlyQuantity.value,
        priceSensitivity: 'Not sure',

        city: cityCtrl.text.trim(),
        state: stateCtrl.text.trim(),
        area: areaCtrl.text.trim(),

        notes: notesCtrl.text.trim(),
        tags: const [],

        convertedClientId: null,
        convertedAt: null,
      );

      final leadId = await repo.addLead(lead);

      await activityRepo.addActivity(
        leadId,
        LeadActivity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: LeadActivityType.created,
          title: 'Lead created',
          note: 'Lead added from CRM',
          userId: userId,
          userName: userName,
          at: DateTime.now(),
          meta: {},
        ),
      );

      Get.back();
    } catch (_) {
      Get.snackbar('Error', 'Failed to add lead', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting.value = false;
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
