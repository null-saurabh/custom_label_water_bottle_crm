import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/firebase/audit_activity.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_stock_add_model.dart';

class InventoryStockRepository {
  final _db = FirebaseFirestore.instance;
  CollectionReference get _ref => _db.collection('inventory_stocks');

  Stream<List<InventoryStockAddModel>> watchStockEntries() {
    return _ref
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => InventoryStockAddModel.fromDoc(d)).toList());
  }

  Stream<List<InventoryStockAddModel>> watchStockEntriesForItem(String itemId) {
    return _ref
        .where('itemId', isEqualTo: itemId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => InventoryStockAddModel.fromDoc(d)).toList());
  }

  Future<String> addStock(InventoryStockAddModel stock) async {
    final doc = _ref.doc();

    await doc.set({
      ...stock.copyWith(id: doc.id).toMap(),
      ...Audit.created(),
    });

    return doc.id;
  }

  Future<void> updateStockEntry(String id, Map<String, dynamic> data) {
    return _ref.doc(id).update({
      ...data,
      ...Audit.updated(),
    });
  }

  Future<void> deleteStockEntry(String id) {
    return _ref.doc(id).delete();
  }
}
