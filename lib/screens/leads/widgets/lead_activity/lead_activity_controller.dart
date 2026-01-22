import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/leads/add_lead_model.dart';
import 'package:get/get.dart';

class LeadActivityController extends GetxController {
  final String leadId;
  LeadActivityController(this.leadId);

  final activities = <LeadActivity>[].obs;

  @override
  void onInit() {
    FirebaseFirestore.instance
        .collection('leads')
        .doc(leadId)
        .collection('activities')
        .orderBy('at', descending: true)
        .snapshots()
        .listen((s) {
      activities.assignAll(
        s.docs.map((d) => LeadActivity.fromMap(d.data())),
      );
    });
    super.onInit();
  }
}
