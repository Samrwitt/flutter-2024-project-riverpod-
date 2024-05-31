import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_notebook/models/note_model.dart';

class NotesCard extends ConsumerWidget {
  final Note note;
  final int index;
  final void Function(int) onNoteDeleted;
  final void Function(Note) onNoteBodyEdited;
  final void Function(Note) onNoteTitleEdited;

  const NotesCard({
    Key? key,
    required this.note,
    required this.index,
    required this.onNoteDeleted,
    required this.onNoteBodyEdited,
    required this.onNoteTitleEdited,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            Text(
              note.body,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => _onEditNotePressed(context),
                  icon: const Icon(Icons.edit),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  onPressed: () => onNoteDeleted(index),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onEditNotePressed(BuildContext context) {
    // Show dialog to edit title and body separately
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String editedTitle = note.title;
        String editedBody = note.body;

        return AlertDialog(
          title: const Text('Edit Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: note.title,
                onChanged: (value) => editedTitle = value,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextFormField(
                initialValue: note.body,
                onChanged: (value) => editedBody = value,
                decoration: const InputDecoration(labelText: 'Body'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                note.title = editedTitle;
                note.body = editedBody;
                onNoteTitleEdited(note);
                onNoteBodyEdited(note);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
