import 'package:cloud_firestore/cloud_firestore.dart';

class ClientNoteModel {
  final String id;
  final String clientId;

  final String text;
  final String createdBy;

  final DateTime createdAt;
  final DateTime updatedAt;

  ClientNoteModel({
    required this.id,
    required this.clientId,
    required this.text,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
    'clientId': clientId,
    'text': text,
    'createdBy': createdBy,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };

  factory ClientNoteModel.fromDoc(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>? ?? {});
    DateTime _dt(dynamic v) {
      if (v is Timestamp) return v.toDate();
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    return ClientNoteModel(
      id: doc.id,
      clientId: (data['clientId'] ?? '').toString(),
      text: (data['text'] ?? '').toString(),
      createdBy: (data['createdBy'] ?? 'system').toString(),
      createdAt: _dt(data['createdAt']),
      updatedAt: _dt(data['updatedAt']),
    );
  }

  ClientNoteModel copyWith({
    String? text,
    DateTime? updatedAt,
  }) {
    return ClientNoteModel(
      id: id,
      clientId: clientId,
      text: text ?? this.text,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
