import 'dart:async';
import 'package:clwb_crm/core/utils/generate_invoice_with_payment.dart';
import 'package:clwb_crm/core/utils/generate_invoice_without_payment.dart';
import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_order_tab/client_orders_tab.dart';
import 'package:get/get.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:clwb_crm/screens/orders/repo/order_repo.dart';

class ClientOrdersController extends GetxController {
  final String clientId;
  ClientOrdersController(this.clientId);

  final isLoading = true.obs;
  final orders = <OrderModel>[].obs;

  // quick stats
  final totalOrders = 0.obs;
  final activeOrders = 0.obs;
  final deliveredOrders = 0.obs;
  final totalBilled = 0.0.obs; // sum totalAmount
  final totalPaid = 0.0.obs;   // sum paidAmount
  final totalDue = 0.0.obs;    // sum dueAmount

  StreamSubscription? _sub;
  final OrdersRepository _ordersRepo = Get.find<OrdersRepository>();

  @override
  void onInit() {
    super.onInit();

    _sub = _ordersRepo.watchOrdersByClient(clientId).listen((list) {
      orders.assignAll(list);
      _recompute(list);
      isLoading.value = false;
    });
  }

  void _recompute(List<OrderModel> list) {
    totalOrders.value = list.length;

    deliveredOrders.value = list.where((o) {
      final fullyDelivered = o.deliveredQuantity >= o.orderedQuantity;
      return o.orderStatus == 'completed' || fullyDelivered;
    }).length;

    activeOrders.value = list.where((o) => o.orderStatus != 'completed').length;

    totalBilled.value = list.fold<double>(0, (s, o) => s + o.totalAmount);
    totalPaid.value = list.fold<double>(0, (s, o) => s + o.paidAmount);
    totalDue.value = list.fold<double>(0, (s, o) => s + (o.dueAmount > 0 ? o.dueAmount : 0));
  }




  final RxBool isGeneratingInvoice = false.obs;
  Future<void> generateInvoiceWithoutPaymentPdf({
    required OrderModel order,
    required ClientModel client,
  }) async {
    if (isGeneratingInvoice.value) return;

    isGeneratingInvoice.value = true;

    // 🔥 allow UI to repaint before browser dialog blocks
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      await OrderInvoiceWithoutPaymentPdfService.generate(
        order: order,
        client: client,
      );
    } finally {
      isGeneratingInvoice.value = false;
    }
  }


  Future<void> generateInvoiceWithPaymentPdf({
    required OrderModel order,
    required ClientModel client,
  }) async {
    if (isGeneratingInvoice.value) return;

    isGeneratingInvoice.value = true;

    // 🔥 allow UI to repaint before browser dialog blocks
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      await OrderInvoiceWithPaymentPdfService.generate(
        order: order,
        client: client,
      );
    } finally {
      isGeneratingInvoice.value = false;
    }
  }


  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
