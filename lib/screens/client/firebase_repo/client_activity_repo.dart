import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/client/models/client_model.dart';

class ClientActivityRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> addActivity({
    required String clientId,
    required ClientActivity activity,
  }) async {
    await _db
        .collection('clients')
        .doc(clientId)
        .collection('activities')
        .doc(activity.id)
        .set({
      'type': activity.type.name,
      'title': activity.title,
      'note': activity.note,
      'userName': activity.userName,
      'at': Timestamp.fromDate(activity.at),
    });
  }

  Future<void> logClientCreated({
    required String clientId,
    required String userName,
  }) async {
    final activity = ClientActivity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: ClientActivityType.created,
      title: 'Client created',
      note: 'Client added from CRM',
      userName: userName,
      at: DateTime.now(),
    );

    await addActivity(
      clientId: clientId,
      activity: activity,
    );
  }
}
