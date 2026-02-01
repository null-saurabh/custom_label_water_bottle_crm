import 'dart:html' as html; // web only
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'core/routes/app_router.dart';
import 'firebase/fcm_token_service.dart';

/// Detect iOS Safari / iOS WebView
bool get _isIOSWeb {
  if (!kIsWeb) return false;
  final ua = html.window.navigator.userAgent.toLowerCase();
  return ua.contains('iphone') ||
      ua.contains('ipad') ||
      ua.contains('ipod');
}

/// Initialize Web FCM (DESKTOP + ANDROID WEB ONLY)
Future<void> _initWebFcmSafely() async {
  if (!kIsWeb) return;
  if (_isIOSWeb) {
    debugPrint('🍎 iOS Web detected → skipping Web FCM init');
    return;
  }

  await FcmTokenService.initWebPermissions();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🚫 NEVER touch FirebaseMessaging on iOS Safari
  await _initWebFcmSafely();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ink & Drink CRM',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      defaultTransition: Transition.fade,
    );
  }
}
