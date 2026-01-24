import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/inventory/model/supplier_model.dart';

class SupplierRepository {
  final _db = FirebaseFirestore.instance;
  CollectionReference get _ref => _db.collection('suppliers');

  Stream<List<SupplierModel>> watchSuppliers() {
    return _ref.snapshots().map(
          (s) => s.docs.map((d) => SupplierModel.fromDoc(d)).toList(),
    );
  }

  Stream<SupplierModel?> watchSupplierById(String id) {
    return _ref.doc(id).snapshots().map(
          (d) => d.exists ? SupplierModel.fromDoc(d) : null,
    );
  }

  Future<void> addSupplier(SupplierModel supplier) {
    return _ref.doc(supplier.id).set(supplier.toMap());
  }

  Future<void> updateSupplier(String id, Map<String, dynamic> data) {
    return _ref.doc(id).update(data);
  }

  Future<void> deactivateSupplier(String id) {
    return _ref.doc(id).update({'isActive': false});
  }

  Future<void> deleteSupplier(String id) {
    return _ref.doc(id).delete();
  }
}
