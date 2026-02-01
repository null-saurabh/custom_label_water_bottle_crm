import 'package:clwb_crm/screens/client/screens/client_list_panel/client_list_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'client_controller.dart';

class ClientsMobileListScreen extends GetView<ClientsController> {
  const ClientsMobileListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: ClientListPanel(),
    );
  }
}
