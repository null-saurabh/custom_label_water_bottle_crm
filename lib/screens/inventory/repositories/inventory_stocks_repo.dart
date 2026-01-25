import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_stock_add_model.dart';

class InventoryStockRepository {
  final _db = FirebaseFirestore.instance;
  CollectionReference get _ref => _db.collection('inventory_stocks');

  Stream<List<InventoryStockAddModel>> watchStockEntries() {
    return _ref.orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => InventoryStockAddModel.fromDoc(d)).toList());
  }

  Stream<List<InventoryStockAddModel>> watchStockEntriesForItem(String itemId) {
    return _ref.where('itemId', isEqualTo: itemId)
        .snapshots()
        .map((s) => s.docs.map((d) => InventoryStockAddModel.fromDoc(d)).toList());
  }

  Future<void> addStockEntry(InventoryStockAddModel entry) {
    return _ref.doc(entry.id).set(entry.toMap());
  }

  Future<void> updateStockEntry(String id, Map<String, dynamic> data) {
    return _ref.doc(id).update(data);
  }

  Future<void> deleteStockEntry(String id) {
    return _ref.doc(id).delete();
  }
}
