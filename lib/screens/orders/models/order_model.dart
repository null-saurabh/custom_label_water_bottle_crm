import 'package:clwb_crm/screens/orders/models/orderline_model.dart';

class OrderModel {
  final String id;
  final String clientId;
  final DateTime dueDate;
  final List<OrderLineModel> lines;

  OrderModel({
    required this.id,
    required this.clientId,
    required this.dueDate,
    required this.lines,
  });
}