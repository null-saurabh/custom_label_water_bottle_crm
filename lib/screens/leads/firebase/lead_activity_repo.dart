import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/firebase/audit_activity.dart';
import 'package:clwb_crm/screens/leads/add_lead_model.dart';

class LeadActivityRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> addActivity(String leadId, LeadActivity activity) async {
    await _db
        .collection('leads')
        .doc(leadId)
        .collection('activities')
        .doc(activity.id)
        .set({
      ...activity.toMap(),
      ...Audit.created(), // stamp who logged this activity
    });

    // keep lead lastActivityAt in sync (cheap + useful)
    await _db.collection('leads').doc(leadId).update({
      'lastActivityAt': FieldValue.serverTimestamp(),
      ...Audit.updated(),
    });
  }

  Future<void> logStatusChange({
    required String leadId,
    required LeadStage stage,
    required String userId,
    required String userName,
  }) async {
    await addActivity(
      leadId,
      LeadActivity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: LeadActivityType.statusChanged,
        title: 'Stage changed',
        note: 'Stage changed to ${stage.name}',
        userId: userId,
        userName: userName,
        at: DateTime.now(),
        meta: {'stage': stage.name},
      ),
    );
  }

  Future<void> logFollowUpScheduled({
    required String leadId,
    required DateTime? nextAt,
    required String note,
    required String userId,
    required String userName,
  }) async {
    await addActivity(
      leadId,
      LeadActivity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: LeadActivityType.followUpScheduled,
        title: 'Follow-up scheduled',
        note: note.isEmpty ? '(no note)' : note,
        userId: userId,
        userName: userName,
        at: DateTime.now(),
        meta: {
          'nextFollowUpAt': nextAt == null ? null : Timestamp.fromDate(nextAt),
        },
      ),
    );
  }

  Future<void> logCallMade({
    required String leadId,
    required String phone,
    required String userId,
    required String userName,
  }) async {
    await addActivity(
      leadId,
      LeadActivity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: LeadActivityType.callMade,
        title: 'Call initiated',
        note: 'Call initiated to $phone',
        userId: userId,
        userName: userName,
        at: DateTime.now(),
        meta: {'phone': phone},
      ),
    );
  }

  Future<void> logInternalNote({
    required String leadId,
    required String note,
    required String userId,
    required String userName,
  }) async {
    await addActivity(
      leadId,
      LeadActivity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: LeadActivityType.internalNote,
        title: 'Note',
        note: note,
        userId: userId,
        userName: userName,
        at: DateTime.now(),
        meta: {},
      ),
    );
  }
}
