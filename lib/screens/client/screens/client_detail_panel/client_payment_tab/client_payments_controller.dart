import 'dart:async';
import 'package:get/get.dart';
import 'package:clwb_crm/screens/orders/models/order_expense_model.dart';
import 'package:clwb_crm/screens/orders/repo/order_expense_repository.dart';

class ClientPaymentsController extends GetxController {
  final String clientId;
  ClientPaymentsController(this.clientId);

  final isLoading = true.obs;

  final payments = <OrderExpenseModel>[].obs; // direction=in, category=client_payment

  final totalReceived = 0.0.obs;
  final totalCount = 0.obs;

  StreamSubscription? _sub;
  final OrderExpenseRepository _repo = OrderExpenseRepository();

  @override
  void onInit() {
    super.onInit();

    // REQUIRED: repo must support query by clientId
    _sub = _repo.watchClientPayments(clientId).listen((list) {
      payments.assignAll(list);
      _recompute(list);
      isLoading.value = false;
    });
  }

  void _recompute(List<OrderExpenseModel> list) {
    totalCount.value = list.length;
    totalReceived.value = list.fold<double>(0, (s, e) => s + e.amount);
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
