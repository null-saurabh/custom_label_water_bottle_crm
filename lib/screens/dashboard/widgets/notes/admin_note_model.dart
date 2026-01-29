import 'package:cloud_firestore/cloud_firestore.dart';

class AdminNoteModel {
  final String id;
  final String text;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdminNoteModel({
    required this.id,
    required this.text,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminNoteModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    DateTime dt(dynamic v) {
      if (v is Timestamp) return v.toDate();
      if (v is DateTime) return v;
      return DateTime.now();
    }

    return AdminNoteModel(
      id: doc.id,
      text: (d['text'] ?? '') as String,
      createdBy: (d['createdBy'] ?? 'admin') as String,
      createdAt: dt(d['createdAt']),
      updatedAt: dt(d['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
