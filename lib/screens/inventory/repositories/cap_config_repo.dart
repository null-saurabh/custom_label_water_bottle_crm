import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/firebase/audit_activity.dart';
import 'package:clwb_crm/screens/inventory/model/cap_config.dart';

class CapConfigRepository {
  final _db = FirebaseFirestore.instance;
  CollectionReference get _ref => _db.collection('cap_configs');

  Stream<CapConfig?> watchConfig(String itemId) {
    return _ref.doc(itemId).snapshots().map(
          (d) => d.exists ? CapConfig.fromDoc(d) : null,
    );
  }

  Future<void> addConfig(CapConfig config) {
    return _ref.doc(config.itemId).set({
      ...config.toMap(),
      ...Audit.created(),
    });
  }

  Future<void> updateConfig(String itemId, Map<String, dynamic> data) {
    return _ref.doc(itemId).update({
      ...data,
      ...Audit.updated(),
    });
  }

  Future<void> deleteConfig(String itemId) {
    return _ref.doc(itemId).delete();
  }
}
