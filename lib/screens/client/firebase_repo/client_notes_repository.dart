import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clwb_crm/screens/client/models/client_note_model.dart';

class ClientNotesRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _notesRef(String clientId) =>
      _db.collection('clients').doc(clientId).collection('notes');

  Stream<List<ClientNoteModel>> watchNotes(String clientId) {
    return _notesRef(clientId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => ClientNoteModel.fromDoc(d)).toList());
  }

  Future<void> addNote({
    required String clientId,
    required String text,
    required String createdBy,
  }) async {
    final now = DateTime.now();
    final ref = _notesRef(clientId).doc();

    final note = ClientNoteModel(
      id: ref.id,
      clientId: clientId,
      text: text,
      createdBy: createdBy,
      createdAt: now,
      updatedAt: now,
    );

    await ref.set(note.toMap());
  }

  Future<void> updateNote({
    required String clientId,
    required String noteId,
    required String text,
  }) async {
    await _notesRef(clientId).doc(noteId).update({
      'text': text,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteNote({
    required String clientId,
    required String noteId,
  }) async {
    await _notesRef(clientId).doc(noteId).delete();
  }
}
