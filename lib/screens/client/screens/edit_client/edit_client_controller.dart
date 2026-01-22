import 'package:clwb_crm/screens/client/firebase_repo/client_activity_repo.dart';
import 'package:clwb_crm/screens/client/firebase_repo/client_repo.dart';
import 'package:clwb_crm/screens/client/models/client_location.dart';
import 'package:clwb_crm/screens/client/models/client_media.dart';
import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditClientController extends GetxController {
  EditClientController(this.client);

  final ClientModel client;
  final repo = ClientRepository();
  final activityRepo = ClientActivityRepository();

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


  @override
  void onInit() {
      _prefill(client);
    super.onInit();
  }


  void _prefill(ClientModel c) {
    businessCtrl.text = c.businessName;
    gstCtrl.text = c.gstNumber;
    contactPersonCtrl.text = c.contactName;
    contactPersonRoleCtrl.text = c.contactRole;
    phoneCtrl.text = c.phone;
    emailCtrl.text = c.email;

    businessType.value = c.businessType;
    // brandTier.value = c.brandTier;
    // paymentMode.value = c.paymentMode;
    // creditDays.value = c.creditDays;
    // isPriority.value = c.isPriority;

    if (c.locations.isNotEmpty) {
      addressCtrl.text = c.locations.first.address;
      cityCtrl.text = c.locations.first.city;
      areaCtrl.text = c.locations.first.area;
    }
  }


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

        // final client = ClientModel(
        //   id: '',
        //   businessName: businessCtrl.text,
        //   businessType: businessType.value,
        //   gstNumber: gstCtrl.text,
        //   brandTier: brandTier.value,
        //   contactName: contactPersonCtrl.text,
        //   contactRole: contactPersonRoleCtrl.text,
        //   phone: phoneCtrl.text,
        //   email: emailCtrl.text,
        //   notes: noteCtrl.text,
        //   isActive: true,
        //   isPriority: false,
        //   paymentMode: paymentMode.value,
        //   creditDays: creditDays.value,
        //   outstandingAmount: 0,
        //   locations: [
        //     ClientLocation(
        //       locationId: DateTime.now().millisecondsSinceEpoch.toString(),
        //       address: addressCtrl.text,
        //       googleMapsLink: '',
        //       city: cityCtrl.text,
        //       area: '',
        //       isPrimary: true,
        //     ),
        //   ],
        //   products: [],
        //   media: ClientMedia.empty(),
        //   createdAt: DateTime.now(),
        // );


        final updatedData = {
          'businessName': businessCtrl.text.trim(),
          'businessType': businessType.value,
          'gstNumber': gstCtrl.text.trim(),
          'brandTier': brandTier.value,
          'contactName': contactPersonCtrl.text.trim(),
          'contactRole': contactPersonRoleCtrl.text.trim(),
          'phone': phoneCtrl.text.trim(),
          'email': emailCtrl.text.trim(),
          'paymentMode': paymentMode.value,
          'creditDays': creditDays.value,
          'isPriority': isPriority.value,
          'locations': [
            {
              'locationId': DateTime
                  .now()
                  .millisecondsSinceEpoch
                  .toString(),
              'address': addressCtrl.text.trim(),
              'googleMapsLink': '',
              'city': cityCtrl.text.trim(),
              'area': areaCtrl.text.trim(),
              'isPrimary': true,
            }
          ],
        };

        await repo.updateClient(clientId: client.id, data: updatedData);
        // final clientId = await repo.addClient(client);

        // await ClientActivityRepository().logClientCreated(
        //   clientId: clientId,
        //   userName: 'Admin', // later: logged-in user
        // );


        await activityRepo.addActivity(
            clientId: client.id,
            activity: ClientActivity(
              id: DateTime
                  .now()
                  .millisecondsSinceEpoch
                  .toString(),
              type: ClientActivityType.other,
              title: 'Client updated',
              note: 'Client details updated',
              userName: 'Admin',
              at: DateTime.now(),
            ));

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
