import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/firebase/audit_activity.dart';
import 'package:clwb_crm/screens/inventory/model/inventory_activity_model.dart';

class InventoryActivityRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference _ref(String itemId) => _db
      .collection('inventory_items')
      .doc(itemId)
      .collection('activities');

  Stream<List<InventoryActivityModel>> watchActivities(String itemId) {
    return _ref(itemId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) =>
        s.docs.map((d) => InventoryActivityModel.fromDoc(d)).toList());
  }

  Future<void> addActivity(InventoryActivityModel activity) async {
    final doc = _ref(activity.itemId).doc();

    await doc.set({
      ...activity.copyWith(id: doc.id).toMap(),
      ...Audit.created(), // createdBy + updatedBy + server timestamps
    });
  }
}
