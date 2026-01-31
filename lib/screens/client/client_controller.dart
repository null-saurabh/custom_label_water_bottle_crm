import 'package:clwb_crm/screens/client/firebase_repo/client_repo.dart';
import 'package:clwb_crm/screens/client/models/client_location.dart';
import 'package:clwb_crm/screens/client/models/client_media.dart';
import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_activity_controller.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/notes_widget/client_notes_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ClientFilter {
  all,
  active,
  inactive,
  priority,
}


class ClientsController extends GetxController {
  final repo = ClientRepository();

  final clients = <ClientModel>[].obs;

  // UI state
  // final selectedFilter = Rxn<String>(); // active / inactive / priority

  final selectedFilter = ClientFilter.all.obs;

  final searchQuery = ''.obs;
  final searchCtrl = TextEditingController();

  void setSearch(String v) {
    searchQuery.value = v;

    if (searchCtrl.text != v) {
      searchCtrl.value = searchCtrl.value.copyWith(
        text: v,
        selection: TextSelection.collapsed(offset: v.length),
        composing: TextRange.empty,
      );
    }
  }

  final selectedClientId = RxnString();



  @override
  void onInit() {

    repo.watchClients().listen(clients.assignAll);
    super.onInit();

    selectedClientId.value = null;
  }

  void selectClient(String clientId) {
    // 🔥 DELETE OLD ACTIVITY CONTROLLER
    if (selectedClientId.value != null &&
        selectedClientId.value != clientId) {
      if (Get.isRegistered<ClientActivityController>(
        tag: selectedClientId.value!,
      )) {
        Get.delete<ClientActivityController>(
          tag: selectedClientId.value!,
        );
      }
      if (Get.isRegistered<ClientNotesController>(tag: selectedClientId.value!)) {
        Get.delete<ClientNotesController>(tag: selectedClientId.value!);
      }

    }

    // ✅ SET NEW CLIENT
    selectedClientId.value = clientId;

    // ✅ CREATE NEW CONTROLLER
    Get.put(
      ClientActivityController(clientId),
      tag: clientId,
    );
  }


  ClientModel? get selectedClient =>
      clients.firstWhereOrNull((c) => c.id == selectedClientId.value);



  /// STEP 1: filter by status
  List<ClientModel> get filteredClients {
    switch (selectedFilter.value) {
      case ClientFilter.active:
        return clients.where((c) => c.isActive).toList();
      case ClientFilter.inactive:
        return clients.where((c) => !c.isActive).toList();
      case ClientFilter.priority:
        return clients.where((c) => c.isPriority).toList();
      case ClientFilter.all:
      default:
        return clients;
    }
  }

  /// STEP 2: search on top of filter
  List<ClientModel> get searchedClients {
    if (searchQuery.value.isEmpty) return filteredClients;

    final q = searchQuery.value.toLowerCase();

    return filteredClients.where((c) =>
    c.businessName.toLowerCase().contains(q) ||
        c.contactName.toLowerCase().contains(q)
    ).toList();
  }



  String lastActivityLabel(ClientModel client) {
    if (client.lastOrderDate == null) return 'No activity';

    final diff = DateTime.now().difference(client.lastOrderDate!);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }





  @override
  void onClose() {
    searchCtrl.dispose();
    super.onClose();
  }






}






