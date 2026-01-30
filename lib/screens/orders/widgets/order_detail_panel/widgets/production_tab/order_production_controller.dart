import 'dart:async';

import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_activity_model.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_activity_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/inventory_item_repo.dart';
import 'package:clwb_crm/screens/inventory/repositories/packaging_config_repo.dart';
import 'package:clwb_crm/screens/orders/models/order_activity_model.dart';
import 'package:clwb_crm/screens/orders/models/order_delivery_entry_model.dart';
import 'package:clwb_crm/screens/orders/models/order_expense_model.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/models/order_production_entry_model.dart';
import 'package:clwb_crm/screens/orders/repo/order_activity_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_delivery_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_expense_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_production_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_repo.dart';
import 'package:clwb_crm/screens/orders/widgets/order_detail_panel/widgets/production_tab/order_timeline_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProductionController extends GetxController {
  final OrderProductionRepository _productionRepo;
  final OrderDeliveryRepository _deliveryRepo;
  final OrdersRepository _ordersRepo;
  final OrderExpenseRepository _expenseRepo;
  final OrderActivityRepository _activityRepo;
  final InventoryActivityRepository _inventoryActivityRepo;
  final InventoryController _inventory;


  ProductionController(
      this._productionRepo,
      this._deliveryRepo,
      this._ordersRepo,
      this._expenseRepo,
      this._activityRepo,
      this._inventoryActivityRepo,
      this._inventory,

      );


  final _inventoryItemRepo = InventoryItemRepository();
  final _packagingConfigRepo = PackagingConfigRepository();



  final isSaving = false.obs;

  final Rxn<OrderModel> order = Rxn();

  final RxList<OrderProductionEntryModel> productions = <OrderProductionEntryModel>[].obs;
  final RxList<OrderDeliveryEntryModel> deliveries = <OrderDeliveryEntryModel>[].obs;
  final RxList<OrderExpenseModel> expenses = <OrderExpenseModel>[].obs;

  final RxList<OrderTimelineItem> timeline = <OrderTimelineItem>[].obs;

  StreamSubscription? _prodSub;
  StreamSubscription? _delSub;
  StreamSubscription? _expSub;
  StreamSubscription? _orderSub;

  // ======================
// EXPENSE FORM STATE
// ======================

  final expenseStage = 'production'.obs;
  final expenseCategory = ''.obs;
  final vendorName = ''.obs;

  final expenseAmount = 0.0.obs;
  final paidAmount = 0.0.obs;
  final expenseDue = 0.0.obs;

  final referenceNo = ''.obs;
  final expenseNotes = ''.obs;


  // ======================
  // UI FIELDS
  // ======================
  final producedToday = 0.obs;
  final deliveredToday = 0.obs;
  final productionNotes = ''.obs;
  final deliveryNotes = ''.obs;

  // ======================
// CLIENT PAYMENT STATE
// ======================

  final paymentAmount = 0.0.obs;
  final paymentRef = ''.obs;
  final paymentNotes = ''.obs;



  void bindOrder(OrderModel o) {
    if (order.value?.id == o.id) return;

    order.value = o;

    _prodSub?.cancel();
    _delSub?.cancel();
    _expSub?.cancel();
    _orderSub?.cancel();

    // 🔥 THIS IS THE MISSING PIECE
    _orderSub = _ordersRepo
        .watchOrderById(o.id)
        .listen((fresh) {
      order.value = fresh; // 🔥 TRIGGERS OBX
    });

    _prodSub = _productionRepo
        .watchProductionEntries(o.id)
        .listen((list) {
      productions.assignAll(list);
      _rebuildTimeline();
    });

    _delSub = _deliveryRepo
        .watchByOrder(o.id)
        .listen((list) {
      deliveries.assignAll(list);
      _rebuildTimeline();
    });

    _expSub = _expenseRepo
        .watchByOrder(o.id)
        .listen((list) {
      expenses.assignAll(list);
      _rebuildTimeline();
    });
  }

  // ======================
  // TIMELINE MERGER 🔥
  // ======================
  void _rebuildTimeline() {
    final items = <OrderTimelineItem>[];

    for (final p in productions) {
      items.add(OrderTimelineItem(
        type: OrderTimelineType.production,
        date: p.productionDate,
        title: 'Produced ${p.quantityProducedToday} bottles',
        subtitle: p.notes,
        trailing: 'Total: ${p.cumulativeProduced}',
        icon: Icons.factory,
      ));
    }

    for (final d in deliveries) {
      items.add(OrderTimelineItem(
        type: OrderTimelineType.delivery,
        date: d.deliveryDate,
        title: 'Delivered ${d.quantityDeliveredToday} bottles',
        subtitle: d.notes,
        trailing: 'Total: ${d.cumulativeDelivered}',
        icon: Icons.local_shipping,
      ));
    }

    for (final e in expenses) {
      items.add(OrderTimelineItem(
        type: OrderTimelineType.expense,
        date: e.expenseDate,
        title: '${e.category} ₹${e.amount}',
        subtitle: DateFormat('d MMM hh:mm a').format(e.createdAt),
        trailing: e.status,
        icon: Icons.currency_rupee,
      ));
    }

    items.sort((a, b) => b.date.compareTo(a.date));
    timeline.assignAll(items);
  }

  // ======================
  // PRODUCTION
  // ======================
  Future<void> submitProduction() async {
    final o = order.value;
    if (o == null) return;

    final qty = producedToday.value;
    if (qty <= 0) {
      Get.snackbar('Invalid', 'Enter quantity produced');
      return;
    }

    final newTotal = o.producedQuantity + qty;
    if (newTotal > o.orderedQuantity) {
      Get.snackbar(
        'Invalid Quantity',
        'Production exceeds order quantity',
      );
      return;
    }

    isSaving.value = true;

    try {
      // ======================
      // 1️⃣ INVENTORY CHECK + DEDUCT 🔥
      // ======================

// 1️⃣ INVENTORY CHECK + DEDUCT (TRANSACTIONAL) 🔥
      final deltas = <String, int>{};

      void addDelta(String? id, int delta) {
        final key = (id ?? '').trim();
        if (key.isEmpty) return; // ✅ skip null / empty ids
        deltas[key] = (deltas[key] ?? 0) + delta;
      }

// bottles always
      addDelta(o.itemId, -qty);

// labels (if present AND non-empty)
      addDelta(o.labelItemId, -qty);

// caps (if present AND non-empty)
      addDelta(o.capItemId, -qty);

// packaging (if present AND non-empty)
      int? usedPacks;
      if ((o.packagingItemId ?? '').trim().isNotEmpty) {
        usedPacks = qty; // keep your simple version for now
        addDelta(o.packagingItemId, -usedPacks);
      }



// ✅ One atomic commit
      await _inventoryItemRepo.applyStockDeltasTransactional(itemDeltas: deltas);


      // ======================
      // 2️⃣ PRODUCTION ENTRY
      // ======================

      final entry = OrderProductionEntryModel(
        id: '',
        orderId: o.id,
        quantityProducedToday: qty,
        cumulativeProduced: newTotal,
        productionDate: DateTime.now(),
        notes: productionNotes.value,
        createdBy: 'admin',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _productionRepo.addProductionEntry(entry);

      // ======================
      // 3️⃣ UPDATE ORDER
      // ======================

      final newStatus =
      newTotal == o.orderedQuantity ? 'completed' : 'in_progress';

      await _ordersRepo.updateOrder(
        o.id,
        o.copyWith(
          producedQuantity: newTotal,
          productionStatus: newStatus,
          orderStatus: 'in_production',
          updatedAt: DateTime.now(),
        ).toMap(),
      );

      // ======================
      // 4️⃣ INVENTORY ACTIVITY LOG 🔥
      // ======================

      final now = DateTime.now();


      final cogsAmount = _calculateProductionCogs(
        o: o,
        qty: qty,
        inventory: _inventory,
      );

      final cogsExpense = OrderExpenseModel(
        id: '',
        orderId: o.id,
        clientId: o.clientId,
        direction: 'out',
        stage: 'production',
        category: 'cogs_inventory',
        description:
        'Inventory used for producing $qty bottles (Order ${o.orderNumber})',
        amount: cogsAmount,
        paidAmount: cogsAmount, // inventory is already paid for
        dueAmount: 0,
        vendorName: 'Inventory',
        referenceNo: null,
        expenseDate: DateTime.now(),
        status: 'paid',
        createdBy: 'system',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _expenseRepo.addExpense(cogsExpense);


// ======================
// BOTTLES 🔥
// ======================
      await _inventoryActivityRepo.addActivity(
        InventoryActivityModel(
          id: '',
          itemId: o.itemId,
          type: 'production_use',
          source: 'order',
          title: 'Production Consumption',
          description:
          'Used $qty bottles for Order ${o.orderNumber}',
          stockDelta: -qty,
          amount: null,
          unitCost: null,
          referenceId: o.id,
          referenceType: 'order_production',
          createdBy: 'admin',
          createdAt: now,
          isActive: true,
        ),
      );

// ======================
// LABELS 🔥
// ======================
      if (o.labelItemId != null) {
        await _inventoryActivityRepo.addActivity(
          InventoryActivityModel(
            id: '',
            itemId: o.labelItemId!,
            type: 'production_use',
            source: 'order',
            title: 'Label Consumption',
            description:
            'Used $qty labels for Order ${o.orderNumber}',
            stockDelta: -qty,
            amount: null,
            unitCost: null,
            referenceId: o.id,
            referenceType: 'order_production',
            createdBy: 'admin',
            createdAt: now,
            isActive: true,
          ),
        );
      }

// ======================
// CAPS 🔥
// ======================
      if (o.capItemId != null) {
        await _inventoryActivityRepo.addActivity(
          InventoryActivityModel(
            id: '',
            itemId: o.capItemId!,
            type: 'production_use',
            source: 'order',
            title: 'Cap Consumption',
            description:
            'Used $qty caps for Order ${o.orderNumber}',
            stockDelta: -qty,
            amount: null,
            unitCost: null,
            referenceId: o.id,
            referenceType: 'order_production',
            createdBy: 'admin',
            createdAt: now,
            isActive: true,
          ),
        );
      }

// ======================
// PACKAGING 🔥
// ======================

      if (o.packagingItemId != null) {
        final packs = usedPacks ?? qty; // usedPacks computed earlier in deltas block

        await _inventoryActivityRepo.addActivity(
          InventoryActivityModel(
            id: '',
            itemId: o.packagingItemId!,
            type: 'production_use',
            source: 'order',
            title: 'Packaging Consumption',
            description: 'Used $packs packaging units for Order ${o.orderNumber}',
            stockDelta: -packs,
            amount: null,
            unitCost: null,
            referenceId: o.id,
            referenceType: 'order_production',
            createdBy: 'admin',
            createdAt: now,
            isActive: true,
          ),
        );
      }


      await _activityRepo.addActivity(
        OrderActivityModel(
          id: '',
          orderId: o.id,
          clientId: o.clientId,
          type: 'production',
          title: 'Production Updated',
          description:
          'Produced $qty bottles (Total: $newTotal / ${o.orderedQuantity})',
          stage: 'production',
          activityDate: now,
          createdBy: 'admin',
          createdAt: now,
        ),
      );

      // ======================
      // 6️⃣ RESET UI
      // ======================

      producedToday.value = 0;
      productionNotes.value = '';

      Get.back();
      Get.snackbar('Success', 'Production updated');
    } catch (e, st) {
      debugPrint('❌ submitProduction FAILED');
      debugPrint('Error: $e');
      debugPrint('Stack: $st');

      final msg = (e is StateError) ? e.message : e.toString();

      // ✅ Web-safe: show snackbar AFTER frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Insufficient Stock',
          msg,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 6),
        );
      });
    }
    finally {
      isSaving.value = false;
    }
  }



  // ======================
  // DELIVERY 🔥
  // ======================
  Future<void> submitDelivery() async {
    final o = order.value;
    if (o == null) return;

    final qty = deliveredToday.value;

    if (qty <= 0) return;

    final newTotal = o.deliveredQuantity + qty;
    if (newTotal > o.orderedQuantity) {
      Get.snackbar('Invalid', 'Exceeds order qty');
      return;
    }

    final entry = OrderDeliveryEntryModel(
      id: '',
      orderId: o.id,
      quantityDeliveredToday: qty,
      cumulativeDelivered: newTotal,
      deliveryDate: DateTime.now(),
      notes: deliveryNotes.value,
      createdBy: 'admin',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _deliveryRepo.addDeliveryEntry(entry);

    final isComplete = newTotal == o.orderedQuantity;

    await _ordersRepo.updateOrder(
      o.id,
      o.copyWith(
        deliveredQuantity: newTotal,
        remainingQuantity: o.orderedQuantity - newTotal,
        deliveryStatus: isComplete ? 'completed' : 'partial',
        orderStatus: isComplete ? 'completed' : 'partially_delivered',
        updatedAt: DateTime.now(),
      ).toMap(),
    );

    // 🔥 ACTIVITY LOG
// 🔥 ACTIVITY LOG
    await _activityRepo.addActivity(
      OrderActivityModel(
        id: '',
        orderId: o.id,
        clientId: o.clientId,
        type: 'delivery',
        title: 'Delivery Updated',
        description:
        'Delivered $qty bottles (Total: $newTotal / ${o.orderedQuantity})',
        stage: 'delivery',
        activityDate: DateTime.now(),
        createdBy: 'admin',
        createdAt: DateTime.now(),
      ),
    );


    // 🔥 OPTIONAL: AUTO-MARK ORDER COMPLETE
    if (isComplete) {
      await _activityRepo.addActivity(
        OrderActivityModel(
          id: '',
          orderId: o.id,
          clientId: o.clientId,

          type: 'order_complete',
          title: 'Order Completed',
          description: 'Order fully delivered',
          stage: 'delivery',
          activityDate: DateTime.now(),
          createdBy: 'admin',
          createdAt: DateTime.now(),
        ),
      );
    }


    deliveredToday.value = 0;
    deliveryNotes.value = '';
  }

  // ======================
  // EXPENSE
  // ======================

  Future<void> submitExpense() async {
    final o = order.value;
    if (o == null) return;

    if (expenseAmount.value <= 0) {
      Get.snackbar('Invalid', 'Enter total expense');
      return;
    }

    if (paidAmount.value > expenseAmount.value) {
      Get.snackbar('Invalid', 'Paid cannot exceed total');
      return;
    }

    if (vendorName.value.isEmpty) {
      Get.snackbar('Invalid', 'Enter vendor name');
      return;
    }

    final due = expenseAmount.value - paidAmount.value;

    final status = paidAmount.value == 0
        ? 'unpaid'
        : paidAmount.value == expenseAmount.value
        ? 'paid'
        : 'partial';

    isSaving.value = true;

    try {
      final o = order.value!;

      final expense = OrderExpenseModel(
        id: '',
        orderId: o.id,
        clientId: o.clientId,
        direction: 'out', //
        stage: expenseStage.value,
        category: expenseCategory.value,
        description: expenseNotes.value,
        amount: expenseAmount.value,
        paidAmount: paidAmount.value,
        dueAmount: due,
        vendorName: vendorName.value,
        referenceNo:
        referenceNo.value.isEmpty ? null : referenceNo.value,
        expenseDate: DateTime.now(),
        status: status,
        createdBy: 'admin',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _expenseRepo.addExpense(expense);

      await _activityRepo.addActivity(
        OrderActivityModel(
          id: '',
          orderId: o.id,
          clientId: o.clientId,

          type: 'expense',
          title: 'Expense Added',
          description:
          '${expenseCategory.value} ₹${expenseAmount.value} '
              '(Paid ₹${paidAmount.value}, Due ₹$due)',
          stage: expenseStage.value,
          activityDate: DateTime.now(),
          createdBy: 'admin',
          createdAt: DateTime.now(),
        ),
      );

      _resetExpenseForm();

      Get.back();
      Get.snackbar('Success', 'Expense added');
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Failed to add expense ${e}');
    } finally {
      isSaving.value = false;
    }
  }





  void _resetExpenseForm() {
    expenseStage.value = 'production';
    expenseCategory.value = '';
    vendorName.value = '';
    expenseAmount.value = 0;
    paidAmount.value = 0;
    expenseDue.value = 0;
    referenceNo.value = '';
    expenseNotes.value = '';
  }



  double _calculateProductionCogs({
    required OrderModel o,
    required int qty,
    required InventoryController inventory,
  }) {
    double total = 0;

    void add(String? itemId, int quantity) {
      if (itemId == null || itemId.isEmpty || quantity <= 0) return;
      final cost = inventory.latestUnitCost(itemId); // you already have this logic
      total += cost * quantity;
    }

    add(o.itemId, qty);           // bottles
    add(o.labelItemId, qty);      // labels
    add(o.capItemId, qty);        // caps
    add(o.packagingItemId, qty);  // packaging

    return total;
  }



  Future<void> submitClientPayment() async {
    final o = order.value;
    if (o == null) return;

    final amount = paymentAmount.value;

    if (amount <= 0) {
      Get.snackbar('Invalid', 'Enter valid payment amount');
      return;
    }

    final newPaid = o.paidAmount + amount;

    if (newPaid > o.totalAmount) {
      Get.snackbar('Invalid', 'Payment exceeds order total');
      return;
    }

    final newDue = o.totalAmount - newPaid;

    isSaving.value = true;

    try {
      // 1️⃣ Ledger entry (money IN)
      final paymentExpense = OrderExpenseModel(
        id: '',
        orderId: o.id,
        clientId: o.clientId,
        stage: 'payment',
        direction: 'in', //
        category: 'client_payment',
        description: paymentNotes.value,
        amount: amount,
        paidAmount: amount,
        dueAmount: 0,
        vendorName: o.clientNameSnapshot,
        referenceNo:
        paymentRef.value.isEmpty ? null : paymentRef.value,
        expenseDate: DateTime.now(),
        status: 'paid',
        createdBy: 'admin',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _expenseRepo.addExpense(paymentExpense);

      // 2️⃣ Update order finance
      await _ordersRepo.updateOrder(
        o.id,
        o.copyWith(
          paidAmount: newPaid,
          dueAmount: newDue,
          updatedAt: DateTime.now(),
        ).toMap(),
      );

      // 3️⃣ Activity log
      await _activityRepo.addActivity(
        OrderActivityModel(
          id: '',
          orderId: o.id,
          clientId: o.clientId,
          type: 'payment',
          title: 'Client Payment',
          description: 'Received ₹$amount',
          stage: 'finance',
          activityDate: DateTime.now(),
          createdBy: 'admin',
          createdAt: DateTime.now(),
        ),
      );

      _resetPaymentForm();

      Get.back();
      Get.snackbar('Success', 'Payment added');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add payment');
    } finally {
      isSaving.value = false;
    }
  }


  void _resetPaymentForm() {
    paymentAmount.value = 0;
    paymentRef.value = '';
    paymentNotes.value = '';
  }






  void _reCalcDue() {
    final total = expenseAmount.value;
    final paid = paidAmount.value;

    expenseDue.value =
    total > paid ? total - paid : 0;
  }

  void setExpenseAmount(String v) {
    expenseAmount.value = double.tryParse(v) ?? 0;
    _reCalcDue();
  }

  void setPaidAmount(String v) {
    paidAmount.value = double.tryParse(v) ?? 0;
    _reCalcDue();
  }



  void setExpenseStage(String? v) {
    if (v == null) return;
    expenseStage.value = v;
  }

  void setExpenseCategory(String? v) {
    if (v == null) return;
    expenseCategory.value = v;
  }

  void setVendor(String v) {
    vendorName.value = v;
  }

  void setReferenceNo(String v) {
    referenceNo.value = v;
  }

  void setExpenseNotes(String v) {
    expenseNotes.value = v;
  }
  void setPaymentAmount(String v) {
    paymentAmount.value = double.tryParse(v) ?? 0;
  }

  void setPaymentRef(String v) {
    paymentRef.value = v;
  }

  void setPaymentNotes(String v) {
    paymentNotes.value = v;
  }


  // ======================
  // PROFIT CALCULATION 🔥
  // ======================
  double get totalExpenses =>
      expenses.fold(0, (s, e) => s + e.amount);


  double get revenueEarned {
    final o = order.value;
    if (o == null) return 0;

    return o.deliveredQuantity * o.ratePerBottle;
  }

  double get totalExpensesIncurred =>
      expenses
          .where((e) => e.direction == 'out')
          .fold(0, (s, e) => s + e.amount);

  double get totalExpensesPaid =>
      expenses
          .where((e) => e.direction == 'out')
          .fold(0, (s, e) => s + e.paidAmount);

  double get revenueCollected =>
      expenses
          .where((e) =>
      e.direction == 'in' &&
          e.category == 'client_payment')
          .fold(0, (s, e) => s + e.amount);

  double get profitAccrual =>
      revenueEarned - totalExpensesIncurred;

  double get cashFlow =>
      revenueCollected - totalExpensesPaid;



  @override
  void onClose() {
    _prodSub?.cancel();
    _delSub?.cancel();
    _expSub?.cancel();
    super.onClose();
  }
}


