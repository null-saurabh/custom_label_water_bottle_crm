// lib/features/leads/data/repositories/lead_activity_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/leads/add_lead_model.dart';

class LeadActivityRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> addActivity(
      String leadId,
      LeadActivity activity,
      ) async {
    await _db
        .collection('leads')
        .doc(leadId)
        .collection('activities')
        .doc(activity.id)
        .set(activity.toMap());
  }
}
