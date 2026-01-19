import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/routes/app_router.dart';
import 'core/routes/bindings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Custom Label Water Bottle Crm',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.dashboard,
      getPages: AppPages.pages,
      defaultTransition: Transition.fade,
    );
  }
}
