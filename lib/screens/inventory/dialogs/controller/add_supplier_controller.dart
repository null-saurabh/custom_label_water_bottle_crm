import 'package:clwb_crm/screens/inventory/model/inventory_activity_model.dart';
import 'package:clwb_crm/screens/inventory/model/supplier_model.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_activity_repo.dart';
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
  final _activityRepo = InventoryActivityRepository();


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

    final supplierId = await _supplierRepo.addSupplier(supplier);

      await _activityRepo.addActivity(
        InventoryActivityModel(
          id: '',
          itemId: '_system', // 🔥 virtual bucket
          type: 'supplier_created',
          source: 'inventory',
          title: 'Supplier Created',
          description: 'Supplier ${name.value} added',
          stockDelta: 0,
          amount: null,
          unitCost: null,
          referenceId: supplierId,
          referenceType: 'supplier',
          createdBy: 'admin',
          createdAt: now,
          isActive: true,
        ),
      );

      Get.back();
      Get.delete<AddSupplierController>();

      Get.snackbar('Success', 'Supplier added successfully');
    } finally {
      isSaving.value = false;
    }
  }
}
