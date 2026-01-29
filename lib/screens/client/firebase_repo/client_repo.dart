// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/client_model.dart';
//



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/client/models/client_location.dart';
import 'package:clwb_crm/screens/client/models/client_media.dart';
import '../models/client_model.dart';

class ClientRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference get _ref => _db.collection('clients');
  CollectionReference get ref => _db.collection('clients');

  Future<String> addClient(ClientModel client) async {
    final doc = await _ref.add(client.toJson());
    return doc.id;
  }

  Stream<List<ClientModel>> watchClients() {
    return _ref
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (s) => s.docs.map((d) => ClientModel.fromJson(d.data() as Map<String, dynamic>, id: d.id)).toList(),
    );
  }

  Future<void> updateClient({
    required String clientId,
    required Map<String, dynamic> data,
  }) async {
    await _ref.doc(clientId).update({
      ...data,
      'lastActivityAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteClient(String clientId) async {
    final ref = _ref.doc(clientId);

    final activities = await ref.collection('activities').get();
    for (final doc in activities.docs) {
      await doc.reference.delete();
    }

    await ref.delete();
  }


  Future<ClientModel> createClientWithLabels(
      ClientModel client,
      ) async {
    final batch = _db.batch();

    // 1️⃣ Create client doc ref
    final clientRef = _ref.doc();

    // 2️⃣ Create small label item
    final smallLabelRef =
    _db.collection('inventory_items').doc();

    final smallLabelData = {
      'name': '${client.businessName} - S Label',
      'category': 'label',
      'stock': 0,
      'reorderLevel': 500,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    batch.set(smallLabelRef, smallLabelData);

    // 3️⃣ Create large label item
    final largeLabelRef =
    _db.collection('inventory_items').doc();

    final largeLabelData = {
      'name': '${client.businessName} - L Label',
      'category': 'label',
      'stock': 0,
      'reorderLevel': 500,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    batch.set(largeLabelRef, largeLabelData);

    // 4️⃣ Attach labels to client
    final clientWithLabels = client.copyWith(
      labelSmallItemId: smallLabelRef.id,
      labelLargeItemId: largeLabelRef.id,
    );

    batch.set(
      clientRef,
      clientWithLabels.toJson(),
    );

    // 5️⃣ Commit atomically
    await batch.commit();

    return clientWithLabels.copyWith(id: clientRef.id);
  }



}






