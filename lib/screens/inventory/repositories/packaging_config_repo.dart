import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/firebase/audit_activity.dart';
import 'package:clwb_crm/screens/inventory/model/package_config.dart';

class PackagingConfigRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference get _ref => _db.collection('packaging_configs');

  Stream<PackagingConfig?> watchConfig(String itemId) {
    return _ref.doc(itemId).snapshots().map(
          (d) => d.exists ? PackagingConfig.fromDoc(d) : null,
    );
  }

  Future<PackagingConfig?> getConfig(String itemId) async {
    final d = await _ref.doc(itemId).get();
    if (!d.exists) return null;
    return PackagingConfig.fromDoc(d);
  }

  Future<void> addConfig(PackagingConfig config) {
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
