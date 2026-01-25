import 'package:clwb_crm/screens/inventory/model/supplier_model.dart';
import 'package:clwb_crm/screens/inventory/repositories/supplier_repo.dart';
import 'package:get/get.dart';

class AddSupplierController extends GetxController {
  // ===============================
  // FORM FIELDS
  // ===============================
  final name = ''.obs;
  final contactPerson = ''.obs;
  final phone = ''.obs;
  final email = ''.obs;
  final address = ''.obs;

  final isActive = true.obs;
  final isSaving = false.obs;

  // ===============================
  // VALIDATION
  // ===============================
  bool get isValid {
    return name.isNotEmpty;
  }

  // ===============================
  // REPO
  // ===============================
  final _supplierRepo = SupplierRepository();

  // ===============================
  // SUBMIT
  // ===============================
  Future<void> submit() async {
    if (!isValid) return;

    try {
      isSaving.value = true;
      final now = DateTime.now();

      final supplier = SupplierModel(
        id: '',
        name: name.value,
        contactPerson:
        contactPerson.isNotEmpty ? contactPerson.value : null,
        phone: phone.isNotEmpty ? phone.value : null,
        email: email.isNotEmpty ? email.value : null,
        address: address.isNotEmpty ? address.value : null,
        isActive: isActive.value,
        createdAt: now,
        updatedAt: now,
      );

      await _supplierRepo.addSupplier(supplier);

      Get.back();
      Get.delete<AddSupplierController>();

      Get.snackbar('Success', 'Supplier added successfully');
    } finally {
      isSaving.value = false;
    }
  }
}
