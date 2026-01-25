import 'package:clwb_crm/screens/inventory/model/bottle_config.dart';
import 'package:clwb_crm/screens/inventory/model/cap_config.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_item_detail.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_item_model.dart';
import 'package:clwb_crm/screens/inventory/model/label_config.dart';
import 'package:clwb_crm/screens/inventory/repositories/bottle_config_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/cap_config_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_item_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/level_config_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditInventoryItemController extends GetxController {
  final InventoryItemDetail detail;

  EditInventoryItemController(this.detail);

  // ===============================
  // TEXT CONTROLLERS
  // ===============================
  late final TextEditingController nameCtrl;
  late final TextEditingController reorderCtrl;

  late final TextEditingController labelWidthCtrl;
  late final TextEditingController labelHeightCtrl;

  // ===============================
  // DROPDOWN / SELECT FIELDS
  // ===============================
  final bottleSize = ''.obs;
  final bottleShape = ''.obs;
  final neckType = ''.obs;

  final capSize = ''.obs;
  final capColor = ''.obs;
  final capMaterial = ''.obs;

  final labelMaterial = ''.obs;

  final isSaving = false.obs;

  // ===============================
  // HELPERS
  // ===============================
  bool get isBottle => detail.item.category == InventoryCategory.bottle;
  bool get isCap => detail.item.category == InventoryCategory.cap;
  bool get isLabel => detail.item.category == InventoryCategory.label;
  bool get isPackaging =>
      detail.item.category == InventoryCategory.packaging;

  // ===============================
  // REPOSITORIES
  // ===============================
  final _itemRepo = InventoryItemRepository();
  final _bottleRepo = BottleConfigRepository();
  final _capRepo = CapConfigRepository();
  final _labelRepo = LabelConfigRepository();

  // ===============================
  // INIT (PREFILL)
  // ===============================
  @override
  void onInit() {
    super.onInit();

    nameCtrl = TextEditingController(text: detail.item.name);
    reorderCtrl =
        TextEditingController(text: detail.item.reorderLevel.toString());

    labelWidthCtrl = TextEditingController();
    labelHeightCtrl = TextEditingController();

    if (detail.bottle != null) {
      bottleSize.value = detail.bottle!.sizeMl.toString();
      bottleShape.value = detail.bottle!.shape;
      neckType.value = detail.bottle!.neckType;
    }

    if (detail.cap != null) {
      capSize.value = detail.cap!.size;
      capColor.value = detail.cap!.color;
      capMaterial.value = detail.cap!.material;
    }

    if (detail.label != null) {
      labelWidthCtrl.text = detail.label!.widthMm.toString();
      labelHeightCtrl.text = detail.label!.heightMm.toString();
      labelMaterial.value = detail.label!.material;
    }
  }

  // ===============================
  // VALIDATION
  // ===============================
  bool get isValid {
    if (nameCtrl.text.trim().isEmpty) return false;

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
      return labelWidthCtrl.text.isNotEmpty &&
          labelHeightCtrl.text.isNotEmpty &&
          labelMaterial.isNotEmpty;
    }

    return true;
  }

  // ===============================
  // SUBMIT
  // ===============================
  Future<void> submit() async {
    if (!isValid) return;

    try {
      isSaving.value = true;
      final now = DateTime.now();
      final itemId = detail.item.id;

      /// 1️⃣ Update base item
      await _itemRepo.updateItem(
        itemId,
        {
          'name': nameCtrl.text.trim(),
          'reorderLevel': int.tryParse(reorderCtrl.text) ?? 0,
          'updatedAt': now,
        },
      );

      /// 2️⃣ Update / Add configs
      if (isBottle) {
        if (detail.bottle == null) {
          await _bottleRepo.addConfig(
            BottleConfig(
              itemId: itemId,
              sizeMl: int.parse(bottleSize.value),
              shape: bottleShape.value,
              neckType: neckType.value,
            ),
          );
        } else {
          await _bottleRepo.updateConfig(itemId, {
            'sizeMl': int.parse(bottleSize.value),
            'shape': bottleShape.value,
            'neckType': neckType.value,
          });
        }
      }

      if (isCap) {
        if (detail.cap == null) {
          await _capRepo.addConfig(
            CapConfig(
              itemId: itemId,
              size: capSize.value,
              color: capColor.value,
              material: capMaterial.value,
            ),
          );
        } else {
          await _capRepo.updateConfig(itemId, {
            'size': capSize.value,
            'color': capColor.value,
            'material': capMaterial.value,
          });
        }
      }

      if (isLabel) {
        if (detail.label == null) {
          await _labelRepo.addConfig(
            LabelConfig(
              itemId: itemId,
              widthMm: double.parse(labelWidthCtrl.text),
              heightMm: double.parse(labelHeightCtrl.text),
              material: labelMaterial.value,
              isClientSpecific: detail.label?.isClientSpecific ?? false,
              clientId: detail.label?.clientId,
            ),
          );
        } else {
          await _labelRepo.updateConfig(itemId, {
            'widthMm': double.parse(labelWidthCtrl.text),
            'heightMm': double.parse(labelHeightCtrl.text),
            'material': labelMaterial.value,
          });
        }
      }

      Get.back();
      Get.snackbar('Success', 'Item updated successfully');
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
    reorderCtrl.dispose();
    labelWidthCtrl.dispose();
    labelHeightCtrl.dispose();
    super.onClose();
  }
}

