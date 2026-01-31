import 'dart:async';
import 'package:clwb_crm/screens/dashboard/repo/admin_notes_repository.dart';
import 'package:clwb_crm/screens/dashboard/widgets/notes/admin_note_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminNotesController extends GetxController {
  final String adminId; // later: auth uid
  AdminNotesController({required this.adminId});

  final _repo = AdminNotesRepository();

  final isLoading = true.obs;
  final isSaving = false.obs;
  final notes = <AdminNoteModel>[].obs;

  StreamSubscription? _sub;

  @override
  void onInit() {
    super.onInit();
    _sub = _repo.watchNotes(adminId).listen((list) {
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
      await _repo.addNote(adminId: adminId, text: t,);
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar('Error', 'Failed to add note: $e');
      });
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> edit(AdminNoteModel note, String newText) async {
    final t = newText.trim();
    if (t.isEmpty) {
      Get.snackbar('Invalid', 'Note cannot be empty');
      return;
    }

    isSaving.value = true;
    try {
      await _repo.updateNote(adminId: adminId, noteId: note.id, text: t);
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar('Error', 'Failed to update note: $e');
      });
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> remove(AdminNoteModel note) async {
    isSaving.value = true;
    try {
      await _repo.deleteNote(adminId: adminId, noteId: note.id);
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar('Error', 'Failed to delete note: $e');
      });
    } finally {
      isSaving.value = false;
    }
  }
}
