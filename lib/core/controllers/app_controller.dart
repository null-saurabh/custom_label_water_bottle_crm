import 'package:get/get.dart';

class AppController extends GetxController {
  final isSidebarCollapsed = false.obs;

  void toggleSidebar() {
    isSidebarCollapsed.toggle();
  }
}