import 'dart:html' as html; // web only
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FcmTokenService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Detect iOS Safari (web)
  static bool get _isIOSWeb {
    if (!kIsWeb) return false;
    final ua = html.window.navigator.userAgent.toLowerCase();
    return ua.contains('iphone') ||
        ua.contains('ipad') ||
        ua.contains('ipod');
  }

  /// Ask permission on WEB (desktop / android web only)
  static Future<void> initWebPermissions() async {
    if (!kIsWeb || _isIOSWeb) return;

    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      debugPrint('🔕 Web notification permission denied');
      return;
    }

    debugPrint('✅ Web notification permission granted');
  }

  /// Register token AFTER login
  static Future<void> registerTokenOnce() async {
    // 🚫 Hard stop on iOS Safari
    if (kIsWeb && _isIOSWeb) {
      debugPrint('🍎 iOS Web → skipping FCM token registration');
      return;
    }

    final user = _auth.currentUser;
    if (user == null) return;

    final messaging = FirebaseMessaging.instance;
    final token = await messaging.getToken();

    if (token == null) {
      debugPrint('❌ FCM token is null');
      return;
    }

    final ref = _db.collection('admin_devices').doc(token);
    final snap = await ref.get();

    if (snap.exists) {
      await ref.update({
        'isActive': true,
        'lastSeenAt': FieldValue.serverTimestamp(),
        'uid': user.uid,
        'email': user.email,
      });
      debugPrint('♻️ FCM token reactivated');
      return;
    }

    await ref.set({
      'token': token,
      'platform': kIsWeb ? 'web' : 'android',
      'uid': user.uid,
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
      'lastSeenAt': FieldValue.serverTimestamp(),
      'isActive': true,
    });

    debugPrint('✅ FCM token registered');
  }

  /// Disable notifications on logout
  static Future<void> deactivateToken() async {
    if (kIsWeb && _isIOSWeb) return;

    final messaging = FirebaseMessaging.instance;
    final token = await messaging.getToken();
    if (token == null) return;

    await _db.collection('admin_devices').doc(token).update({
      'isActive': false,
      'lastSeenAt': FieldValue.serverTimestamp(),
    });

    debugPrint('🔕 FCM token deactivated');
  }
}
