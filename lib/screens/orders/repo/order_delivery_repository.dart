import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/orders/models/order_delivery_entry_model.dart';

class OrderDeliveryRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference get _ref =>
      _db.collection('order_delivery_entries');

  // 🔁 Watch delivery entries for an order
  Stream<List<OrderDeliveryEntryModel>> watchByOrder(
      String orderId,
      ) {
    return _ref
        .where('orderId', isEqualTo: orderId)
        .orderBy('deliveryDate', descending: true)
        .snapshots()
        .map(
          (s) => s.docs
          .map((d) =>
          OrderDeliveryEntryModel.fromDoc(d))
          .toList(),
    );
  }

  // ➕ Add delivery entry
  Future<void> addDeliveryEntry(
      OrderDeliveryEntryModel entry,
      ) async {
    final doc = _ref.doc();

    await doc.set(
      entry.copyWith(
        id: doc.id,
        updatedAt: DateTime.now(),
      ).toMap(),
    );
  }

  // 📄 Get all delivery entries (non-stream)
  Future<List<OrderDeliveryEntryModel>> getByOrder(
      String orderId,
      ) async {
    final snap = await _ref
        .where('orderId', isEqualTo: orderId)
        .orderBy('deliveryDate', descending: true)
        .get();

    return snap.docs
        .map((d) =>
        OrderDeliveryEntryModel.fromDoc(d))
        .toList();
  }
}
