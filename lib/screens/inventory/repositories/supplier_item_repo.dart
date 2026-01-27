import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/inventory/model/supplier_item_model.dart';

class SupplierItemRepository {
  final _db = FirebaseFirestore.instance;
  CollectionReference get _ref => _db.collection('supplier_items');

  /// 🔥 REQUIRED for inventory aggregation
  Stream<List<SupplierItemModel>> watchAll() {
    return _ref.snapshots().map(
      (s) => s.docs.map((d) => SupplierItemModel.fromDoc(d)).toList(),
    );
  }

  Stream<List<SupplierItemModel>> watchItemsForSupplier(String supplierId) {
    return _ref
        .where('supplierId', isEqualTo: supplierId)
        .snapshots()
        .map((s) => s.docs.map((d) => SupplierItemModel.fromDoc(d)).toList());
  }

  Future<SupplierItemModel?> findSupplierItem({
    required String supplierId,
    required String itemId,
  }) async {
    final q = await _ref
        .where('supplierId', isEqualTo: supplierId)
        .where('itemId', isEqualTo: itemId)
        .limit(1)
        .get();

    if (q.docs.isEmpty) return null;
    return SupplierItemModel.fromDoc(q.docs.first);
  }

  Stream<List<SupplierItemModel>> watchSuppliersForItem(String itemId) {
    return _ref
        .where('itemId', isEqualTo: itemId)
        .snapshots()
        .map((s) => s.docs.map((d) => SupplierItemModel.fromDoc(d)).toList());
  }


  Future<String> addSupplierItem(SupplierItemModel model) async {
    final doc = _ref.doc();

    await doc.set(
      model.copyWith(id: doc.id).toMap(),
    );

    return doc.id;
  }


  Future<void> upsertSupplierItem(SupplierItemModel model) {
    return _ref.doc(model.id).set(model.toMap(), SetOptions(merge: true));
  }
  Future<void> updatePrice(String id, double costPerUnit) {
    return _ref.doc(id).update({'costPerUnit': costPerUnit});
  }


  Future<void> deleteSupplierItem(String id) {
    return _ref.doc(id).delete();
  }
}
