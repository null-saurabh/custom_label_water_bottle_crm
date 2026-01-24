import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_activity_model.dart';

class InventoryActivityRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference _ref(String itemId) =>
      _db.collection('inventory_items')
          .doc(itemId)
          .collection('activities');

  Stream<List<InventoryActivityModel>> watchActivities(String itemId) {
    return _ref(itemId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => InventoryActivityModel.fromDoc(d)).toList());
  }

  Future<void> addActivity({
    required String itemId,
    required String title,
    required String description,
    int? stockDelta,
    double? amount,
  }) {
    return _ref(itemId).add({
      'title': title,
      'description': description,
      'stockDelta': stockDelta,
      'amount': amount,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
