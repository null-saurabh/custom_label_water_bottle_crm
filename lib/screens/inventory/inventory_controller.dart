import 'dart:async';
import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:clwb_crm/screens/inventory/dialogs/add_item_dialog.dart';
import 'package:clwb_crm/screens/inventory/dialogs/add_stock_dialog.dart';
import 'package:clwb_crm/screens/inventory/dialogs/add_supplier_dialog.dart';
import 'package:clwb_crm/screens/inventory/dialogs/edit_stock_meta_dialog.dart';
import 'package:clwb_crm/screens/inventory/dialogs/receive_stock_dialog.dart';
import 'package:clwb_crm/screens/inventory/dialogs/stock_payment_dialog.dart';
import 'package:clwb_crm/screens/inventory/dialogs/stock_purchase_view_dialog.dart';
import 'package:clwb_crm/screens/inventory/model/bottle_config.dart';
import 'package:clwb_crm/screens/inventory/model/cap_config.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_activity_model.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_item_detail.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_item_model.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_stock_add_model.dart';
import 'package:clwb_crm/screens/inventory/model/label_config.dart';
import 'package:clwb_crm/screens/inventory/model/package_config.dart';
import 'package:clwb_crm/screens/inventory/model/supplier_item_model.dart';
import 'package:clwb_crm/screens/inventory/model/supplier_model.dart';
import 'package:clwb_crm/screens/inventory/repositories/bottle_config_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/cap_config_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_activity_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_item_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_stocks_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/level_config_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/packaging_config_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/supplier_item_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/supplier_repo.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/repo/order_repo.dart';
import 'package:flutter/material.dart';
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

class InventoryWarning {
  final InventoryItemModel item;
  final String title;
  final String subtitle;
  final String badge;

  InventoryWarning({
    required this.item,
    required this.title,
    required this.subtitle,
    required this.badge,
  });
}



class InventoryController extends GetxController {
  final InventoryItemRepository itemRepo;
  final SupplierRepository supplierRepo;
  final InventoryStockRepository stockRepo;
  final SupplierItemRepository supplierItemRepo;
  final OrdersRepository orderRepo;
  final InventoryActivityRepository activityRepo;


  InventoryController(this.supplierItemRepo, this.orderRepo, {
    required this.itemRepo,
    required this.supplierRepo,
    required this.stockRepo,
    required this.activityRepo,
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

  final RxList<InventoryActivityModel> systemInventoryActivities =
      <InventoryActivityModel>[].obs;


  final isLoading = false.obs;

  late StreamSubscription? _itemSub;
  late StreamSubscription? _supplierSub;
  late StreamSubscription? _stockSub;
  StreamSubscription? _configSub;

  late StreamSubscription _supplierItemSub;
  late StreamSubscription _orderSub;
  late StreamSubscription? _systemActSub;



  final stockSupplierSearchQuery = ''.obs;
  final TextEditingController stockSupplierSearchCtrl = TextEditingController();



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

      _systemActSub =
          activityRepo.watchActivities('_system').listen((acts) {
            systemInventoryActivities.assignAll(acts);
          });

      stockEntries.value = data;
    });


    _supplierItemSub =
        supplierItemRepo.watchAll().listen(supplierItems.assignAll);

    _orderSub =
        orderRepo.watchAllOrders().listen(orders.assignAll);
  }



  void setStockSupplierSearch(String v) {
    stockSupplierSearchQuery.value = v;
  }
  List<InventoryStockAddModel> get filteredStockPurchases {
    final q = stockSupplierSearchQuery.value.toLowerCase().trim();

    // Only pending/partial entries for this widget
    var list = stockEntries
        .where((e) => e.status != DeliveryStatus.received)
        .toList();

    if (q.isNotEmpty) {
      list = list.where((e) {
        final sName = supplierName(e.supplierId).toLowerCase();
        return sName.contains(q);
      }).toList();
    }

    // Most recent first
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }


  void openStockReceiveDialog(InventoryStockAddModel entry) {
    Get.dialog(ReceiveStockDialog(entry: entry));
  }

  void openStockPaymentDialog(InventoryStockAddModel entry) {
    Get.dialog(StockPaymentDialog(entry: entry));
  }

  void openStockCorrectionDialog(InventoryStockAddModel entry) {
    // admin-only gate later (role-based). For now:
    Get.dialog(EditStockMetaDialog(entry: entry));
  }



  void openStockPurchaseViewDialog(InventoryStockAddModel entry) {
    Get.dialog(StockPurchaseViewDialog(entry: entry));
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
    _configSub?.cancel();
    _configSub = null;
    _itemActivitySub?.cancel();

    detailMode.value = InventoryDetailMode.item;

    _itemActivitySub =
        activityRepo.watchActivities(item.id).listen((acts) {
          selectedItemActivities.assignAll(acts);
        });

    switch (item.category) {
      case InventoryCategory.bottle:
        _configSub = bottleConfigRepo.watchConfig(item.id).listen((bottle) {
          if (bottle == null) return;
          selectedItemDetail.value = InventoryItemDetail(
            item: item,
            bottle: bottle,
          );
        });

        break;

      case InventoryCategory.cap:
        _configSub = capConfigRepo.watchConfig(item.id).listen((cap) {
          if (cap == null) return;
          selectedItemDetail.value = InventoryItemDetail(
            item: item,
            cap: cap,
          );
        });


        break;

      case InventoryCategory.label:
        _configSub = labelConfigRepo.watchConfig(item.id).listen((label) {
          if (label == null) return;
          selectedItemDetail.value = InventoryItemDetail(
            item: item,
            label: label,
          );
        });

        break;

      case InventoryCategory.packaging:
        _configSub = packagingConfigRepo.watchConfig(item.id).listen((pkg) {
          // if (pkg == null) return;
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
        o.orderStatus != 'delivered' &&
        _isThisWeek(o.expectedDeliveryDate ?? DateTime.now()))
        .fold(0, (s, o) => s + (o.orderedQuantity - o.deliveredQuantity));
  }

  int orderDueThisMonth(String itemId) {
    return orders
        .where((o) =>
    o.itemId == itemId &&
        o.orderStatus != 'delivered' &&
        _isThisMonth(o.expectedDeliveryDate ?? DateTime.now()))
        .fold(0, (s, o) => s + (o.orderedQuantity - o.deliveredQuantity));
  }

  double currentStockValue(String itemId) {
    final itemStocks =
    stockEntries.where((s) => s.itemId == itemId).toList();
    if (itemStocks.isEmpty) return 0;

    itemStocks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final latestRate = itemStocks.first.ratePerUnit;

    return inStock(itemId) * latestRate;
  }

  double soldStockValue(String itemId) {
    return orders
        .where((o) => o.itemId == itemId)
        .fold(0, (s, o) => s + o.totalAmount);
  }


final RxList<InventoryActivityModel> selectedItemActivities =
      <InventoryActivityModel>[].obs;

  StreamSubscription? _itemActivitySub;


  List<InventoryActivityModel> inventoryActivitiesForItem(String itemId) {
    return selectedItemActivities
        .where((a) => a.itemId == itemId)
        .toList();
  }

  String supplierNameForStockActivity(InventoryActivityModel a) {
    if (a.referenceId == null) return 'System';

    final stock = stockEntries.firstWhereOrNull(
          (s) => s.id == a.referenceId,
    );

    if (stock == null) return 'System';

    return supplierName(stock.supplierId);
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

  DateTime? supplierNextDeliveryDate(String supplierId) {
    final pending = stockEntries
        .where((e) =>
    e.supplierId == supplierId &&
        e.status != DeliveryStatus.received &&
        e.deliveryDate != null)
        .toList();

    if (pending.isEmpty) return null;

    pending.sort(
          (a, b) => a.deliveryDate!.compareTo(b.deliveryDate!),
    );

    return pending.first.deliveryDate;
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

      itemStocks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final latestRate = itemStocks.first.ratePerUnit;
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
    o.orderStatus != 'delivered' &&
        o.expectedDeliveryDate!.isAfter(startOfWeek) &&
        o.expectedDeliveryDate!.isBefore(endOfWeek))
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



  InventoryItemModel? resolveLabelForClientAndBottle(
      ClientModel client,
      BottleConfig bottleCfg,
      ) {

    // print(bottleCfg.sizeMl);
    final labelItemId = bottleCfg.sizeMl >= 1000
        ? client.labelLargeItemId
        : client.labelSmallItemId;
// print(labelItemId);
// print(bottleCfg.sizeMl >= 1000);
    if (labelItemId == null) return null;

    return items.firstWhereOrNull(
          (i) => i.id == labelItemId,
    );
  }

// Caps: selectable
  List<InventoryItemModel> get availableCaps =>
      items
          .where(
            (i) =>
        i.category == InventoryCategory.cap &&
            i.isActive,
      )
          .toList();

// Packaging: optional global default
  InventoryItemModel? get defaultPackagingItem =>
      items.firstWhereOrNull(
            (i) =>
        i.category == InventoryCategory.packaging &&

            i.isActive,
      );


  Future<void> addStock({
    required String itemId,
    required int quantity,
  }) async {
    if (quantity <= 0) return;

    await itemRepo.applyStockDeltasTransactional(
      itemDeltas: {itemId: quantity},
    );
  }

  Future<void> deductStock({
    required String itemId,
    required int quantity,
  }) async {
    if (quantity <= 0) return;

    await itemRepo.applyStockDeltasTransactional(
      itemDeltas: {itemId: -quantity},
    );
  }









  String itemName(String itemId) {
    final i = items.firstWhereOrNull((e) => e.id == itemId);
    return i?.name ?? 'Unknown Item';
  }

  String supplierName(String supplierId) {
    final s = suppliers.firstWhereOrNull((e) => e.id == supplierId);
    return s?.name ?? 'Unknown Supplier';
  }

  List<InventoryWarning> get inventoryWarnings {
    final out = <InventoryWarning>[];

    for (final item in items.where((i) => i.isActive)) {
      final stock = item.stock;
      final reorder = item.reorderLevel;

      // Demand signals
      final dueWeek = orderDueThisWeek(item.id);
      final dueMonth = orderDueThisMonth(item.id);

      // A) shortage this week
      if (dueWeek > stock) {
        final shortage = dueWeek - stock;
        out.add(
          InventoryWarning(
            item: item,
            title: '${item.name} shortage (this week)',
            subtitle: 'Stock $stock, due $dueWeek. Short by $shortage.',
            badge: '-$shortage',
          ),
        );
        continue; // shortage is more urgent than reorder threshold
      }

      // B) reorder threshold
      if (stock <= reorder && reorder > 0) {
        out.add(
          InventoryWarning(
            item: item,
            title: '${item.name} below reorder level',
            subtitle: 'Stock $stock, reorder level $reorder.',
            badge: 'LOW',
          ),
        );
        continue;
      }

      // C) upcoming month pressure (optional)
      if (dueMonth > stock && dueWeek <= stock) {
        final shortage = dueMonth - stock;
        out.add(
          InventoryWarning(
            item: item,
            title: '${item.name} pressure (this month)',
            subtitle: 'Stock $stock, due $dueMonth. Risk: short by $shortage.',
            badge: 'RISK',
          ),
        );
      }
    }

    // Sort: shortages first
    out.sort((a, b) {
      int score(InventoryWarning w) {
        if (w.badge.startsWith('-')) return 0;
        if (w.badge == 'LOW') return 1;
        return 2;
      }
      final s = score(a).compareTo(score(b));
      if (s != 0) return s;
      return a.title.compareTo(b.title);
    });

    return out;
  }





  void openAllStockEntriesView() {
    // Optional: later you can route to a dedicated screen or open a dialog.
    // For now do nothing or show snackbar.
    Get.snackbar('Coming soon', 'Full stock ledger view will open here.');
  }


  @override
  void onClose() {
    _itemSub?.cancel();
    _supplierSub?.cancel();
    _stockSub?.cancel();
    _supplierItemSub.cancel();
    _orderSub.cancel();
    _configSub?.cancel();
    stockSupplierSearchCtrl.dispose();
    _itemActivitySub?.cancel();
    selectedItemActivities.clear();
    _systemActSub?.cancel();


    super.onClose();
  }

}
