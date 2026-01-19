import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppController extends GetxController {


  // App Side Bar

  final selectedMenu = SidebarMenu.dashboard.obs;

  void selectMenu(SidebarMenu menu) {
    selectedMenu.value = menu;
  }


  // Dashboard Header
  final userName = 'John'.obs;

  String get todayFormatted =>
      DateFormat('EEEE, MMMM d').format(DateTime.now());

}

enum SidebarMenu {
  dashboard,
  orders,
  deliveries,
  clients,
  leads,
  inventory,
  sales,
}







