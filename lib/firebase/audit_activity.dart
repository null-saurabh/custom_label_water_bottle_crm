import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/firebase/auth_user.dart';

class Audit {
  static Map<String, dynamic> created() => {
    'createdAt': FieldValue.serverTimestamp(),
    'createdByUid': AuthUser.uid,
    'createdByEmail': AuthUser.email,
    'createdByName': AuthUser.name,
    'updatedAt': FieldValue.serverTimestamp(),
    'updatedByUid': AuthUser.uid,
    'updatedByEmail': AuthUser.email,
    'updatedByName': AuthUser.name,
  };

  static Map<String, dynamic> updated() => {
    'updatedAt': FieldValue.serverTimestamp(),
    'updatedByUid': AuthUser.uid,
    'updatedByEmail': AuthUser.email,
    'updatedByName': AuthUser.name,
  };
}
