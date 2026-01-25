import 'package:clwb_crm/screens/inventory/model/supplier_model.dart';
import 'package:clwb_crm/screens/inventory/repositories/supplier_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditSupplierController extends GetxController {
  final SupplierModel supplier;

  EditSupplierController(this.supplier);

  // ===============================
  // TEXT CONTROLLERS
  // ===============================
  late final TextEditingController nameCtrl;
  late final TextEditingController contactPersonCtrl;
  late final TextEditingController phoneCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController addressCtrl;

  final isActive = true.obs;
  final isSaving = false.obs;

  // ===============================
  // REPO
  // ===============================
  final _supplierRepo = SupplierRepository();

  // ===============================
  // INIT
  // ===============================
  @override
  void onInit() {
    super.onInit();

    nameCtrl = TextEditingController(text: supplier.name);
    contactPersonCtrl =
        TextEditingController(text: supplier.contactPerson ?? '');
    phoneCtrl = TextEditingController(text: supplier.phone ?? '');
    emailCtrl = TextEditingController(text: supplier.email ?? '');
    addressCtrl = TextEditingController(text: supplier.address ?? '');

    isActive.value = supplier.isActive;
  }

  // ===============================
  // VALIDATION
  // ===============================
  bool get isValid => nameCtrl.text.trim().isNotEmpty;

  // ===============================
  // SUBMIT
  // ===============================
  Future<void> submit() async {
    if (!isValid) return;

    try {
      isSaving.value = true;

      await _supplierRepo.updateSupplier(
        supplier.id,
        {
          'name': nameCtrl.text.trim(),
          'contactPerson': contactPersonCtrl.text.trim().isEmpty
              ? null
              : contactPersonCtrl.text.trim(),
          'phone': phoneCtrl.text.trim().isEmpty
              ? null
              : phoneCtrl.text.trim(),
          'email': emailCtrl.text.trim().isEmpty
              ? null
              : emailCtrl.text.trim(),
          'address': addressCtrl.text.trim().isEmpty
              ? null
              : addressCtrl.text.trim(),
          'isActive': isActive.value,
          'updatedAt': DateTime.now(),
        },
      );

      Get.back();
      Get.snackbar('Success', 'Supplier updated successfully');
    } finally {
      isSaving.value = false;
    }
  }

  // ===============================
  // CLEANUP
  // ===============================
  @override
  void onClose() {
    nameCtrl.dispose();
    contactPersonCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    super.onClose();
  }
}
