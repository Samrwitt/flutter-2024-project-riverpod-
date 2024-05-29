import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_notebook/models/note_model.dart';

class NotesCard extends ConsumerWidget {
  final Note note;
  final int index;
  final void Function(int) onNoteDeleted;
  final void Function(Note) onNoteEdited;

  const NotesCard({
    Key? key,
    required this.note,
    required this.index,
    required this.onNoteDeleted,
    required this.onNoteEdited,
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
                  onPressed: () => onNoteEdited(note),
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
}