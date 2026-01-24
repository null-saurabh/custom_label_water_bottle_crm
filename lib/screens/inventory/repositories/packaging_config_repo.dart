import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/inventory/model/package_config.dart';

class PackagingConfigRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference get _ref => _db.collection('packaging_configs');

  Stream<PackagingConfig?> watchConfig(String itemId) {
    return _ref.doc(itemId).snapshots().map(
          (d) => d.exists ? PackagingConfig.fromDoc(d) : null,
    );
  }

  Future<void> addConfig(PackagingConfig config) {
    return _ref.doc(config.itemId).set(config.toMap());
  }

  Future<void> updateConfig(String itemId, Map<String, dynamic> data) {
    return _ref.doc(itemId).update(data);
  }

  Future<void> deleteConfig(String itemId) {
    return _ref.doc(itemId).delete();
  }
}
