import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';

abstract class OrderRepository {
  Stream<List<OrderModel>> watchOrders();
}

class FirebaseOrderRepository implements OrderRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _ref =>
      _db.collection('orders');

  @override
  Stream<List<OrderModel>> watchOrders() {
    return _ref.snapshots().map(
          (s) => s.docs.map((d) => OrderModel.fromDoc(d)).toList(),
    );
  }
}
