import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/orders/models/order_production_entry_model.dart';

class OrderProductionRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference get _ref =>
      _db.collection('order_production_entries');

  // 🔁 Watch production entries for an order
  Stream<List<OrderProductionEntryModel>> watchByOrder(
      String orderId,
      ) {
    return _ref
        .where('orderId', isEqualTo: orderId)
        .orderBy('productionDate', descending: true)
        .snapshots()
        .map(
          (s) => s.docs
          .map((d) =>
          OrderProductionEntryModel.fromDoc(d))
          .toList(),
    );
  }

  // ➕ Add production entry
  Future<void> addProductionEntry(
      OrderProductionEntryModel entry,
      ) async {
    final doc = _ref.doc();

    await doc.set(
      entry.copyWith(
        id: doc.id,
        updatedAt: DateTime.now(),
      ).toMap(),
    );
  }

  // 📄 Get all production entries (non-stream)
  Future<List<OrderProductionEntryModel>> getByOrder(
      String orderId,
      ) async {
    final snap = await _ref
        .where('orderId', isEqualTo: orderId)
        .orderBy('productionDate', descending: true)
        .get();

    return snap.docs
        .map((d) =>
        OrderProductionEntryModel.fromDoc(d))
        .toList();
  }

  Stream<List<OrderProductionEntryModel>> watchProductionEntries(String orderId) {
    return _ref
        .where('orderId', isEqualTo: orderId)
        .orderBy('productionDate', descending: true)
        .snapshots()
        .map((s) =>
        s.docs.map((d) => OrderProductionEntryModel.fromDoc(d)).toList());
  }

}
