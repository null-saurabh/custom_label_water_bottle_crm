// lib/features/deliveries/delivery_controller.dart
import 'package:clwb_crm/screens/delivery/model/shipment_model.dart';
import 'package:clwb_crm/screens/orders/models/orderline_model.dart';
import 'package:get/get.dart';

class ProductionController extends GetxController {
  final inProgressLines = <OrderLineModel>[].obs;

  int get totalPendingLabelQty =>
      inProgressLines.fold(0, (sum, l) => sum + l.remainingToLabel);

  void addToProduction(OrderLineModel line) {
    inProgressLines.add(line);
  }
}



class DeliveryController extends GetxController {
  final shipments = <ShipmentModel>[].obs;

  void recordShipment(ShipmentModel shipment) {
    shipments.add(shipment);
  }
}
