import 'package:clwb_crm/screens/client/client_controller.dart';
import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:clwb_crm/screens/inventory/inventory_controller.dart';
import 'package:clwb_crm/screens/inventory/model/bottle_config.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_item_model.dart';
import 'package:clwb_crm/screens/orders/models/order_activity_model.dart';
import 'package:clwb_crm/screens/orders/models/order_expense_model.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/repo/order_activity_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_expense_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_repo.dart';
import 'package:get/get.dart';

class AddOrderController extends GetxController {
  final OrdersRepository _repo;
  final ClientsController _clients;
  final InventoryController _inventory;
  final OrderExpenseRepository _expenseRepo;
  final OrderActivityRepository _activityRepo;


  AddOrderController(
      this._repo,
      this._clients,
      this._inventory,
      this._expenseRepo, this._activityRepo,

      );

  // ======================
  // DATA SOURCES
  // ======================

  List<ClientModel> get clients => _clients.clients;

  List<InventoryItemModel> get bottleItems =>
      _inventory.items
          .where((i) => i.category == InventoryCategory.bottle)
          .toList();


  List<InventoryItemModel> get capItems =>
      _inventory.items
          .where((i) =>
      i.category == InventoryCategory.cap &&
          i.isActive)
          .toList();

  // ======================
  // FORM STATE
  // ======================

  final Rxn<ClientModel> selectedClient = Rxn();
  final Rxn<InventoryItemModel> selectedItem = Rxn();
  final Rxn<BottleConfig> selectedBottleConfig = Rxn();

  final Rxn<InventoryItemModel> selectedCap = Rxn();
  final Rxn<InventoryItemModel> resolvedLabel = Rxn();
  final Rxn<InventoryItemModel> resolvedPackaging = Rxn();


  final RxInt quantity = 0.obs;
  final RxDouble ratePerBottle = 0.0.obs;
  final RxBool isPriority = false.obs;
  final RxDouble advancePaid = 0.0.obs;

  final deliveryDate = Rxn<DateTime>();

  String? _generatedOrderNo;

  final RxBool isSaving = false.obs;


  final RxBool isRecurring = false.obs;
  final RxInt recurringIntervalDays = 0.obs;
  final RxString notes = ''.obs;



  @override
  void onInit() {
    super.onInit();

    final caps = _inventory.availableCaps;
    selectedCap.value = caps.firstWhereOrNull(
          (c) => c.name.toLowerCase().contains('white'),
    );

    resolvedPackaging.value =
        _inventory.defaultPackagingItem;


  }



  // ======================
  // SETTERS
  // ======================

  void setCapByName(String? name) {
    if (name == null) return;

    final cap = capItems.firstWhereOrNull(
          (c) => c.name == name,
    );

    if (cap == null) return;

    selectedCap.value = cap;
  }


  void toggleRecurring(bool v) => isRecurring.value = v;

  void setRecurringInterval(String v) =>
      recurringIntervalDays.value = int.tryParse(v) ?? 0;

  void setNotes(String v) => notes.value = v;



  void setAdvancePaid(String v) =>
      advancePaid.value = double.tryParse(v) ?? 0;


  void setQty(String v) =>
      quantity.value = int.tryParse(v) ?? 0;

  void setRate(String v) =>
      ratePerBottle.value = double.tryParse(v) ?? 0;

  void togglePriority(bool v) => isPriority.value = v;

  void setDeliveryDate(DateTime d) {
    deliveryDate.value = d;
    update();
  }

  void setClientByName(String? name) {
    // print("label 11");

    if (name == null) return;
    // print("label 111");

    final client =
    clients.firstWhereOrNull((c) => c.businessName == name);

    if (client == null) return;
    // print("label 12");

    selectedClient.value = client;

    // 🔥 reset old value
    resolvedLabel.value = null;

    if (selectedBottleConfig.value != null) {
      final label =
      _inventory.resolveLabelForClientAndBottle(
        client,
        selectedBottleConfig.value!,
      );

      resolvedLabel.value = label;
      // print("label $label");
    }
    // print("label ${resolvedLabel.value}");

  }


  Future<void> setItemByName(String? name) async {
    if (name == null) return;

    final item =
    bottleItems.firstWhereOrNull((i) => i.name == name);

    if (item == null) return;

    selectedItem.value = item;

    // 🔥 reset old value
    // print("label2 ${resolvedLabel.value}");

    resolvedLabel.value = null;


    // fetch bottle config
    final cfg = await _repo.getBottleConfig(item.id);
    selectedBottleConfig.value = cfg;

    if (cfg != null && selectedClient.value != null) {
      final label =
      _inventory.resolveLabelForClientAndBottle(
        selectedClient.value!,
        cfg,
      );

      resolvedLabel.value = label;
      // print("label3 $label");

    }
  }


  // ======================
  // SUBMIT (REAL DERIVATION)
  // ======================




  Future<void> submit() async {
    if (selectedClient.value == null ||
        selectedItem.value == null ||
        selectedBottleConfig.value == null ||
        quantity.value <= 0 ||
        ratePerBottle.value <= 0 ||
        deliveryDate == null) {
      Get.snackbar(
        'Invalid Input',
        'Please select client, bottle, quantity, rate and delivery date',
      );
      return;
    }

    final total = quantity.value * ratePerBottle.value;



    if (advancePaid.value < 0 ||
        advancePaid.value > total) {
      Get.snackbar(
        'Invalid Advance',
        'Advance must be between 0 and total amount',
      );
      return;
    }


    final client = selectedClient.value!;
    final bottle = selectedItem.value!;
    final cfg = selectedBottleConfig.value!;
    final label = resolvedLabel.value;
    final cap = selectedCap.value;
    final packaging = resolvedPackaging.value; // optional
    final paid = advancePaid.value;
    final due = total - paid;


    final bool recurring = isRecurring.value;
    final int? interval =
    recurring && recurringIntervalDays.value > 0
        ? recurringIntervalDays.value
        : null;

    final DateTime? nextRecurring =
    recurring && interval != null
        ? deliveryDate.value!.add(Duration(days: interval))
        : null;


    // ======================
    // MATERIAL VALIDATION
    // ======================

    if (label == null) {
      Get.snackbar(
        'Missing Label',
        'No label configured for this client',
      );
      return;
    }

    if (cap == null) {
      Get.snackbar(
        'Missing Cap',
        'Please select a cap',
      );
      return;
    }

    isSaving.value = true;

    try {
      _generatedOrderNo ??=
      await _repo.generateNextOrderNumber();


      final total = quantity.value * ratePerBottle.value;
      final paid = advancePaid.value;
      final due = total - paid;

      final order = OrderModel(
        id: '',

        clientId: client.id,
        clientNameSnapshot: client.businessName,

        orderNumber: _generatedOrderNo!,

        itemId: bottle.id,
        itemNameSnapshot: bottle.name,
        bottleSize: '${cfg.sizeMl}ml',
        packSize: cfg.packSize,

        labelItemId: label.id,
        labelNameSnapshot: label.name,

        capItemId: cap.id,
        capNameSnapshot: cap.name,

        packagingItemId: packaging?.id,
        packagingNameSnapshot: packaging?.name,

        orderedQuantity: quantity.value,
        producedQuantity: 0,
        deliveredQuantity: 0,
        remainingQuantity: quantity.value,

        ratePerBottle: ratePerBottle.value,
        totalAmount: total,
        paidAmount: paid,
        dueAmount: due,

        orderStatus: 'pending',
        productionStatus: 'not_started',
        deliveryStatus: 'pending',

        expectedProductionStartDate: DateTime.now(),
        expectedDeliveryDate: deliveryDate.value,
        nextDeliveryDate: deliveryDate.value,

        isRecurring: recurring,
        recurringIntervalDays: interval,
        lastRecurringGeneratedAt: null,
        nextRecurringDate: nextRecurring,
        recurringParentOrderId: null,

        notes: notes.value.trim().isEmpty
            ? null
            : notes.value.trim(),

        isPriority: isPriority.value,
        createdBy: 'admin',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isActive: true,
      );

      final createdOrder =
      await _repo.createOrder(order);

      await _activityRepo.addActivity(
        OrderActivityModel(
          id: '',
          orderId: createdOrder.id,
          clientId: createdOrder.clientId,
          type: 'created',
          title: 'Order Created',
          description:
          'Order ${createdOrder.orderNumber} created for ${client.businessName}',
          stage: 'order',
          activityDate: DateTime.now(),
          createdBy: 'admin',
          createdAt: DateTime.now(),
        ),
      );


// 🔥 LOG ADVANCE PAYMENT
      if (paid > 0) {
        final expense = OrderExpenseModel(
          id: '',
          orderId: createdOrder.id,
          clientId: order.clientId,

          direction: 'in',

          stage: 'order_created',
          category: 'client_payment',
          description: 'Advance payment received',

          amount: paid,
          paidAmount: paid,
          dueAmount: 0,

          vendorName: client.businessName,
          referenceNo: 'ADV-${_generatedOrderNo!}',

          expenseDate: DateTime.now(),
          status: 'paid',

          createdBy: 'admin',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _expenseRepo.addExpense(expense);
      }


// 🔥 UPDATE CLIENT STATS
      await _clients.repo.updateClient(
        clientId: client.id,
        data: {
          'lastOrderDate': DateTime.now(),
          'totalOrders': (client.totalOrders ?? 0) + 1,
        },
      );



      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create order',
      );
    } finally {
      isSaving.value = false;
    }
  }

}
