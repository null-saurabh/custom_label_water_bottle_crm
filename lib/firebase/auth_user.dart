import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  static User? get _u => FirebaseAuth.instance.currentUser;

  static String get uid => _u?.uid ?? 'anonymous';
  static String get email => _u?.email ?? '';
  static String get name =>
      _u?.displayName ?? (_u?.email?.split('@').first ?? '');
}
