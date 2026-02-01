import 'package:clwb_crm/firebase/fcm_token_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import '../routes/app_router.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


class AppController extends GetxController {
  // =====================
  // NAVIGATION
  // =====================
  final selectedMenu = SidebarMenu.dashboard.obs;

  void selectMenu(SidebarMenu menu) {
    if (selectedMenu.value == menu) return;

    selectedMenu.value = menu;
    Get.rootDelegate.toNamed(menu.route);
  }

  // =====================
  // AUTH STATE
  // =====================
  final Rxn<User> user = Rxn<User>();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // // 🔐 Allowed admins (same as Firestore rules)
  // static const allowedAdmins = [
  //   'sauravalternate1994@gmail.com',
  //   'ishukr304@gmail.com',
  // ];

  @override
  void onInit() {
    super.onInit();

    // 🔥 Bind Firebase auth stream
    user.bindStream(_auth.authStateChanges());
  }

  bool get isAdmin => user.value != null;

  String get todayFormatted =>
      DateFormat('EEEE, MMMM d').format(DateTime.now());

  // =====================
  // AUTH ACTION (USED BY SIDEBAR)
  // =====================
  Future<void> handleAuthAction() async {
    if (isAdmin) {
      await _logout();
    } else {
      await _login();
    }
  }

  // =====================
  // LOGIN
  // =====================

  static const String kGoogleServerClientId =
      '1023430264697-4tqj3r1l6s0nd6jbu9jigr01t2pk8tb8.apps.googleusercontent.com';



  Future<void> _login() async {
    try {
      UserCredential result;

      if (kIsWeb) {
        result = await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
      } else {
        final signIn = GoogleSignIn.instance;

        await signIn.initialize(serverClientId: kGoogleServerClientId);

        final account = await signIn.authenticate(); // may throw "canceled"
        final auth = await account.authentication;

        final credential = GoogleAuthProvider.credential(idToken: auth.idToken);
        result = await FirebaseAuth.instance.signInWithCredential(credential);
      }

      final u = result.user;
      if (u == null) return;

      await _ensureUserDocument(u);
      Get.snackbar('Admin mode enabled', u.email ?? '');
      await FcmTokenService.registerTokenOnce();
    } on GoogleSignInException catch (e) {
      // ✅ User cancelled or system cancelled: don't crash
      if (e.code == GoogleSignInExceptionCode.canceled) {
        Get.snackbar('Sign-in cancelled', 'No changes made');
        return;
      }

      // Other Google sign-in errors should be visible
      Get.snackbar('Sign-in failed', '${e.code}: ${e.description ?? ''}');
      rethrow;
    }
  }



  // =====================
  // LOGOUT
  // =====================
  Future<void> _logout() async {
    // 🔕 Disable notifications for this device
    await FcmTokenService.deactivateToken();

    // 🔐 Firebase logout
    await _auth.signOut();

    Get.snackbar(
      'Logged out',
      'Notifications disabled for this device',
    );
  }


  // =====================
  // USER DOC CREATION
  // =====================
  Future<void> _ensureUserDocument(User u) async {
    final ref = _db.collection('users').doc(u.uid);
    final snap = await ref.get();

    if (snap.exists) return;

    await ref.set({
      'uid': u.uid,
      'email': u.email,
      'name': u.displayName ?? u.email?.split('@').first ?? 'Admin',
      'createdAt': FieldValue.serverTimestamp(),
      'role': 'admin',
      'isActive': true,
    });
  }
}


enum SidebarMenu {
  dashboard,
  orders,
  clients,
  leads,
  inventory,
  sales,
}

extension SidebarMenuRoute on SidebarMenu {
  String get route {
    switch (this) {
      case SidebarMenu.dashboard:
        return AppRoutes.dashboard;
      case SidebarMenu.orders:
        return AppRoutes.orders;
      case SidebarMenu.clients:
        return AppRoutes.clients;
      case SidebarMenu.leads:
        return AppRoutes.leads;
      case SidebarMenu.inventory:
        return AppRoutes.inventory;
      case SidebarMenu.sales:
        return AppRoutes.sales;
    }
  }
}







