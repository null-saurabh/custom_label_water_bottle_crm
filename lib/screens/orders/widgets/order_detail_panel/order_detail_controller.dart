import 'dart:async';
import 'package:clwb_crm/screens/orders/models/order_activity_model.dart';
import 'package:clwb_crm/screens/orders/models/order_delivery_entry_model.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/models/order_production_entry_model.dart';
import 'package:clwb_crm/screens/orders/repo/order_activity_repository.dart';
import 'package:clwb_crm/screens/orders/repo/order_repo.dart';
import 'package:get/get.dart';

class OrderDetailController extends GetxController {
  final OrdersRepository _repo;
  final OrderActivityRepository _activityRepo;


  OrderDetailController(this._repo,    this._activityRepo,);

  final Rxn<OrderModel> order = Rxn<OrderModel>();
  final RxList<OrderProductionEntryModel> production =
      <OrderProductionEntryModel>[].obs;
  final RxList<OrderDeliveryEntryModel> delivery =
      <OrderDeliveryEntryModel>[].obs;
  final RxList<OrderActivityModel> activities =
      <OrderActivityModel>[].obs;

  StreamSubscription? _orderSub;
  StreamSubscription? _prodSub;
  StreamSubscription? _delSub;
  StreamSubscription? _actSub;

  // ======================
  // BIND / CLEAR
  // ======================

  void bindOrder(String orderId) {
    clear();

    _orderSub =
        _repo.watchOrderById(orderId).listen((o) {
          order.value = o;
        });

    _prodSub = _repo
        .watchProductionEntries(orderId)
        .listen((list) => production.assignAll(list));

    _delSub = _repo
        .watchDeliveryEntries(orderId)
        .listen((list) => delivery.assignAll(list));

    _actSub = _activityRepo
        .watchByOrder(orderId)
        .listen(activities.assignAll);

    // _actSub = _repo
    //     .watchActivities(orderId)
    //     .listen((list) => activities.assignAll(list));
  }

  void clear() {
    order.value = null;
    production.clear();
    delivery.clear();
    activities.clear();

    _orderSub?.cancel();
    _prodSub?.cancel();
    _delSub?.cancel();
    _actSub?.cancel();
  }

  @override
  void onClose() {
    clear();
    super.onClose();
  }
}
