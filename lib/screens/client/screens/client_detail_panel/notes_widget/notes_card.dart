import 'package:clwb_crm/core/utils/responsive.dart';
import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:clwb_crm/screens/client/models/client_note_model.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/client_stat_widget/stat_card.dart';
import 'package:clwb_crm/screens/client/screens/client_detail_panel/notes_widget/client_notes_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotesCard extends StatelessWidget {
  final ClientModel client;

  const NotesCard({
    super.key,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    // tag by clientId so each client has its own notes stream/controller
    final c = Get.put(
      ClientNotesController(client.id),
      tag: client.id,
    );

    return StatCard(
      height: context.isMobile ? 500 :299,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Notes',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Add note',
                onPressed: () => _openAddDialog(context, c),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Expanded(
            child: Obx(() {
              if (c.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (c.notes.isEmpty) {
                return Text(
                  'No notes yet',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                );
              }

              return ListView.separated(
                itemCount: c.notes.length,
                separatorBuilder: (_, __) => const Divider(height: 12),
                itemBuilder: (_, i) {
                  final note = c.notes[i];
                  return _NoteTile(
                    note: note,
                    onEdit: () => _openEditDialog(context, c, note),
                    onDelete: () => _confirmDelete(context, c, note),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _openAddDialog(BuildContext context, ClientNotesController c) {
    final ctrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Add Note'),
        content: TextField(
          controller: ctrl,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Write note...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          Obx(() {
            return ElevatedButton(
              onPressed: c.isSaving.value
                  ? null
                  : () async {
                await c.add(ctrl.text);
                if (Get.isDialogOpen == true) Get.back();
              },
              child: Text(c.isSaving.value ? 'Saving...' : 'Save'),
            );
          }),
        ],
      ),
    );
  }

  void _openEditDialog(
      BuildContext context,
      ClientNotesController c,
      ClientNoteModel note,
      ) {
    final ctrl = TextEditingController(text: note.text);
    Get.dialog(
      AlertDialog(
        title: const Text('Edit Note'),
        content: TextField(
          controller: ctrl,
          maxLines: 5,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          Obx(() {
            return ElevatedButton(
              onPressed: c.isSaving.value
                  ? null
                  : () async {
                await c.edit(note, ctrl.text);
                if (Get.isDialogOpen == true) Get.back();
              },
              child: Text(c.isSaving.value ? 'Saving...' : 'Update'),
            );
          }),
        ],
      ),
    );
  }

  void _confirmDelete(
      BuildContext context,
      ClientNotesController c,
      ClientNoteModel note,
      ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete note?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          Obx(() {
            return ElevatedButton(
              onPressed: c.isSaving.value
                  ? null
                  : () async {
                await c.remove(note);
                if (Get.isDialogOpen == true) Get.back();
              },
              child: Text(c.isSaving.value ? 'Deleting...' : 'Delete'),
            );
          }),
        ],
      ),
    );
  }
}

class _NoteTile extends StatelessWidget {
  final ClientNoteModel note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _NoteTile({
    required this.note,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dt = DateFormat('d MMM, h:mm a').format(note.updatedAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          note.text,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Text(
                dt,
                style: TextStyle(
                  fontSize: 11.5,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Edit',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: 18),
            ),
            IconButton(
              tooltip: 'Delete',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, size: 18),
            ),
          ],
        ),
      ],
    );
  }
}
