import 'dart:async';
import 'package:clwb_crm/screens/client/firebase_repo/client_notes_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clwb_crm/screens/client/models/client_note_model.dart';

class ClientNotesController extends GetxController {
  final String clientId;
  ClientNotesController(this.clientId);

  final _repo = ClientNotesRepository();

  final isLoading = true.obs;
  final isSaving = false.obs;

  final notes = <ClientNoteModel>[].obs;

  StreamSubscription? _sub;

  @override
  void onInit() {
    super.onInit();
    _sub = _repo.watchNotes(clientId).listen((list) {
      notes.assignAll(list);
      isLoading.value = false;
    });
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  Future<void> add(String text) async {
    final t = text.trim();
    if (t.isEmpty) {
      Get.snackbar('Invalid', 'Write something first');
      return;
    }

    isSaving.value = true;
    try {
      await _repo.addNote(
        clientId: clientId,
        text: t,
        createdBy: 'admin', // replace later with auth user
      );
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar('Error', 'Failed to add note: $e');
      });
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> edit(ClientNoteModel note, String newText) async {
    final t = newText.trim();
    if (t.isEmpty) {
      Get.snackbar('Invalid', 'Note cannot be empty');
      return;
    }

    isSaving.value = true;
    try {
      await _repo.updateNote(
        clientId: clientId,
        noteId: note.id,
        text: t,
      );
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar('Error', 'Failed to update note: $e');
      });
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> remove(ClientNoteModel note) async {
    isSaving.value = true;
    try {
      await _repo.deleteNote(
        clientId: clientId,
        noteId: note.id,
      );
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar('Error', 'Failed to delete note: $e');
      });
    } finally {
      isSaving.value = false;
    }
  }
}
