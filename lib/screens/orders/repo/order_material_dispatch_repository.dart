// lib/screens/orders/repos/order_material_dispatch_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/firebase/audit_activity.dart';
import 'package:clwb_crm/screens/orders/models/order_material_dispatch_model.dart';

class OrderMaterialDispatchRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference get _ref => _db.collection('order_material_dispatch');

  Stream<List<OrderMaterialDispatchModel>> watchByOrder(String orderId) {
    return _ref
        .where('orderId', isEqualTo: orderId)
        .orderBy('dispatchDate', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => OrderMaterialDispatchModel.fromDoc(d)).toList());
  }

  Future<void> addDispatch(OrderMaterialDispatchModel dispatch) async {
    final doc = _ref.doc();

    await doc.set({
      ...dispatch.copyWith(id: doc.id).toMap(),
      ...Audit.created(),
    });
  }

  Future<void> updateDispatch(OrderMaterialDispatchModel dispatch) async {
    await _ref.doc(dispatch.id).update({
      ...dispatch.toMap(),
      ...Audit.updated(),
    });
  }

  Future<List<OrderMaterialDispatchModel>> getByOrder(String orderId) async {
    final snap = await _ref
        .where('orderId', isEqualTo: orderId)
        .orderBy('dispatchDate', descending: true)
        .get();

    return snap.docs.map((d) => OrderMaterialDispatchModel.fromDoc(d)).toList();
  }
}
