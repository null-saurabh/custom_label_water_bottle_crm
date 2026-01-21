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
}
