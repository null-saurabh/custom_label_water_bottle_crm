import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:clwb_crm/screens/inventory/model/bottle_config.dart';
import 'package:clwb_crm/screens/inventory/model/cap_config.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_item_model.dart';
import 'package:clwb_crm/screens/inventory/model/label_config.dart';
import 'package:clwb_crm/screens/inventory/repositories/bottle_config_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/cap_config_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_activity_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_item_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/level_config_repo.dart';
import 'package:get/get.dart';

class AddInventoryItemController extends GetxController {
  final List<ClientModel> clients;
  AddInventoryItemController({
    required this.clients,
  });


  // ===============================
  // BASIC ITEM
  // ===============================
  final name = ''.obs;
  final category = Rxn<InventoryCategory>(); // Bottle / Cap / Label / Packaging
  final reorderLevel = 0.obs;
  final isSaving = false.obs;

  // ===============================
  // BOTTLE CONFIG
  // ===============================
  final bottleSize = ''.obs;   // 200 / 500 / 1000
  final bottleShape = ''.obs;  // Round / Square / Custom
  final neckType = ''.obs;     // 28mm / 30mm



  // ===============================
  // CAP CONFIG
  // ===============================
  final capSize = ''.obs;      // 28mm / 30mm
  final capColor = ''.obs;     // White / Blue / Black
  final capMaterial = ''.obs;  // Plastic / Bio / Metal

  // ===============================
  // LABEL CONFIG
  // ===============================
  final labelWidth = ''.obs;   // mm
  final labelHeight = ''.obs;  // mm
  final labelMaterial = ''.obs; // Paper / Plastic

  final isClientSpecific = false.obs;
  final selectedClientId = RxnString();

  // ===============================
  // HELPERS
  // ===============================
  bool get isBottle => category.value == InventoryCategory.bottle;
  bool get isCap => category.value == InventoryCategory.cap;
  bool get isLabel => category.value == InventoryCategory.label;
  bool get isPackaging => category.value == InventoryCategory.packaging;


  // ===============================
  // VALIDATION (MINIMUM REQUIRED)
  // ===============================
  bool get isValid {
    if (name.isEmpty || category.value == null) return false;

    if (isBottle) {
      return bottleSize.isNotEmpty &&
          bottleShape.isNotEmpty &&
          neckType.isNotEmpty;
    }

    if (isCap) {
      return capSize.isNotEmpty &&
          capColor.isNotEmpty &&
          capMaterial.isNotEmpty;
    }

    if (isLabel) {
      if (labelWidth.isEmpty ||
          labelHeight.isEmpty ||
          labelMaterial.isEmpty) return false;

      if (isClientSpecific.value && selectedClientId.value == null) {
        return false;
      }
    }

    return true;
  }

  // ===============================
  // REPOSITORIES
  // ===============================
  final _itemRepo = InventoryItemRepository();
  final _bottleRepo = BottleConfigRepository();
  final _capRepo = CapConfigRepository();
  final _labelRepo = LabelConfigRepository();
  final _activityRepo = InventoryActivityRepository();

  // ===============================
  // SUBMIT (ALIGNED WITH MODELS)
  // ===============================
  Future<void> submit() async {

    // print("in submit");
    if (!isValid) return;
    // print("in submit2");

    try {
      // print("in submit3");

      isSaving.value = true;
      final now = DateTime.now();
      // print("in submit3a ");
      // 1️⃣ Inventory Item
      final item = InventoryItemModel(
        id: '',
        name: name.value,
        description: null,
        // category: InventoryCategory.values
        //     .firstWhere((e) => e.name == category.value),
        category: category.value!,
        stock: 0,
        reorderLevel: reorderLevel.value,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );
      print("in submit4");


      final itemId = await _itemRepo.addItem(item);

      print("in submit5");
      // 2️⃣ Category Config
      if (isBottle) {
        await _bottleRepo.addConfig(
          BottleConfig(
            itemId: itemId,
            sizeMl: int.parse(bottleSize.value),
            shape: bottleShape.value,
            neckType: neckType.value,
          ),
        );
      }

      if (isCap) {
        await _capRepo.addConfig(
          CapConfig(
            itemId: itemId,
            size: capSize.value,
            color: capColor.value,
            material: capMaterial.value,
          ),
        );
      }

      print("in submit6");


      if (isLabel) {
        await _labelRepo.addConfig(
          LabelConfig(
            itemId: itemId,
            widthMm: double.parse(labelWidth.value),
            heightMm: double.parse(labelHeight.value),
            material: labelMaterial.value,
            isClientSpecific: isClientSpecific.value,
            clientId: isClientSpecific.value
                ? selectedClientId.value
                : null,
          ),
        );
      }

      // 3️⃣ Activity
      await _activityRepo.addActivity(
        itemId: itemId,
        title: 'Item Created',
        description: '${name.value} added to inventory',
      );

      print("in submit7");

      Get.back();
      Get.delete<AddInventoryItemController>();
      Get.snackbar('Success', 'Item added successfully');
    } finally {
      isSaving.value = false;
    }
  }
}

