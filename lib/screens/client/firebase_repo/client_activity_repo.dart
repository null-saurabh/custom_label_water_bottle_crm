import 'package:cloud_firestore/cloud_firestore.dart';

class ClientActivityRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> addActivity({
    required String clientId,
    required Map<String, dynamic> activity,
  }) async {
    await _db
        .collection('clients')
        .doc(clientId)
        .collection('activities')
        .doc(activity['id'])
        .set(activity);
  }

  Future<void> logNote({
    required String clientId,
    required String note,
  }) async {
    await addActivity(
      clientId: clientId,
      activity: {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'type': 'note',
        'title': 'Note added',
        'note': note,
        'at': DateTime.now(),
      },
    );
  }
}
