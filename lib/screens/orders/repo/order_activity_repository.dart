// lib/screens/orders/repos/order_activity_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/firebase/audit_activity.dart';
import 'package:clwb_crm/screens/orders/models/order_activity_model.dart';

class OrderActivityRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference get _ref => _db.collection('order_activities');

  Stream<List<OrderActivityModel>> watchByOrder(String orderId) {
    return _ref
        .where('orderId', isEqualTo: orderId)
        .orderBy('activityDate', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => OrderActivityModel.fromDoc(d)).toList());
  }

  Future<void> addActivity(OrderActivityModel activity) async {
    final doc = _ref.doc();

    await doc.set({
      ...activity.copyWith(id: doc.id).toMap(),
      ...Audit.created(),
    });
  }
}
