import 'package:cloud_firestore/cloud_firestore.dart';

class AdminNoteModel {
  final String id;
  final String text;

  // 🔥 Audit (write via Audit.created()/updated())
  final String createdByUid;
  final String createdByEmail;
  final String createdByName;

  final String updatedByUid;
  final String updatedByEmail;
  final String updatedByName;

  final DateTime createdAt;
  final DateTime updatedAt;


  AdminNoteModel({
    required this.id,
    required this.text,

    required this.createdByUid,
    required this.createdByEmail,
    required this.createdByName,

    required this.updatedByUid,
    required this.updatedByEmail,
    required this.updatedByName,

    required this.createdAt,
    required this.updatedAt,
  });


  factory AdminNoteModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    DateTime dt(dynamic v) {
      if (v is Timestamp) return v.toDate();
      if (v is DateTime) return v;
      if (v is String) return DateTime.tryParse(v) ?? DateTime.fromMillisecondsSinceEpoch(0);
      return DateTime.fromMillisecondsSinceEpoch(0);
    }


    return AdminNoteModel(
      id: doc.id,
      text: (d['text'] ?? '').toString(),

      createdByUid: (d['createdByUid'] ?? '').toString(),
      createdByEmail: (d['createdByEmail'] ?? '').toString(),
      createdByName: (d['createdByName'] ?? (d['createdBy'] ?? 'admin')).toString(),

      updatedByUid: (d['updatedByUid'] ?? '').toString(),
      updatedByEmail: (d['updatedByEmail'] ?? '').toString(),
      updatedByName: (d['updatedByName'] ?? (d['createdBy'] ?? 'admin')).toString(),

      createdAt: dt(d['createdAt']),
      updatedAt: dt(d['updatedAt']),
    );

  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,

      'createdByUid': createdByUid,
      'createdByEmail': createdByEmail,
      'createdByName': createdByName,

      'updatedByUid': updatedByUid,
      'updatedByEmail': updatedByEmail,
      'updatedByName': updatedByName,

      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  String get createdByDisplay =>
      createdByName.isNotEmpty ? createdByName : (createdByEmail.isNotEmpty ? createdByEmail : 'admin');

}



