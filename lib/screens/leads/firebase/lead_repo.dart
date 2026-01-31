import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/firebase/audit_activity.dart';
import 'package:clwb_crm/screens/leads/add_lead_model.dart';

class LeadRepository {
  final _db = FirebaseFirestore.instance;
  CollectionReference get _ref => _db.collection('leads');

  Future<String> addLead(LeadModel lead) async {
    final doc = await _ref.add({
      ...lead.toMap(),
      ...Audit.created(),
      'lastActivityAt': FieldValue.serverTimestamp(),
    });
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

    final activities = await leadRef.collection('activities').get();
    for (final doc in activities.docs) {
      await doc.reference.delete();
    }
    await leadRef.delete();
  }

  Future<void> updateLead({
    required String leadId,
    required Map<String, dynamic> data,
  }) async {
    await _db.collection('leads').doc(leadId).update({
      ...data,
      ...Audit.updated(),
      'lastActivityAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateStage({
    required String leadId,
    required LeadStage stage,
  }) async {
    await _db.collection('leads').doc(leadId).update({
      'stage': stage.name,
      ...Audit.updated(),
      'lastActivityAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateNextFollowUp({
    required String leadId,
    required DateTime? nextAt,
    required String note,
  }) async {
    await _db.collection('leads').doc(leadId).update({
      'nextFollowUpAt': nextAt == null ? null : Timestamp.fromDate(nextAt),
      'nextFollowUpNote': note,
      ...Audit.updated(),
      'lastActivityAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> markContactedNow({
    required String leadId,
  }) async {
    await _db.collection('leads').doc(leadId).update({
      'lastContactedAt': FieldValue.serverTimestamp(),
      ...Audit.updated(),
      'lastActivityAt': FieldValue.serverTimestamp(),
    });
  }

  /// One-way conversion marker (actual client creation can be done elsewhere)
  Future<void> markConverted({
    required String leadId,
    required String clientId,
  }) async {
    await _db.collection('leads').doc(leadId).update({
      'stage': LeadStage.convertedToClient.name,
      'convertedClientId': clientId,
      'convertedAt': FieldValue.serverTimestamp(),
      ...Audit.updated(),
      'lastActivityAt': FieldValue.serverTimestamp(),
      'nextFollowUpAt': null,
      'nextFollowUpNote': '',
    });
  }
}
