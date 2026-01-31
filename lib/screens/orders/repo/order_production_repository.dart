// lib/screens/orders/repos/order_production_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/firebase/audit_activity.dart';
import 'package:clwb_crm/screens/orders/models/order_production_entry_model.dart';

class OrderProductionRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference get _ref => _db.collection('order_production_entries');

  Stream<List<OrderProductionEntryModel>> watchByOrder(String orderId) {
    return _ref
        .where('orderId', isEqualTo: orderId)
        .orderBy('productionDate', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => OrderProductionEntryModel.fromDoc(d)).toList());
  }

  Future<void> addProductionEntry(OrderProductionEntryModel entry) async {
    final doc = _ref.doc();

    await doc.set({
      ...entry.copyWith(id: doc.id).toMap(),
      ...Audit.created(),
    });
  }

  Future<List<OrderProductionEntryModel>> getByOrder(String orderId) async {
    final snap = await _ref
        .where('orderId', isEqualTo: orderId)
        .orderBy('productionDate', descending: true)
        .get();

    return snap.docs.map((d) => OrderProductionEntryModel.fromDoc(d)).toList();
  }

  Stream<List<OrderProductionEntryModel>> watchProductionEntries(String orderId) {
    // keeping your old API too
    return watchByOrder(orderId);
  }
}
