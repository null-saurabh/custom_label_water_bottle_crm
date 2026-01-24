import 'dart:async';
import 'package:clwb_crm/screens/inventory/model/inventory_item_model.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_stock_add_model.dart';
import 'package:clwb_crm/screens/inventory/model/supplier_model.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_item_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_stocks_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/supplier_repo.dart';
import 'package:get/get.dart';

class InventoryController extends GetxController {
  final InventoryItemRepository itemRepo;
  final SupplierRepository supplierRepo;
  final InventoryStockRepository stockRepo;

  InventoryController({
    required this.itemRepo,
    required this.supplierRepo,
    required this.stockRepo,
  });

  // ===== STATE =====
  final items = <InventoryItemModel>[].obs;
  final suppliers = <SupplierModel>[].obs;
  final stockEntries = <InventoryStockAddModel>[].obs;

  final selectedItem = Rxn<InventoryItemModel>();

  final isLoading = false.obs;

  StreamSubscription? _itemSub;
  StreamSubscription? _supplierSub;
  StreamSubscription? _stockSub;

  @override
  void onInit() {
    super.onInit();
    _bindStreams();
  }

  void _bindStreams() {
    isLoading.value = true;

    _itemSub = itemRepo.watchItems().listen((data) {
      items.value = data;
      isLoading.value = false;
    });

    _supplierSub = supplierRepo.watchSuppliers().listen((data) {
      suppliers.value = data;
    });

    _stockSub = stockRepo.watchStockEntries().listen((data) {
      stockEntries.value = data;
    });
  }

  // ===== UI ACTIONS =====
  void selectItem(InventoryItemModel item) {
    selectedItem.value = item;
  }

  void clearSelection() {
    selectedItem.value = null;
  }

  @override
  void onClose() {
    _itemSub?.cancel();
    _supplierSub?.cancel();
    _stockSub?.cancel();
    super.onClose();
  }
}
