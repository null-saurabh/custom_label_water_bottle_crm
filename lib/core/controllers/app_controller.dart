import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppController extends GetxController {
  final isSidebarCollapsed = false.obs;

  void toggleSidebar() {
    isSidebarCollapsed.toggle();
  }

  final userName = 'John'.obs;

  String get todayFormatted =>
      DateFormat('EEEE, MMMM d').format(DateTime.now());

}
