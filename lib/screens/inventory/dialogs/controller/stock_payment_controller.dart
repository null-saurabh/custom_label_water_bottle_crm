import 'package:clwb_crm/screens/inventory/repositories/inventory_stocks_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:clwb_crm/screens/inventory/model/inventory_stock_add_model.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_activity_repo.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_activity_model.dart';

class StockPaymentController extends GetxController {
  final InventoryStockAddModel entry;
  StockPaymentController(this.entry);

  final isSaving = false.obs;

  late final TextEditingController amountCtrl;
  late final TextEditingController refCtrl;
  late final TextEditingController dateCtrl;

  double get payToday =>
      double.tryParse(amountCtrl.text.trim()) ?? 0;

  String? get referenceNo {
    final t = refCtrl.text.trim();
    return t.isEmpty ? null : t;
  }

  DateTime get paymentDate {
    final t = dateCtrl.text.trim();
    if (t.isEmpty) return DateTime.now();
    try {
      final p = t.split('-');
      if (p.length != 3) return DateTime.now();
      return DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
    } catch (_) {
      return DateTime.now();
    }
  }

  double get newPaidAmount => entry.paidAmount + payToday;
  double get newDueAmount => entry.totalAmount - newPaidAmount;

  final _stockRepo = InventoryStockRepository();
  final _activityRepo = InventoryActivityRepository();

  @override
  void onInit() {
    super.onInit();
    amountCtrl = TextEditingController();
    refCtrl = TextEditingController();
    dateCtrl = TextEditingController();
  }

  Future<void> submit() async {
    if (payToday <= 0) {
      Get.snackbar('Invalid', 'Enter payment amount');
      return;
    }

    if (newPaidAmount > entry.totalAmount) {
      Get.snackbar('Invalid', 'Payment exceeds total amount');
      return;
    }

    isSaving.value = true;
    try {
      final now = DateTime.now();

      await _stockRepo.updateStockEntry(entry.id, {
        'paidAmount': newPaidAmount,
        'dueAmount': newDueAmount,
        'updatedAt': now,
      });

      // Log in _system bucket (money movement, not stock movement)
      await _activityRepo.addActivity(
        InventoryActivityModel(
          id: '',
          itemId: '_system',
          type: 'supplier_payment',
          source: 'inventory_stock',
          title: 'Supplier Payment',
          description:
          'Paid ₹${payToday.toStringAsFixed(0)} for stock entry ${entry.id}'
              '${referenceNo == null ? '' : ' (Ref: $referenceNo)'}',
          stockDelta: 0,
          amount: payToday,
          unitCost: null,
          referenceId: entry.id,
          referenceType: 'inventory_stock',
          createdBy: 'admin',
          createdAt: paymentDate,
          isActive: true,
        ),
      );

      Get.back();
      Get.snackbar('Saved', 'Payment added');
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    amountCtrl.dispose();
    refCtrl.dispose();
    dateCtrl.dispose();
    super.onClose();
  }
}
