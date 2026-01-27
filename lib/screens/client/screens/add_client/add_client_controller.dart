import 'package:clwb_crm/screens/client/firebase_repo/client_activity_repo.dart';
import 'package:clwb_crm/screens/client/firebase_repo/client_repo.dart';
import 'package:clwb_crm/screens/client/models/client_location.dart';
import 'package:clwb_crm/screens/client/models/client_media.dart';
import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddClientController extends GetxController {
  final repo = ClientRepository();

  // Controllers
  final businessCtrl = TextEditingController();
  final gstCtrl = TextEditingController();
  final contactPersonCtrl = TextEditingController();
  final contactPersonRoleCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final areaCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  final businessType = ''.obs;
  final paymentMode = 'UPI'.obs;
  final creditDays = 0.obs;
  final isSubmitting = false.obs;
  final brandTier = 'Standard'.obs;
  final isPriority = false.obs;

  final businessError = RxnString();
  final phoneError = RxnString();

  bool validate() {
    businessError.value = contactPersonCtrl.text.isEmpty
        ? 'Business name required'
        : null;
    phoneError.value = phoneCtrl.text.length < 10
        ? 'Invalid phone number'
        : null;


    return businessError.value == null &&
        phoneError.value == null;
  }

  Future<void> submit() async {

    businessError.value = null;
    phoneError.value = null;


    if (!validate()) return;


    try {
      isSubmitting.value = true;

      final client = ClientModel(
        id: '',
        businessName: businessCtrl.text,
        businessType: businessType.value,
        gstNumber: gstCtrl.text,
        brandTier: brandTier.value,
        contactName: contactPersonCtrl.text,
        contactRole: contactPersonRoleCtrl.text,
        phone: phoneCtrl.text,
        email: emailCtrl.text,
        notes: noteCtrl.text,
        isActive: true,
        isPriority: false,
        paymentMode: paymentMode.value,
        creditDays: creditDays.value,
        outstandingAmount: 0,
        locations: [
          ClientLocation(
            locationId: DateTime.now().millisecondsSinceEpoch.toString(),
            address: addressCtrl.text,
            googleMapsLink: '',
            city: cityCtrl.text,
            area: '',
            isPrimary: true,
          ),
        ],
        products: [],
        media: ClientMedia.empty(),
        createdAt: DateTime.now(),
      );

      final created =
      await repo.createClientWithLabels(client);

      // final clientId = await repo.addClient(client);

      await ClientActivityRepository().logClientCreated(
        clientId: created.id,
        userName: 'Admin', // later: logged-in user
      );

      Get.back();
      Get.snackbar('Success', 'Client created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create client');
      // print(e);
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    businessCtrl.dispose();
    gstCtrl.dispose();
    contactPersonCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    cityCtrl.dispose();
    addressCtrl.dispose();
    super.onClose();
  }
}
