import 'dart:async';
import 'package:clwb_crm/screens/inventory/dialogs/add_item_dialog.dart';
import 'package:clwb_crm/screens/inventory/dialogs/add_stock_dialog.dart';
import 'package:clwb_crm/screens/inventory/dialogs/add_supplier_dialog.dart';
import 'package:clwb_crm/screens/inventory/model/bottle_config.dart';
import 'package:clwb_crm/screens/inventory/model/cap_config.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_item_detail.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_item_model.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_stock_add_model.dart';
import 'package:clwb_crm/screens/inventory/model/label_config.dart';
import 'package:clwb_crm/screens/inventory/model/package_config.dart';
import 'package:clwb_crm/screens/inventory/model/supplier_item_model.dart';
import 'package:clwb_crm/screens/inventory/model/supplier_model.dart';
import 'package:clwb_crm/screens/inventory/repositories/bottle_config_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/cap_config_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_item_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_stocks_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/level_config_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/packaging_config_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/supplier_item_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/supplier_repo.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/repo/order_repo.dart';
import 'package:get/get.dart';



enum InventoryDetailTab {
  overview,
  transactions,
}

enum SupplierDetailTab {
  overview,
  transactions,
}
enum InventoryDetailMode {
  none,
  item,
  supplier,
}


class InventoryController extends GetxController {
  final InventoryItemRepository itemRepo;
  final SupplierRepository supplierRepo;
  final InventoryStockRepository stockRepo;
  final SupplierItemRepository supplierItemRepo;
  final OrderRepository orderRepo;

  InventoryController(this.supplierItemRepo, this.orderRepo, {
    required this.itemRepo,
    required this.supplierRepo,
    required this.stockRepo,
  });

  // ===== STATE =====
  final items = <InventoryItemModel>[].obs;
  final suppliers = <SupplierModel>[].obs;
  final stockEntries = <InventoryStockAddModel>[].obs;
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxList<SupplierItemModel> supplierItems = <SupplierItemModel>[].obs;

  final bottleConfigRepo = BottleConfigRepository();
  final capConfigRepo = CapConfigRepository();
  final labelConfigRepo = LabelConfigRepository();
  final packagingConfigRepo = PackagingConfigRepository();


  final selectedItem = Rxn<InventoryItemModel>();
  final selectedItemDetail = Rxn<InventoryItemDetail>();


  final selectedBottleConfig = Rxn<BottleConfig>();
  final selectedCapConfig = Rxn<CapConfig>();
  final selectedLabelConfig = Rxn<LabelConfig>();
  final selectedPackagingConfig = Rxn<PackagingConfig>();


  final selectedSupplier = Rxn<SupplierModel>();
  final detailMode = InventoryDetailMode.none.obs;


  final isLoading = false.obs;

  late StreamSubscription? _itemSub;
  late StreamSubscription? _supplierSub;
  late StreamSubscription? _stockSub;
  late StreamSubscription _supplierItemSub;
  late StreamSubscription _orderSub;




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
      for (final s in data) {
        // print('STOCK ${s.id} due=${s.dueAmount} total=${s.totalAmount}');
      }
      stockEntries.value = data;
    });


    _supplierItemSub =
        supplierItemRepo.watchAll().listen(supplierItems.assignAll);

    _orderSub =
        orderRepo.watchOrders().listen(orders.assignAll);
  }






  final activeDetailTab = InventoryDetailTab.overview.obs;

  void switchDetailTab(InventoryDetailTab tab) {
    activeDetailTab.value = tab;
  }


  final activeSupplierDetailTab = SupplierDetailTab.overview.obs;

  void switchSupplierDetailTab(SupplierDetailTab tab) {
    activeSupplierDetailTab.value = tab;
  }

  void openAddStockDialog() {
    Get.dialog(const AddStockDialog());
  }

  void openAddItemDialog() {
    Get.dialog(const AddItemDialog());
  }

  void openAddSupplierDialog() {
    Get.dialog(const AddSupplierDialog());
  }




  void selectItem(InventoryItemModel item) {
    clearSelection();
    clearConfigs();

    detailMode.value = InventoryDetailMode.item;

    switch (item.category) {
      case InventoryCategory.bottle:
        bottleConfigRepo.watchConfig(item.id).listen((bottle) {
          if (bottle == null) return;
          selectedItemDetail.value = InventoryItemDetail(
            item: item,
            bottle: bottle,
          );
        });
        break;

      case InventoryCategory.cap:
        capConfigRepo.watchConfig(item.id).listen((cap) {
          if (cap == null) return;
          selectedItemDetail.value = InventoryItemDetail(
            item: item,
            cap: cap,
          );
        });
        break;

      case InventoryCategory.label:
        labelConfigRepo.watchConfig(item.id).listen((label) {
          if (label == null) return;
          selectedItemDetail.value = InventoryItemDetail(
            item: item,
            label: label,
          );
        });
        break;

      case InventoryCategory.packaging:
        packagingConfigRepo.watchConfig(item.id).listen((pkg) {
          if (pkg == null) return;
          selectedItemDetail.value = InventoryItemDetail(
            item: item,
            packaging: pkg,
          );
        });
        break;
    }
  }



  void selectSupplier(SupplierModel supplier) {
    selectedItem.value = null;
    selectedSupplier.value = supplier;
    detailMode.value = InventoryDetailMode.supplier;
  }

  void clearSelection() {
    selectedItem.value = null;
    selectedSupplier.value = null;
    detailMode.value = InventoryDetailMode.none;
  }



  void clearConfigs() {
    selectedBottleConfig.value = null;
    selectedCapConfig.value = null;
    selectedLabelConfig.value = null;
    selectedPackagingConfig.value = null;
  }



  int inStock(String itemId) {
    return items.firstWhere((e) => e.id == itemId).stock;
  }

  int orderDueThisWeek(String itemId) {
    return orders
        .where((o) =>
    o.itemId == itemId &&
        o.status != 'delivered' &&
        _isThisWeek(o.deliveryDate))
        .fold(0, (s, o) => s + (o.totalBottles - o.deliveredBottles));
  }

  int orderDueThisMonth(String itemId) {
    return orders
        .where((o) =>
    o.itemId == itemId &&
        o.status != 'delivered' &&
        _isThisMonth(o.deliveryDate))
        .fold(0, (s, o) => s + (o.totalBottles - o.deliveredBottles));
  }

  double currentStockValue(String itemId) {
    final itemStocks =
    stockEntries.where((s) => s.itemId == itemId).toList();
    if (itemStocks.isEmpty) return 0;

    final latestRate = itemStocks.last.ratePerUnit;
    return inStock(itemId) * latestRate;
  }

  double soldStockValue(String itemId) {
    return orders
        .where((o) => o.itemId == itemId)
        .fold(0, (s, o) => s + o.totalAmount);
  }











  /// All suppliers for a given inventory item
  List<SupplierModel> suppliersForItem(String itemId) {
    final supplierIds = supplierItems
        .where((e) => e.itemId == itemId)
        .map((e) => e.supplierId)
        .toSet();

    return suppliers
        .where((s) => supplierIds.contains(s.id))
        .toList();
  }

  /// Stock history for item + supplier
  List<InventoryStockAddModel> stockHistoryForItemSupplier({
    required String itemId,
    required String supplierId,
  }) {
    return stockEntries
        .where((e) =>
    e.itemId == itemId &&
        e.supplierId == supplierId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  final expandedItemSupplierId = RxnString();

  void toggleItemSupplierExpansion(String supplierId) {
    if (expandedItemSupplierId.value == supplierId) {
      expandedItemSupplierId.value = null;
    } else {
      expandedItemSupplierId.value = supplierId;
    }
  }


  /// ===============================
  /// SUPPLIER AGGREGATIONS
  /// ===============================
  ///
  ///

  final expandedSupplierItemId = RxnString();

  void toggleSupplierItemExpansion(String itemId) {
    if (expandedSupplierItemId.value == itemId) {
      expandedSupplierItemId.value = null; // collapse
    } else {
      expandedSupplierItemId.value = itemId; // expand new, auto-collapse old
    }
  }

  List<InventoryStockAddModel> stockHistoryForSupplierItem({
    required String supplierId,
    required String itemId,
  }) {
    return stockEntries
        .where((e) =>
    e.supplierId == supplierId &&
        e.itemId == itemId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }


  String supplierCategories(String supplierId) {
    final itemIds = supplierItems
        .where((e) => e.supplierId == supplierId)
        .map((e) => e.itemId)
        .toSet();

    final categories = items
        .where((i) => itemIds.contains(i.id))
        .map((i) => i.category.name)
        .toSet();

    return categories.isEmpty ? '—' : categories.join(', ');
  }

  List<InventoryItemModel> itemsForSupplier(String supplierId) {
    final itemIds = supplierItems
        .where((e) => e.supplierId == supplierId)
        .map((e) => e.itemId)
        .toSet();

    return items.where((i) => itemIds.contains(i.id)).toList();
  }

  int supplierPendingDeliveryQuantity(String supplierId) {
    return stockEntries
        .where((e) =>
    e.supplierId == supplierId &&
        e.status != DeliveryStatus.received)
        .fold(0, (sum, e) => sum + (e.orderedQuantity - e.receivedQuantity));
  }

  double supplierPendingDeliveryValue(String supplierId) {
    return stockEntries
        .where((e) =>
    e.supplierId == supplierId &&
        e.status != DeliveryStatus.received)
        .fold(0.0, (sum, e) {
      final pendingQty = e.orderedQuantity - e.receivedQuantity;
      return sum + (pendingQty * e.ratePerUnit);
    });
  }


  int supplierPendingDeliveries(String supplierId) {
    return stockEntries.where((e) =>
    e.supplierId == supplierId &&
        e.status != DeliveryStatus.received
    ).length;
  }



  /// 1️⃣ Number of distinct items supplied by this supplier
  int supplierItemsCount(String supplierId) {
    return supplierItems
        .where((e) => e.supplierId == supplierId)
        .map((e) => e.itemId)
        .toSet()
        .length;
  }

  /// 2️⃣ Total purchase events (how many times stock was bought)
  int supplierPurchaseCount(String supplierId) {
    return stockEntries
        .where((e) => e.supplierId == supplierId)
        .length;
  }

  /// 3️⃣ Total business done with supplier (lifetime)
  double supplierTotalPurchased(String supplierId) {
    return stockEntries
        .where((e) => e.supplierId == supplierId)
        .fold(0.0, (s, e) => s + e.totalAmount);
  }

  /// 4️⃣ Total amount paid to supplier
  double supplierTotalPaid(String supplierId) {
    return stockEntries
        .where((e) => e.supplierId == supplierId)
        .fold(0.0, (s, e) => s + e.paidAmount);
  }

  /// 5️⃣ Outstanding / due amount
  double supplierPendingAmount(String supplierId) {
    return stockEntries
        .where((e) => e.supplierId == supplierId)
        .fold(0.0, (s, e) => s + e.dueAmount);
  }



// ===== SEARCH =====
  final itemSearchQuery = ''.obs;
  final supplierSearchQuery = ''.obs;

  // ===== FILTERED ITEMS =====
  List<InventoryItemModel> get filteredItems {
    final q = itemSearchQuery.value.toLowerCase().trim();

    if (q.isEmpty) return items;

    return items.where((i) {
      return i.name.toLowerCase().contains(q) ||
          i.category.name.toLowerCase().contains(q);
    }).toList();
  }

// ===== FILTERED SUPPLIERS =====
  List<SupplierModel> get filteredSuppliers {
    final q = supplierSearchQuery.value.toLowerCase().trim();

    if (q.isEmpty) return suppliers;

    return suppliers.where((s) {
      return s.name.toLowerCase().contains(q);
    }).toList();
  }




  double get totalStockValue {
    double total = 0;

    for (final item in items) {
      // latest stock entry for this item
      final itemStocks = stockEntries
          .where((s) => s.itemId == item.id)
          .toList();

      if (itemStocks.isEmpty) continue;

      final latestRate = itemStocks.last.ratePerUnit;
      total += item.stock * latestRate;
    }

    return total;
  }







  int get ordersDueThisWeek {
    final now = DateTime.now();
    final startOfWeek =
    now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    return orders
        .where((o) =>
    o.status != 'delivered' &&
        o.deliveryDate.isAfter(startOfWeek) &&
        o.deliveryDate.isBefore(endOfWeek))
        .length; // or sum quantities if you want
  }







  bool _isThisWeek(DateTime d) {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final end = start.add(const Duration(days: 7));
    return d.isAfter(start) && d.isBefore(end);
  }

  bool _isThisMonth(DateTime d) {
    final now = DateTime.now();
    return d.month == now.month && d.year == now.year;
  }



  @override
  void onClose() {
    _itemSub?.cancel();
    _supplierSub?.cancel();
    _stockSub?.cancel();
    super.onClose();
  }
}
