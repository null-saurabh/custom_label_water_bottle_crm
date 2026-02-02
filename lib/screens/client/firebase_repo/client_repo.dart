import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/firebase/audit_activity.dart';
import 'package:clwb_crm/screens/client/models/client_media.dart';
import 'package:clwb_crm/screens/client/models/client_model.dart';

class ClientRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference get _ref => _db.collection('clients');
  CollectionReference get ref => _db.collection('clients');

  Future<String> addClient(ClientModel client) async {
    final doc = await _ref.add({
      ...client.toJson(),
      ...Audit.created(),
      'lastActivityAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Stream<List<ClientModel>> watchClients() {
    return _ref
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (s) => s.docs
          .map((d) =>
          ClientModel.fromJson(d.data() as Map<String, dynamic>, id: d.id))
          .toList(),
    );
  }

  Future<void> updateClient({
    required String clientId,
    required Map<String, dynamic> data,
  }) async {
    await _ref.doc(clientId).update({
      ...data,
      ...Audit.updated(),
      'lastActivityAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteClient(String clientId) async {
    final ref = _ref.doc(clientId);

    final activities = await ref.collection('activities').get();
    for (final doc in activities.docs) {
      await doc.reference.delete();
    }

    final notes = await ref.collection('notes').get();
    for (final doc in notes.docs) {
      await doc.reference.delete();
    }

    await ref.delete();
  }




  Future<ClientModel> createClientWithLabels(ClientModel client) async {
    final batch = _db.batch();

    // 1️⃣ Create client doc ref (we already have the id now)
    final clientRef = _ref.doc();

    // 2️⃣ Create small label item
    final smallLabelRef = _db.collection('inventory_items').doc();
    batch.set(smallLabelRef, {
      'name': '${client.businessName} - S Label',
      'category': 'label',
      'stock': 0,
      'reorderLevel': 500,
      'isActive': true,
      ...Audit.created(),
    });

    // 3️⃣ Create large label item
    final largeLabelRef = _db.collection('inventory_items').doc();
    batch.set(largeLabelRef, {
      'name': '${client.businessName} - L Label',
      'category': 'label',
      'stock': 0,
      'reorderLevel': 500,
      'isActive': true,
      ...Audit.created(),
    });

    // 3.1️⃣ Create LABEL CONFIGS (THIS IS WHAT YOUR PANEL NEEDS)
    final labelConfigsRef = _db.collection('label_configs');

    batch.set(labelConfigsRef.doc(smallLabelRef.id), {
      'itemId': smallLabelRef.id,
      'widthMm': 0.0,          // put your real defaults if you have them
      'heightMm': 0.0,         // put your real defaults if you have them
      'material': 'n/a',       // or 'Paper' etc
      'isClientSpecific': true,
      'clientId': clientRef.id,
      ...Audit.created(),
    });

    batch.set(labelConfigsRef.doc(largeLabelRef.id), {
      'itemId': largeLabelRef.id,
      'widthMm': 0.0,
      'heightMm': 0.0,
      'material': 'n/a',
      'isClientSpecific': true,
      'clientId': clientRef.id,
      ...Audit.created(),
    });

    // 4️⃣ Attach labels to client
    final clientWithLabels = client.copyWith(
      labelSmallItemId: smallLabelRef.id,
      labelLargeItemId: largeLabelRef.id,
    );

    // 5️⃣ Create client doc
    batch.set(clientRef, {
      ...clientWithLabels.toJson(),
      ...Audit.created(),
      'lastActivityAt': FieldValue.serverTimestamp(),
    });

    // 6️⃣ Commit atomically
    await batch.commit();

    return clientWithLabels.copyWith(id: clientRef.id);
  }


  Future<void> updateGoogleMapsLink({
    required String clientId,
    required String locationId,
    required String googleMapsLink,
  }) async {
    final docRef = _ref.doc(clientId);
    final snap = await docRef.get();
    if (!snap.exists) return;

    final data = snap.data() as Map<String, dynamic>? ?? {};
    final List<dynamic> locations = (data['locations'] as List<dynamic>?) ?? [];

    final updatedLocations = locations.map((loc) {
      final m = Map<String, dynamic>.from(loc as Map);
      if ((m['locationId'] ?? '') == locationId) {
        m['googleMapsLink'] = googleMapsLink.trim(); // allow ""
      }
      return m;
    }).toList();

    await docRef.update({
      'locations': updatedLocations,
      ...Audit.updated(),
      'lastActivityAt': FieldValue.serverTimestamp(),
    });
  }



  Future<void> addClientMediaImages({
    required String clientId,
    required String field, // 'draftLabelImages' or 'businessPhotos'
    required List<ClientMediaImage> images,
  }) async {
    final ref = _ref.doc(clientId);
    await ref.update({
      'media.$field': FieldValue.arrayUnion(images.map((e) => e.toMap()).toList()),
      ...Audit.updated(),
      'lastActivityAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeClientMediaImage({
    required String clientId,
    required String field,
    required ClientMediaImage image,
  }) async {
    final ref = _ref.doc(clientId);
    await ref.update({
      'media.$field': FieldValue.arrayRemove([image.toMap()]),
      ...Audit.updated(),
      'lastActivityAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> setFinalizedLabelImage({
    required String clientId,
    required ClientMediaImage? image,
  }) async {
    final ref = _ref.doc(clientId);
    await ref.update({
      'media.finalizedLabelImage': image?.toMap(),
      ...Audit.updated(),
      'lastActivityAt': FieldValue.serverTimestamp(),
    });
  }




}
