import 'package:get/get.dart';

enum OrderDetailTab {
  overview,
  production,
  activity,
}


class OrderDetailTabsController extends GetxController {
  final selectedTab = OrderDetailTab.overview.obs;

  void selectTab(OrderDetailTab tab) {
    selectedTab.value = tab;
  }

  void reset() {
    selectedTab.value = OrderDetailTab.overview;
  }
}
