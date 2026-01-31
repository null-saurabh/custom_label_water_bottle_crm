// lib/features/dashboard/widgets/inventory_warning_card.dart

import 'package:clwb_crm/core/utils/responsive.dart';
import 'package:clwb_crm/screens/dashboard/widgets/inventory_warning_card/inventory_warning_card_desktop.dart';
import 'package:clwb_crm/screens/dashboard/widgets/inventory_warning_card/inventory_warning_card_mobile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:clwb_crm/screens/inventory/inventory_controller.dart';





class InventoryWarningCardShell extends GetView<InventoryController> {
  const InventoryWarningCardShell({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return isMobile
        ? InventoryWarningCardMobile()
        : InventoryWarningCardDesktop();
  }

}













