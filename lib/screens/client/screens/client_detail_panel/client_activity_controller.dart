import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:get/get.dart';

class ClientActivityController extends GetxController {
  final String clientId;

  ClientActivityController(this.clientId);

  final activities = <ClientActivity>[].obs;

  @override
  void onInit() {
    super.onInit();

    FirebaseFirestore.instance
        .collection('order_activities')
        .where('clientId', isEqualTo: clientId)
        .orderBy('activityDate', descending: true)
        .limit(50)
        .snapshots()
        .listen((s) {
      activities.assignAll(
        s.docs.map((d) => ClientActivity.fromOrderActivityDoc(d)).toList(),
      );
    });
  }


}
