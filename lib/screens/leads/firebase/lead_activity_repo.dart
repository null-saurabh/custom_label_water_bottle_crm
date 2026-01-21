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


  Future<void> logStatusChange({
    required String leadId,
    required LeadStatus status,
  }) async {
    final activity = LeadActivity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: LeadActivityType.statusChanged,
      title: 'Status Changed',
      note: 'Status changed to ${status.name}',
      at: DateTime.now(),
    );

    await addActivity(leadId, activity);
  }





  Future<void> logFollowUp({
    required String leadId,
    required String note,
  }) async {
    final activity = LeadActivity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: LeadActivityType.followUp,
      title: 'Follow-up Added',
      note: note,
      at: DateTime.now(),
    );

    await addActivity(leadId, activity);
  }





}
