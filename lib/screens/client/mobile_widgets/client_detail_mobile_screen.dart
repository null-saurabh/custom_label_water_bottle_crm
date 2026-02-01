import 'package:clwb_crm/screens/client/client_controller.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_detail_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientDetailMobileScreen extends GetView<ClientsController> {
  const ClientDetailMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      // appBar: AppBar(
      //   title: Text(
      //     controller.selectedClient?.businessName ?? 'Client',
      //   ),
      //   leading: BackButton(
      //     onPressed: () {
      //       controller.clearSelection();
      //       Get.back();
      //     },
      //   ),
      // ),
      body: const ClientDetailScreen(),
    );
  }
}
