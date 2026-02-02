import 'package:clwb_crm/screens/client/firebase_repo/client_repo.dart';
import 'package:clwb_crm/screens/client/models/client_location.dart';
import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class EditMapsLinkController extends GetxController {
  final ClientModel client;
  EditMapsLinkController({required this.client});

  final repo = ClientRepository();

  final isSaving = false.obs;

  late final TextEditingController linkCtrl;

  ClientLocation? get primaryLocation {
    if (client.locations.isEmpty) return null;
    return client.locations.firstWhere(
          (l) => l.isPrimary,
      orElse: () => client.locations.first,
    );
  }

  @override
  void onInit() {
    super.onInit();
    linkCtrl = TextEditingController(
      text: primaryLocation?.googleMapsLink ?? '',
    );
  }

  @override
  void onClose() {
    linkCtrl.dispose();
    super.onClose();
  }

  Future<void> submit() async {
    final loc = primaryLocation;
    if (loc == null) {
      Get.snackbar('Error', 'No location found for this client');
      return;
    }

    try {
      isSaving.value = true;

      await repo.updateGoogleMapsLink(
        clientId: client.id,
        locationId: loc.locationId,
        googleMapsLink: linkCtrl.text, // allow ""
      );

      Get.back();
      Get.snackbar('Success', 'Google Maps link updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update Google Maps link');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> useCurrentLocation() async {
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        Get.snackbar('Location', 'Location services are disabled');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Get.snackbar('Location', 'Location permission not granted');
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final url =
          'https://www.google.com/maps/search/?api=1&query=${pos.latitude},${pos.longitude}';

      linkCtrl.text = url;
      linkCtrl.selection = TextSelection.collapsed(offset: url.length);
    } catch (e) {
      Get.snackbar('Location', 'Could not fetch current location');
    }
  }
}
