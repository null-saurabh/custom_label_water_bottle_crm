import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_activity_model.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_stock_add_model.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_activity_repo.dart';

class StockPurchaseViewController extends GetxController {
  final InventoryStockAddModel entry;
  StockPurchaseViewController(this.entry);

  final isLoading = true.obs;

  final timeline = <_PurchaseTimelineItem>[].obs;

  String supplierName = '—';
  String itemName = '—';

  final _activityRepo = InventoryActivityRepository();

  StreamSubscription? _itemActSub;
  StreamSubscription? _systemActSub;

  @override
  void onInit() {
    super.onInit();

    // Resolve names from InventoryController cache (no DB calls)
    final inv = Get.find<InventoryController>();
    supplierName = inv.supplierName(entry.supplierId);
    itemName = inv.itemName(entry.itemId);

    // Watch item activities
    _itemActSub = _activityRepo.watchActivities(entry.itemId).listen((acts) {
      final filtered = acts
          .where((a) =>
      a.referenceId == entry.id)
          .toList();

      _mergeAndSet(itemActs: filtered, systemActs: null);
    });

    // Watch system activities (payments, corrections) stored in _system bucket
    _systemActSub = _activityRepo.watchActivities('_system').listen((acts) {
      final filtered = acts
          .where((a) =>
      a.referenceId == entry.id)
          .toList();

      _mergeAndSet(itemActs: null, systemActs: filtered);
    });
  }

  List<InventoryActivityModel>? _latestItemActs;
  List<InventoryActivityModel>? _latestSystemActs;



  void _mergeAndSet({
    List<InventoryActivityModel>? itemActs,
    List<InventoryActivityModel>? systemActs,
  })
  {
    if (itemActs != null) _latestItemActs = itemActs;
    if (systemActs != null) _latestSystemActs = systemActs;

    final items = <_PurchaseTimelineItem>[];

    for (final a in (_latestItemActs ?? const <InventoryActivityModel>[])) {
      items.add(_PurchaseTimelineItem(
        at: a.createdAt,
        title: a.title,
        subtitle: a.description,
        icon: _iconFor(a),
      ));
      print("itemo ");
      print(items.length);
    }

    for (final a in (_latestSystemActs ?? const <InventoryActivityModel>[])) {

      items.add(_PurchaseTimelineItem(
        at: a.createdAt,
        title: a.title,
        subtitle: a.description,
        icon: _iconFor(a),
      ));
      // print("item1 ");
      // print(items.length);
    }

    items.sort((a, b) => b.at.compareTo(a.at));
    // print("item2 ");
    // print(items.length);
    timeline.assignAll(items);

    isLoading.value = false;
  }




  IconData _iconFor(InventoryActivityModel a) {
    switch (a.type) {
      case 'stock_in':
      case 'stock_received':
      case 'purchase_receive':
      case 'purchase_update':
        return Icons.local_shipping_outlined;
      case 'supplier_payment':
        return Icons.currency_rupee;
      case 'stock_meta_corrected':
        return Icons.edit_outlined;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  @override
  void onClose() {
    _itemActSub?.cancel();
    _systemActSub?.cancel();
    super.onClose();
  }
}

class _PurchaseTimelineItem {
  final DateTime at;
  final String title;
  final String? subtitle;
  final IconData icon;

  _PurchaseTimelineItem({
    required this.at,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
