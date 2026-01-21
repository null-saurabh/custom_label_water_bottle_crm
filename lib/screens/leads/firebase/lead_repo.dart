import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/leads/add_lead_model.dart';

class LeadRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference get _ref => _db.collection('leads');

  Future<String> addLead(LeadModel lead) async {
    final doc = await _ref.add(lead.toMap());
    return doc.id;
  }

  Stream<List<LeadModel>> watchLeads() {
    return _ref
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map(LeadModel.fromDoc).toList());
  }


  Future<void> deleteLead(String leadId) async {
    final leadRef = _db.collection('leads').doc(leadId);

    // delete activities subcollection
    final activities = await leadRef.collection('activities').get();
    for (final doc in activities.docs) {
      await doc.reference.delete();
    }

    // delete lead
    await leadRef.delete();
  }


  Future<void> updateLead({
    required String leadId,
    required Map<String, dynamic> data,
  }) async {
    await _db.collection('leads').doc(leadId).update({
      ...data,
      'lastActivityAt': FieldValue.serverTimestamp(),
    });
  }

  

  Future<void> updateLeadStatus({
    required String leadId,
    required LeadStatus status,
  }) async {
    await _db.collection('leads').doc(leadId).update({
      'status': status.name,
      'lastActivityAt': FieldValue.serverTimestamp(),
    });
  }


  Future<void> updateFollowUpNote({
    required String leadId,
    required String note,
  }) async {
    await _db.collection('leads').doc(leadId).update({
      'followUpNotes': note,
      'lastActivityAt': FieldValue.serverTimestamp(),
    });
  }





}
