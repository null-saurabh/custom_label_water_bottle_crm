import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/inventory/model/supplier_item_model.dart';

class SupplierItemRepository {
  final _db = FirebaseFirestore.instance;
  CollectionReference get _ref => _db.collection('supplier_items');

  Stream<List<SupplierItemModel>> watchItemsForSupplier(String supplierId) {
    return _ref.where('supplierId', isEqualTo: supplierId)
        .snapshots()
        .map((s) => s.docs.map((d) => SupplierItemModel.fromDoc(d)).toList());
  }

  Stream<List<SupplierItemModel>> watchSuppliersForItem(String itemId) {
    return _ref.where('itemId', isEqualTo: itemId)
        .snapshots()
        .map((s) => s.docs.map((d) => SupplierItemModel.fromDoc(d)).toList());
  }

  Future<void> upsertSupplierItem(SupplierItemModel model) {
    return _ref.doc(model.id).set(model.toMap(), SetOptions(merge: true));
  }

  Future<void> updatePrice(String id, double ratePerUnit) {
    return _ref.doc(id).update({'ratePerUnit': ratePerUnit});
  }

  Future<void> deleteSupplierItem(String id) {
    return _ref.doc(id).delete();
  }
}
