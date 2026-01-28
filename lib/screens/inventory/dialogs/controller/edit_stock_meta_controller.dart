import 'package:clwb_crm/screens/inventory/repositories/inventory_stocks_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:clwb_crm/screens/inventory/model/inventory_stock_add_model.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_activity_repo.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_activity_model.dart';

class EditStockMetaController extends GetxController {
  final InventoryStockAddModel entry;
  EditStockMetaController(this.entry);

  final isSaving = false.obs;

  late final TextEditingController orderedCtrl;
  late final TextEditingController rateCtrl;
  late final TextEditingController dueCtrl;
  late final TextEditingController nextDeliveryCtrl;
  late final TextEditingController refCtrl;
  late final TextEditingController noteCtrl;

  int get ordered => int.tryParse(orderedCtrl.text.trim()) ?? entry.orderedQuantity;
  double get rate => double.tryParse(rateCtrl.text.trim()) ?? entry.ratePerUnit;

  String? get referenceNo {
    final t = refCtrl.text.trim();
    return t.isEmpty ? null : t;
  }

  DateTime? _parseDate(String t) {
    final s = t.trim();
    if (s.isEmpty) return null;
    try {
      final p = s.split('-');
      if (p.length != 3) return null;
      return DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
    } catch (_) {
      return null;
    }
  }

  DateTime? get dueDate => _parseDate(dueCtrl.text);
  DateTime? get nextDeliveryDate => _parseDate(nextDeliveryCtrl.text);

  double get newTotal => ordered * rate;
  double get newDue => newTotal - entry.paidAmount;

  final _stockRepo = InventoryStockRepository();
  final _activityRepo = InventoryActivityRepository();

  @override
  void onInit() {
    super.onInit();
    orderedCtrl = TextEditingController(text: entry.orderedQuantity.toString());
    rateCtrl = TextEditingController(text: entry.ratePerUnit.toStringAsFixed(2));
    dueCtrl = TextEditingController(
      text: entry.dueDate == null
          ? ''
          : '${entry.dueDate!.year.toString().padLeft(4, '0')}-${entry.dueDate!.month.toString().padLeft(2, '0')}-${entry.dueDate!.day.toString().padLeft(2, '0')}',
    );
    nextDeliveryCtrl = TextEditingController(
      text: entry.deliveryDate == null
          ? ''
          : '${entry.deliveryDate!.year.toString().padLeft(4, '0')}-${entry.deliveryDate!.month.toString().padLeft(2, '0')}-${entry.deliveryDate!.day.toString().padLeft(2, '0')}',
    );
    refCtrl = TextEditingController();
    noteCtrl = TextEditingController();
  }

  Future<void> submit() async {
    final note = noteCtrl.text.trim();
    if (note.isEmpty) {
      Get.snackbar('Required', 'Correction note is required');
      return;
    }

    if (ordered < entry.receivedQuantity) {
      Get.snackbar('Invalid', 'Ordered cannot be less than received quantity');
      return;
    }

    if (rate <= 0) {
      Get.snackbar('Invalid', 'Rate must be > 0');
      return;
    }

    isSaving.value = true;
    try {
      final now = DateTime.now();

      // Update stock entry (meta correction)
      await _stockRepo.updateStockEntry(entry.id, {
        'orderedQuantity': ordered,
        'ratePerUnit': rate,
        'totalAmount': newTotal,
        'dueAmount': newDue,
        'dueDate': dueDate,
        'deliveryDate': nextDeliveryDate,
        'updatedAt': now,
        // optional: store referenceNo if your model supports it
        // 'referenceNo': referenceNo,
      });

      // Audit log in _system
      await _activityRepo.addActivity(
        InventoryActivityModel(
          id: '',
          itemId: '_system',
          type: 'stock_meta_corrected',
          source: 'admin',
          title: 'Stock Entry Corrected',
          description:
          'Stock entry ${entry.id} corrected. Note: $note',
          stockDelta: 0,
          amount: null,
          unitCost: null,
          referenceId: entry.id,
          referenceType: 'inventory_stock',
          createdBy: 'admin',
          createdAt: now,
          isActive: true,
        ),
      );

      Get.back();
      Get.snackbar('Saved', 'Correction saved');
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    orderedCtrl.dispose();
    rateCtrl.dispose();
    dueCtrl.dispose();
    nextDeliveryCtrl.dispose();
    refCtrl.dispose();
    noteCtrl.dispose();
    super.onClose();
  }
}
