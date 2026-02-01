import 'package:clwb_crm/screens/client/client_mobile_list_screen.dart';
import 'package:clwb_crm/screens/client/client_split_screen_desktop.dart';
import 'package:flutter/material.dart';
import 'package:clwb_crm/core/utils/responsive.dart';


class ClientShellPage extends StatelessWidget {
  const ClientShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return const ClientsMobileListScreen();
    }
    return const ClientsSplitScreen();
  }
}
