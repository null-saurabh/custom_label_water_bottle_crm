import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:get/get.dart';

class ClientActivityController extends GetxController {
  final String clientId;

  ClientActivityController(this.clientId);

  final activities = <ClientActivity>[].obs;

  @override
  void onInit() {
    FirebaseFirestore.instance
        .collection('clients')
        .doc(clientId)
        .collection('activities')
        .orderBy('at', descending: true)
        .snapshots()
        .listen((s) {
      print(
        'ClientActivityController(${clientId}) fetched: ${s.docs.length}',
      );


      activities.assignAll(
        s.docs.map(
              (d) => ClientActivity.fromDoc(d.data(), d.id),
        ),
      );
    });

    super.onInit();
  }
}
