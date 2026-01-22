import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_detail_panel.dart';
import 'package:clwb_crm/screens/client/screens/client_list_panel/client_list_panel.dart';
import 'package:flutter/material.dart';

class ClientsSplitScreen extends StatelessWidget {
  const ClientsSplitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: Row(
        children: const [
          SizedBox(
            width: 320,
            child: ClientListPanel(),
          ),
          Expanded(
            child: ClientDetailScreen(),
          ),
        ],
      ),
    );
  }
}
