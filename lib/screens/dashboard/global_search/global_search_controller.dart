import 'dart:async';
import 'package:clwb_crm/core/controllers/app_controller.dart';
import 'package:clwb_crm/screens/client/client_controller.dart';
import 'package:clwb_crm/screens/dashboard/models/global_search_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:clwb_crm/screens/orders/order_controller.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';

import 'package:clwb_crm/screens/leads/leads_controller.dart';

import 'package:clwb_crm/screens/inventory/inventory_controller.dart';


class GlobalSearchController extends GetxController {
  final query = ''.obs;
  final isOpen = false.obs;

  final results = <GlobalSearchResult>[].obs;
  final focusedIndex = 0.obs;

  final ScrollController scrollCtrl = ScrollController();

  Timer? _debounce;

  OrdersController get _orders => Get.find<OrdersController>();
  ClientsController get _clients => Get.find<ClientsController>();
  LeadsController get _leads => Get.find<LeadsController>();
  InventoryController get _inv => Get.find<InventoryController>();
  AppController get _app => Get.find<AppController>();

  @override
  void onInit() {
    super.onInit();

    ever<String>(query, (_) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 120), _rebuild);
    });
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  void open() {
    isOpen.value = true;
    focusedIndex.value = 0;
  }

  void close() {
    isOpen.value = false;
    focusedIndex.value = 0;
  }

  void clear() {
    query.value = '';
    results.clear();
    close();
  }

  static const double _itemHeight = 44.0; // must match tile height

  void _scrollToFocused() {
    if (!scrollCtrl.hasClients) return;

    final offset = focusedIndex.value * _itemHeight;

    scrollCtrl.animateTo(
      offset,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
    );
  }


  void moveDown() {
    if (results.isEmpty) return;

    focusedIndex.value =
        (focusedIndex.value + 1) % results.length;

    _scrollToFocused();
  }

  void moveUp() {
    if (results.isEmpty) return;

    focusedIndex.value =
        (focusedIndex.value - 1 + results.length) % results.length;

    _scrollToFocused();
  }


  void submitFocused() {
    if (results.isEmpty) return;
    final i = focusedIndex.value.clamp(0, results.length - 1);
    onSelect(results[i]);
  }

  void onSelect(GlobalSearchResult r) {
    // Keep dropdown stable
    close();

    switch (r.type) {
      case GlobalSearchType.order:
        _app.selectMenu(SidebarMenu.orders);
        // ✅ order + client search supported via OrdersController searchQuery
        _orders.setSearch(r.id); // we'll pass orderNumber in id for orders
        break;

      case GlobalSearchType.client:
        _app.selectMenu(SidebarMenu.clients);
        _clients.searchQuery.value = r.id; // businessName
        // optional: if you want to auto-select
        final c = _clients.clients.firstWhereOrNull(
              (x) => x.id == r.subtitle, // not used in this simple approach
        );
        if (c != null) _clients.selectClient(c.id);
        break;

      case GlobalSearchType.lead:
        _app.selectMenu(SidebarMenu.leads);
        _leads.leadSearchQuery.value = r.id; // businessName
        break;

      case GlobalSearchType.inventoryItem:
        _app.selectMenu(SidebarMenu.inventory);
        final item = _inv.items.firstWhereOrNull((i) => i.id == r.id);
        if (item != null) {
          _inv.itemSearchQuery.value = item.name;
          _inv.selectItem(item);
        }
        break;

      case GlobalSearchType.supplier:
        _app.selectMenu(SidebarMenu.inventory);
        final s = _inv.suppliers.firstWhereOrNull((x) => x.id == r.id);
        if (s != null) {
          _inv.supplierSearchQuery.value = s.name;
          _inv.selectSupplier(s);
        }
        break;
    }

    // optional: clear search after navigation
    query.value = '';
    results.clear();
  }

  void _rebuild() {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) {
      results.clear();
      close();
      return;
    }

    final out = <GlobalSearchResult>[];

    // -------------------
    // Orders (order + client)
    // We store orderNumber in id so OrdersController.setSearch works directly.
    // -------------------
    for (final o in _orders.allOrders) {
      final orderNo = (o.orderNumber).toLowerCase();
      final client = (o.clientNameSnapshot).toLowerCase();
      if (!orderNo.contains(q) && !client.contains(q)) continue;

      out.add(
        GlobalSearchResult(
          type: GlobalSearchType.order,
          id: o.orderNumber, // ✅ used for OrdersController.setSearch
          title: 'Order #${o.orderNumber} — ${o.clientNameSnapshot}',
          subtitle: _dueLabel(o),
        ),
      );
    }

    // -------------------
    // Clients
    // -------------------
    for (final c in _clients.clients) {
      final b = c.businessName.toLowerCase();
      final n = c.contactName.toLowerCase();
      if (!b.contains(q) && !n.contains(q)) continue;

      out.add(
        GlobalSearchResult(
          type: GlobalSearchType.client,
          id: c.businessName,
          title: 'Client — ${c.businessName}',
          subtitle: c.contactName,
        ),
      );
    }

    // -------------------
    // Leads
    // -------------------
    for (final l in _leads.leads) {
      bool contains(String? v) =>
          v != null && v.toLowerCase().contains(q);

      if (!contains(l.businessName) &&
          !contains(l.contactName) &&
          !contains(l.phone) &&
          !contains(l.email) &&
          !contains(l.area)) {
        continue;
      }

      out.add(
        GlobalSearchResult(
          type: GlobalSearchType.lead,
          id: l.businessName ?? '',
          title: 'Lead — ${l.businessName ?? '—'}',
          subtitle: (l.status).name, // newLead/contacted/etc
        ),
      );
    }

    // -------------------
    // Inventory items
    // -------------------
    for (final item in _inv.items.where((i) => i.isActive)) {
      final name = item.name.toLowerCase();
      final cat = item.category.name.toLowerCase();
      if (!name.contains(q) && !cat.contains(q)) continue;

      final isLow = (item.reorderLevel > 0 && item.stock <= item.reorderLevel);
      out.add(
        GlobalSearchResult(
          type: GlobalSearchType.inventoryItem,
          id: item.id,
          title: 'Inventory — ${item.name}',
          subtitle: isLow ? 'Low Stock' : 'Stock ${item.stock}',
        ),
      );
    }

    // -------------------
    // Suppliers
    // -------------------
    for (final s in _inv.suppliers) {
      final name = s.name.toLowerCase();
      if (!name.contains(q)) continue;

      out.add(
        GlobalSearchResult(
          type: GlobalSearchType.supplier,
          id: s.id,
          title: 'Supplier — ${s.name}',
          subtitle: 'Supplier',
        ),
      );
    }

    // sort: orders first, then inventory, then others (tweak if you want)
    int score(GlobalSearchType t) {
      switch (t) {
        case GlobalSearchType.client:
          return 0;
        case GlobalSearchType.inventoryItem:
          return 1;
        case GlobalSearchType.supplier:
          return 2;
        case GlobalSearchType.lead:
          return 3;
        case GlobalSearchType.order:
          return 4;
      }
    }

    out.sort((a, b) {
      final s = score(a.type).compareTo(score(b.type));
      if (s != 0) return s;
      return a.title.compareTo(b.title);
    });

    results.assignAll(out.take(20)); // dropdown shouldn’t become a spreadsheet
    open();
  }

  String _dueLabel(OrderModel o) {
    final due = o.nextDeliveryDate ?? o.expectedDeliveryDate;
    if (due == null) return '';
    final now = DateTime.now();
    final d0 = DateTime(now.year, now.month, now.day);
    final d1 = DateTime(due.year, due.month, due.day);
    final diff = d1.difference(d0).inDays;

    if (diff == 0) return '(Due Today)';
    if (diff == 1) return '(Due Tomorrow)';
    if (diff == -1) return '(Due Yesterday)';
    return '(Due ${due.day.toString().padLeft(2, '0')}/${due.month.toString().padLeft(2, '0')})';
  }
}
