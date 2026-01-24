import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_item_model.dart';
class InventoryItemRepository {


  final _db = FirebaseFirestore.instance;

  CollectionReference get _ref => _db.collection('inventory_items');

  Stream<List<InventoryItemModel>> watchItems() {
    return _ref.snapshots().map(
          (s) => s.docs.map((d) => InventoryItemModel.fromDoc(d)).toList(),
    );
  }

  Stream<InventoryItemModel?> watchItemById(String itemId) {
    return _ref.doc(itemId).snapshots().map(
          (d) => d.exists ? InventoryItemModel.fromDoc(d) : null,
    );
  }

  Future<void> addItem(InventoryItemModel item) {
    return _ref.doc(item.id).set(item.toMap());
  }

  Future<void> updateItem(String itemId, Map<String, dynamic> data) {
    return _ref.doc(itemId).update(data);
  }

  Future<void> deactivateItem(String itemId) {
    return _ref.doc(itemId).update({'isActive': false});
  }

  Future<void> deleteItem(String itemId) {
    return _ref.doc(itemId).delete();
  }

  Future<void> incrementStock(String itemId, int qty) {
    return _ref.doc(itemId).update({
      'stock': FieldValue.increment(qty),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> decrementStock(String itemId, int qty) {
    return _ref.doc(itemId).update({
      'stock': FieldValue.increment(-qty),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
