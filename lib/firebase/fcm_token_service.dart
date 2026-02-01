import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FcmTokenService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Register FCM token ONCE per device
  /// - Requires admin login
  /// - Token is NOT deleted on logout
  /// - Safe for Web + Android
  static Future<void> registerTokenOnce() async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint('⏸️ FCM: user not logged in, skipping token registration');
      return;
    }

    final token = await _messaging.getToken();
    if (token == null) {
      debugPrint('❌ FCM: token is null');
      return;
    }

    final ref = _db.collection('admin_devices').doc(token);
    final snap = await ref.get();

    // ✅ Token already exists → REACTIVATE
    if (snap.exists) {
      await ref.update({
        'isActive': true,
        'lastSeenAt': FieldValue.serverTimestamp(),
        'uid': user.uid,
        'email': user.email,
      });

      debugPrint('♻️ FCM: token reactivated');
      return;
    }

    // 🆕 First time registration
    await ref.set({
      'token': token,
      'platform': kIsWeb ? 'web' : 'android',
      'uid': user.uid,
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
      'lastSeenAt': FieldValue.serverTimestamp(),
      'isActive': true,
    });

    debugPrint('✅ FCM: token registered successfully');
  }


  static Future<void> deactivateToken() async {
    final token = await _messaging.getToken();
    if (token == null) return;

    await _db.collection('admin_devices').doc(token).update({
      'isActive': false,
      'lastSeenAt': FieldValue.serverTimestamp(),
    });

    print('🔕 FCM token deactivated');
  }


  /// Optional: update activity timestamp
  static Future<void> markActive() async {
    final token = await _messaging.getToken();
    if (token == null) return;

    await _db.collection('admin_devices').doc(token).update({
      'lastSeenAt': FieldValue.serverTimestamp(),
      'isActive': true,
    });
  }
}
