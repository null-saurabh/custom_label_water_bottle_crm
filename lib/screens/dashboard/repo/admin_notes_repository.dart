import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/firebase/audit_activity.dart';
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
  }) async {
    final ref = _notesRef(adminId).doc();


    await ref.set({
      'text': text,
      ...Audit.created(),
    });
  }

  Future<void> updateNote({
    required String adminId,
    required String noteId,
    required String text,
  }) async {
    await _notesRef(adminId).doc(noteId).update({
      'text': text,
      ...Audit.updated(),
    });

  }

  Future<void> deleteNote({
    required String adminId,
    required String noteId,
  }) async {
    await _notesRef(adminId).doc(noteId).delete();
  }
}
