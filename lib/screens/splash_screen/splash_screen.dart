import 'package:clwb_crm/screens/splash_screen/splash_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is created for this route
    final c = Get.put(SplashController(), permanent: true);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FD),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icons/main_logo.png',
              height: 92,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            const Text(
              'Ink & Drink CRM',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2A44),
              ),
            ),
            const SizedBox(height: 18),
            const SizedBox(
              width: 180,
              child: LinearProgressIndicator(minHeight: 6),
            ),
          ],
        ),
      ),
    );
  }
}
