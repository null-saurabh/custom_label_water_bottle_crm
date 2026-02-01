// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';

// import 'dart:html' as html;

// void setupForegroundNotifications() {
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     final notification = message.notification;
//     if (notification == null) return;
//
//     // ✅ WEB ONLY
//     if (kIsWeb) {
//       // Request permission once
//       if (html.Notification.permission != 'granted') {
//         html.Notification.requestPermission();
//         return;
//       }
//
//       html.Notification(
//         notification.title ?? 'Ink & Drink',
//         body: notification.body ?? '',
//         icon: '/icons/Icon-192.png',
//       );
//     }
//   });
// }
