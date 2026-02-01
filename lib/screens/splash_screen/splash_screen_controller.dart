import 'package:clwb_crm/core/routes/app_init_service.dart';
import 'package:get/get.dart';
import '../../core/routes/app_router.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _boot();
  }

  Future<void> _boot() async {
    // Ensure splash paints first
    await Future.delayed(const Duration(milliseconds: 80));

    await AppInitService.init();

    // Go to your shell once dependencies are ready
    Get.offAllNamed(AppRoutes.shell);
  }
}
