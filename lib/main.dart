import 'package:clwb_crm/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/routes/app_router.dart';

Future<void> initWebFcm() async {
  final messaging = FirebaseMessaging.instance;

  // Ask permission (web only)
  final settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus != AuthorizationStatus.authorized) {
    print('🔕 Notification permission not granted');
    return;
  }

  final token = await messaging.getToken();
  print('🔥 WEB FCM TOKEN: $token');
}






void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // setupForegroundNotifications();
  await initWebFcm();

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
      // initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      defaultTransition: Transition.fade,
    );
  }
}
