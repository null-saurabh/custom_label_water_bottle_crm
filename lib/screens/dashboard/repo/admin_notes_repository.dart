import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/dashboard/widgets/notes/admin_note_model.dart';

class AdminNotesRepository {
  final _db = FirebaseFirestore.instance;

  // You can swap adminId later with real auth uid.
  CollectionReference<Map<String, dynamic>> _notesRef(String adminId) =>
      _db.collection('admin_notes').doc(adminId).collection('notes');

  Stream<List<AdminNoteModel>> watchNotes(String adminId) {
    return _notesRef(adminId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => AdminNoteModel.fromDoc(d)).toList());
  }

  Future<void> addNote({
    required String adminId,
    required String text,
    required String createdBy,
  }) async {
    final now = DateTime.now();
    final ref = _notesRef(adminId).doc();

    final note = AdminNoteModel(
      id: ref.id,
      text: text,
      createdBy: createdBy,
      createdAt: now,
      updatedAt: now,
    );

    await ref.set(note.toMap());
  }

  Future<void> updateNote({
    required String adminId,
    required String noteId,
    required String text,
  }) async {
    await _notesRef(adminId).doc(noteId).update({
      'text': text,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteNote({
    required String adminId,
    required String noteId,
  }) async {
    await _notesRef(adminId).doc(noteId).delete();
  }
}
